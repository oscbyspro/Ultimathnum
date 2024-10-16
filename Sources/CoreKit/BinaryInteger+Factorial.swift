//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Factorial
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `factorial` of `self` and an `error` indicator, or `nil`.
    ///
    /// ```swift
    /// U8(0).factorial() // U8.exactly(   1)
    /// U8(1).factorial() // U8.exactly(   1)
    /// U8(2).factorial() // U8.exactly(   2)
    /// U8(3).factorial() // U8.exactly(   6)
    /// U8(4).factorial() // U8.exactly(  24)
    /// U8(5).factorial() // U8.exactly( 120)
    /// U8(6).factorial() // U8.exactly( 720)
    /// U8(7).factorial() // U8.exactly(5040)
    /// ```
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It returns `nil` if the operation is `undefined`.
    ///
    /// - Note: `T.Magnitude` guarantees nonoptional results.
    ///
    @inlinable public borrowing func factorial() -> Optional<Fallible<Self>> {
        if  self.isNegative {
            return nil
            
        }   else if self.isInfinite {
            // lots of even factors
            return Self.zero.veto()
            
        }   else if Self.size <= UX.size {
            // save some code size w.r.t. small integers
            typealias Algorithm = Namespace.Factorial<UX>
            // the magnitude path is a bit faster
            let small = UX(load: self)
            let magnitude = Algorithm.element(unchecked: small)
            return magnitude.map{Self.exactly(magnitude: $0)}
            
        }   else {
            // save some code size w.r.t. signed binary integers
            typealias Algorithm = Namespace.Factorial<Magnitude>
            // clamping works because the allocation limit is IX.max
            let small = UX(clamping: self)
            let magnitude = Algorithm.element(unchecked: small)
            return magnitude.map{Self.exactly(magnitude: $0)}
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Factorial x Unsigned
//*============================================================================*

extension UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `factorial` of `self` and an `error` indicator.
    ///
    /// ```swift
    /// U8(0).factorial() // U8.exactly(   1)
    /// U8(1).factorial() // U8.exactly(   1)
    /// U8(2).factorial() // U8.exactly(   2)
    /// U8(3).factorial() // U8.exactly(   6)
    /// U8(4).factorial() // U8.exactly(  24)
    /// U8(5).factorial() // U8.exactly( 120)
    /// U8(6).factorial() // U8.exactly( 720)
    /// U8(7).factorial() // U8.exactly(5040)
    /// ```
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public borrowing func factorial() -> Fallible<Self> {
        (self.factorial() as Optional).unchecked("UnsignedInteger")
    }
}

//*============================================================================*
// MARK: * Binary Integer x Factorial x Algorithm
//*============================================================================*

extension Namespace {
    
    /// ### Factorial
    ///
    /// A multiplication sequence identified by its `index` factor.
    ///
    ///     0! == 1
    ///     1! == 1
    ///     2! == 1 * 2
    ///     3! == 1 * 2 * 3
    ///     4! == 1 * 2 * 3 * 4
    ///     5! == 1 * 2 * 3 * 4 * 5
    ///     6! == 1 * 2 * 3 * 4 * 5 * 6
    ///     7! == 1 * 2 * 3 * 4 * 5 * 6 * 7
    ///
    /// ### Algorithm
    ///
    /// This is a loose adaptation of `SplitRecursive` by Peter Luschny.
    ///
    /// - Seealso: https://www.luschny.de/math/factorial/FastFactorialFunctions.htm
    ///
    @frozen @usableFromInline struct Factorial<Value> where Value: UnsignedInteger {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        /// The current `factor`.
        ///
        /// - Note: It is odd.
        ///
        @usableFromInline var factor: Value
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init() {
            self.factor = 1
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        @inlinable mutating func next(_ count: Nonzero<UX>) -> Fallible<Value> {
            switch count.value {
            case 1:
                self.factor &+= 2
                return Fallible(self.factor)
                
            case 2:
                let low = self.factor.plus(2).unchecked()
                self.factor = ((low)).plus(2).unchecked()
                return low.times(self.factor)
                
            default:
                let half = count.value.down(Shift.one)
                let low  = self.next(Nonzero(unchecked: count.value &- half))
                let high = self.next(Nonzero(unchecked: half))
                return low.value.times(high.value).veto(low.error).veto(high.error)
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        /// Returns the `factorial` of `index` and an `error` indicator.
        ///
        /// - Requires: `index <= Value.max`
        ///
        /// - Note: The `error` is set if the operation is `lossy`.
        ///
        @inlinable static func element(unchecked index: UX) -> Fallible<Value> {
            //=----------------------------------=
            Swift.assert(index <= Value.max)
            //=----------------------------------=
            var value = Value.lsb
            var error = false
            
            if  index <= 1 {
                return value.veto(error)
            }
            //=----------------------------------=
            let ones = UX(raw: index.count(Bit.one))
            let twos = index.minus(ones).unchecked()
            let distance = Count(raw: twos)
            //=----------------------------------=
            // fast: overshift by even factors
            //=----------------------------------=
            if  let size = UX(size: Value.self), size <= index {
                error = true
                
            }   else {
                var products = Factorial() // chunked odd sequence product
                var sequence = Value.lsb   // odd sequence product
                
                var high  = UX.lsb // first is pointless, down 1 to skip 1
                var ilog2 = Nonzero(unchecked: index.down(Shift.one)).ilog2()
                
                brrrrr: while true {
                    let low = high
                    high = index.down(Shift(unchecked: ilog2))
                    high = high.decremented().unchecked() | 1
                    
                    let step = high.minus(low).unchecked().down(Shift.one)
                    if  let step = Nonzero(exactly: step) {
                        let next = products.next (step).sink(&error)
                        sequence = sequence.times(next).sink(&error)
                        value = value.times((sequence)).sink(&error)
                    }
                    
                    guard !ilog2.isZero else { break }
                    ilog2 = Count(raw: UX(raw: ilog2).decremented().value)
                }
                
                if  value.descending(Bit.zero) < distance {
                    error = true
                }
            }
            
            return  value.up(distance).veto(error)
        }
    }
}
