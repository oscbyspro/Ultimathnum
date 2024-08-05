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
/// - Note: It performs division by multiplication, addition, and shifts.
///
@frozen public struct Divider<Value> where Value: SystemsInteger & UnsignedInteger {

    public typealias Value =  Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let divisor: Nonzero<Value>
    public let multiplier:  Value
    public let increment:   Value
    public let shift: Shift<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<Failure>(_ value: consuming Value, prune error: @autoclosure () -> Failure) throws where Failure: Swift.Error {
        self.init(try Nonzero(value, prune: error()))
    }
    
    @inlinable public init?(exactly source: consuming Value) {
        guard let source = Nonzero(exactly: source) else { return nil }
        self.init(source)
    }
    
    @inlinable public init(unchecked source: Value) {
        self.init(Nonzero(unchecked: source))
    }
    
    @inlinable public init(_ source: consuming Value) {
        self.init(Nonzero(source))
    }
    
    @inlinable public init(_ source: consuming Nonzero<Value>) {
        self.divisor = consume source
        self.shift = Shift(unchecked: self.divisor.log2())
        let subpower = Value.lsb.up(((self.shift)))
        
        if  self.divisor.value == subpower {
            // x × max + max: high == x
            self.multiplier = Value.max
            self.increment  = Value.max
        
        }   else {
            let power =  Doublet(low: Value.min, high: subpower)
            let division = Value.division(power, by: self.divisor).unchecked()
            //  ⌊a÷b⌋ == ⌊(a+0)×⌈power÷b⌉÷power⌋
            //  where rounding error < subpower
            if  self.divisor.value.minus(division.remainder).unchecked() < subpower {
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
    }
}
