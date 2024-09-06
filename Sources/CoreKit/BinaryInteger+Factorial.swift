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
    
    /// The `factorial` of `self` or `nil`.
    @inlinable public /*borrowing*/ func factorial() -> Optional<Self> {
        if  self.isNegative { return nil }
        let magnitude = Magnitude(raw: self).factorial()
        if  magnitude.error { return nil }
        return Self.exactly(magnitude: magnitude.value).optional()
    }
}

//*============================================================================*
// MARK: * Binary Integer x Factorial x Unsigned
//*============================================================================*

extension UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// The `factorial` of `self` and an `error` indicator.
    @inlinable public /*borrowing*/ func factorial() -> Fallible<Self> {
        if  self.isInfinite {
            // lots of even factors
            return Self.zero.veto()
            
        }   else if Self.size <= UX.size {
            // save some code size w.r.t. small integers
            typealias   Algorithm = Namespace.Factorial<UX>
            let small = Algorithm.unchecked(UX(load: self))
            return Self.exactly(small.value).veto(small.error)
            
        }   else {
            // clamping works because the allocation limit is IX.max
            return Namespace.Factorial.unchecked(UX(clamping: self))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension Fallible where Value: UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// The `factorial` of `self` and an `error` indicator.
    @inlinable public borrowing func factorial() -> Self {
        self.value.factorial().veto(self.error)
    }
}

//*============================================================================*
// MARK: * Binary Integer x Factorial x Algorithms
//*============================================================================*

extension Namespace {
    
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
                let product = ((low)).times(self.factor)
                return product
                
            default:
                let half = count.value.down(Shift.one)
                let low  = self.next(Nonzero(unchecked: count.value.minus(half).unchecked()))
                let high = self.next(Nonzero(unchecked: half))
                return low.times(high)
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        /// Returns the `factorial` of `instance` and an `error` indicator.
        ///
        /// - Requires: `instance <= Value.max`
        ///
        @inlinable static func unchecked(_ instance: UX) -> Fallible<Value> {
            //=----------------------------------=
            Swift.assert(instance <= Value.max)
            //=----------------------------------=
            var result = Fallible(Value.lsb)
            if  instance <= 1 {
                return result
            }
            //=----------------------------------=
            let ones = UX(raw: instance.count(Bit.one))
            let twos = instance.minus(ones).unchecked()
            let distance = Count<IX>(raw: consume twos)
            //=----------------------------------=
            // fast: overshift by even factors
            //=----------------------------------=
            if  let size = UX(size: Value.self), size <= instance {
                result.error = true
                
            }   else {
                var products = Factorial() // chunked odd sequence product
                var sequence = Fallible(Value.lsb) // odd sequence product
                
                var high  = UX.lsb
                var ilog2 = Nonzero(unchecked: instance).ilog2()
                
                brrrrr: while true {
                    let low = high
                    high = instance.down(Shift(unchecked: ilog2))
                    high = high.decremented().unchecked() | 1
                    
                    if  let stride = Nonzero(exactly: high.minus(low).unchecked().down(Shift.one)) {
                        let next = products.next (stride)
                        sequence = sequence.times((next))
                        (result) = sequence.times(result)
                    }
                    
                    guard !ilog2.isZero else { break }
                    ilog2 = Count(raw: UX(raw: ilog2).decremented().value)
                }
                
                if  result.value.descending(Bit.zero) < distance {
                    result.error = true
                }
            }

            return  result.value.up(distance).veto(result.error)
        }
    }
}
