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
    
    @inlinable public init<Failure>(
        _   divisor: consuming Value,
        prune error: @autoclosure () -> Failure
    )   throws where Failure: Swift.Error {
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
            //  ⌊a÷b⌋ == ⌊(a+0)×⌈power÷b⌉÷power⌋
            //  where rounding error < subpower
            if  divisor.value.minus(division.remainder).unchecked() < subpower {
                self.multiplier = division.quotient.incremented().unchecked()
                self.increment  = Value.min
            //  ⌊a÷b⌋ == ⌊(a+1)×⌊power÷b⌋÷power⌋
            //  where rounding error ≤ subpower
            }   else {
                precondition(division.remainder <= subpower)
                self.multiplier = division.quotient
                self.increment  = division.quotient
            }
        }
        
        self.divisor = (consume  divisor).value
        self.shift = Value(load: UX(size: Value.self).plus(subshift).unchecked())
    }
}
