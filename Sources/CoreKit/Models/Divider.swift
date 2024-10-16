//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Divider
//*============================================================================*

/// An integer divider.
///
/// It finds magic constants satisfying this full-size expression:
///
///     x / div == (x * mul + add) >> shr
///
@frozen public struct Divider<Value>: Equatable, Guarantee, Sendable where Value: SystemsInteger & UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static func predicate(_ value: borrowing Value) -> Bool {
        Nonzero.predicate(value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The `div` constant of this divider.
    public let div: Value
    
    /// The `mul` constant of this divider.
    public let mul: Value
    
    /// The `add` constant of this divider.
    public let add: Value
    
    /// The `shr` constant of this divider.
    public let shr: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(unsafe  value: Value) {
        self.init(Nonzero (unsafe: value))
    }
    
    /// Finds magic constants suitable for the given `divisor`.
    @inlinable public init(_ divisor: consuming Nonzero<Value>) {
        let subshift = UX(raw: divisor.ilog2())
        let subpower = Value.lsb &<< subshift
        
        if  divisor.value == subpower {
            // x × max + max -> high: x
            self.mul = Value.max
            self.add = Value.max
            
        }   else {
            let power =  Doublet(low: Value.min, high: subpower)
            let division = Value.division(power, by: divisor).unchecked()
            // subpower < divisor < 2 × subpower
            Swift.assert(subpower < divisor.value)
            Swift.assert(subpower > divisor.value.down(Count(1)))
            Swift.assert(00000000 < division.remainder)
            //  ⌊a÷b⌋ == ⌊(a+1)×⌊power÷b⌋÷power⌋ when error <= subpower
            //  ⌊a÷b⌋ == ⌊(a+0)×⌈power÷b⌉÷power⌋ when error <= subpower
            //  takes the path with no increment when error == subpower
            if  division.remainder < subpower {
                Swift.assert(subpower >= division.remainder)
                self.mul = division.quotient
                self.add = division.quotient
                
            }   else {
                Swift.assert(subpower >= divisor.value - division.remainder)
                self.mul = division.quotient.incremented().unchecked()
                self.add = Value.min
            }
        }
        
        self.div = (consume    divisor).value
        self.shr = Value(load: UX(size: Value.self).plus(subshift).unchecked())
    }
}

//*============================================================================*
// MARK: * Divider x 2 by 1
//*============================================================================*

/// A 2-by-1 integer divider.
///
/// It finds magic constants satisfying this full-size expression:
///
///     x / div == (x * mul + add) >> shr
///
/// ### Development
///
/// - TODO: Consider a DoubleableInteger constraint.
///
@frozen public struct Divider21<Value>: Equatable, Guarantee, Sendable where Value: SystemsInteger & UnsignedInteger {

    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static func predicate(_ value: borrowing Value) -> Bool {
        Nonzero.predicate(value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The `div` constant of this divider.
    public let div: Value
    
    /// The `mul` constant of this divider.
    public let mul: Doublet<Value>
    
    /// The `add` constant of this divider.
    public let add: Doublet<Value>
    
    /// The `shr` constant of this divider.
    public let shr: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(unsafe  value: consuming Value) {
        self.init(Nonzero (unsafe: value))
    }
    
    /// Finds magic constants suitable for the given `divisor`.
    @inlinable public init(_ divisor: consuming Nonzero<Value>) {
        let subshift = UX(raw: divisor.ilog2())
        let subpower = Value.lsb &<< subshift
        
        if  divisor.value == subpower {
            // x × max + max -> high: x
            self.mul = Doublet(low: .max, high: .max)
            self.add = Doublet(low: .max, high: .max)
            
        }   else {
            var remainder = subpower
            var quotient  = Doublet<Value>()
            (quotient.high, remainder) = Value.division(Doublet(low: quotient.high, high: remainder), by: divisor).unchecked().components()
            (quotient.low,  remainder) = Value.division(Doublet(low: quotient.low,  high: remainder), by: divisor).unchecked().components()
            // subpower < divisor < 2 × subpower
            Swift.assert(subpower < divisor.value)
            Swift.assert(subpower > divisor.value.down(Count(1)))
            Swift.assert(00000000 < remainder)
            //  ⌊a÷b⌋ == ⌊(a+1)×⌊power÷b⌋÷power⌋ when error <= subpower
            //  ⌊a÷b⌋ == ⌊(a+0)×⌈power÷b⌉÷power⌋ when error <= subpower
            //  takes the path with no increment when error == subpower
            if  remainder < subpower {
                Swift.assert(subpower >= remainder)
                self.mul = quotient
                self.add = quotient
                
            }   else {
                Swift.assert(subpower >= divisor.value - remainder)
                
                var bit: Bool
                (quotient.low, bit) = quotient.low.incremented().components()
                (quotient.high) = quotient.high.incremented(bit).unchecked ()
                
                self.mul = quotient
                self.add = Doublet()
            }
        }
        
        self.div = (consume    divisor).value
        self.shr = Value(load: UX(size: Value.self).times(2).unchecked().plus(subshift).unchecked())
    }
}
