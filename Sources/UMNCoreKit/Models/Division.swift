//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Quo(tient) Rem(ainder)
//*============================================================================*

@frozen public struct Division<Value>: Equatable where Value: Integer {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let quotient:  Value
    public let remainder: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(quotient: Value, remainder: Value) {
        self.quotient  = quotient
        self.remainder = remainder
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func ceil() -> Overflow<Value> {
        let instance: Self = consume self
        let increment = instance.remainder > 0 ?  1 : 0 as Value
        return (consume instance).quotient.incremented(by: increment)
    }
    
    @inlinable public consuming func floor() -> Overflow<Value> {
        let instance: Self = consume self
        let increment = instance.remainder < 0 ? -1 : 0 as Value
        return (consume instance).quotient.incremented(by: increment)
    }
}
