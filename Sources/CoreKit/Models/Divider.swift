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
/// It finds magic constants such that `A` and `B` are equivalent double-size
/// expressions for all same-size dividends:
///
///     A) (dividend / divisor)
///     B) (dividend * multiplier + increment) >> shift
///
/// - Note: It performs division by multiplication, addition, and shifts.
///
/// - Note: Its constants are all same-size integers (mul-add-shr).
///
@frozen public struct Divider<Value> where Value: SystemsInteger & UnsignedInteger {

    public typealias Value = Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The divisor of this divider.
    public let divisor: Value
    
    /// The multiplier of this divider.
    public let multiplier: Value
    
    /// The increment of this divider.
    public let increment: Value
    
    /// The shift of this divider.
    public let shift: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<Error>(_ divisor: consuming Value, prune error: @autoclosure () -> Error) throws where Error: Swift.Error {
        self.init(try Nonzero(divisor, prune: error()))
    }
    
    @inlinable public init?(exactly divisor: consuming Value) {
        guard let divisor = Nonzero(exactly: divisor) else { return nil }
        self.init(divisor)
    }
    
    @inlinable public init(unchecked divisor: consuming Value) {
        self.init(Nonzero(unchecked: divisor))
    }
    
    @inlinable public init(_ divisor: consuming Value) {
        self.init(Nonzero(divisor))
    }
    
    @inlinable public init(_ divisor: consuming Nonzero<Value>) {
        let subshift = UX(raw: divisor.ilog2())
        let subpower = Value.lsb &<< subshift
        
        if  divisor.value == subpower {
            // x × max + max: high == x
            self.multiplier = Value.max
            self.increment  = Value.max
        
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
                self.multiplier = division.quotient
                self.increment  = division.quotient
                
            }   else {
                Swift.assert(subpower >= divisor.value - division.remainder)
                self.multiplier = division.quotient.incremented().unchecked()
                self.increment  = Value.min
            }
        }
        
        self.divisor = (consume  divisor).value
        self.shift = Value(load: UX(size: Value.self).plus(subshift).unchecked())
    }
}

//*============================================================================*
// MARK: * Divider x 2 by 1
//*============================================================================*

/// A 2-by-1 integer divider.
///
/// It finds magic constants such that `A` and `B` are equivalent quadruple-size
/// expressions for all double-size dividends:
///
///     A) (dividend / divisor)
///     B) (dividend * multiplier + increment) >> shift
///
/// - Note: It performs division by multiplication, addition, and shifts.
///
/// ### Development
///
/// - TODO: Consider a DoubleableInteger constraint.
///
@frozen public struct Divider21<Value> where Value: SystemsInteger & UnsignedInteger {

    public typealias Value = Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The divisor of this divider.
    public let divisor: Value
    
    /// The multiplier of this divider.
    public let multiplier: Doublet<Value>
    
    /// The increment of this divider.
    public let increment: Doublet<Value>
    
    /// The shift of this divider.
    public let shift: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<Error>(_ divisor: consuming Value, prune error: @autoclosure () -> Error) throws where Error: Swift.Error {
        self.init(try Nonzero(divisor, prune: error()))
    }
    
    @inlinable public init?(exactly divisor: consuming Value) {
        guard let divisor = Nonzero(exactly: divisor) else { return nil }
        self.init(divisor)
    }
    
    @inlinable public init(unchecked divisor: consuming Value) {
        self.init(Nonzero(unchecked: divisor))
    }
    
    @inlinable public init(_ divisor: consuming Value) {
        self.init(Nonzero(divisor))
    }
    
    @inlinable public init(_ divisor: consuming Nonzero<Value>) {
        let subshift = UX(raw: divisor.ilog2())
        let subpower = Value.lsb &<< subshift
        
        if  divisor.value == subpower {
            // x × max + max: high == x
            self.multiplier = Doublet(low: .max, high: .max)
            self.increment  = Doublet(low: .max, high: .max)
            
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
                self.multiplier = quotient
                self.increment  = quotient
                
            }   else {
                Swift.assert(subpower >= divisor.value - remainder)

                var bit: Bool
                (quotient.low, bit) = quotient.low.incremented().components()
                (quotient.high) = quotient.high.incremented(bit).unchecked ()
                
                self.multiplier = quotient
                self.increment  = Doublet()
            }
        }
        
        self.divisor = (consume  divisor).value
        self.shift = Value(load: UX(size: Value.self).times(2).plus(subshift).unchecked())
    }
}
