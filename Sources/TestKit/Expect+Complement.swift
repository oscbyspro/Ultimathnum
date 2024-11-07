//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Expect x Complement
//*============================================================================*

@inlinable public func Ɣexpect<T>(
    _  instance: T,
    complement increment: Bool,
    is expectation: T,
    error: Bool = false,
    at location: SourceLocation = #_sourceLocation
)   where T: BinaryInteger {
    
    Ɣexpect(instance, complement: increment, is: expectation.veto(error), at: location)
}

@inlinable public func Ɣexpect<T>(
    _  instance: T,
    complement increment: Bool,
    is expectation: Fallible<T>,
    at location: SourceLocation = #_sourceLocation
)   where T: BinaryInteger {
    //=------------------------------------------=
    #expect(instance.complement(increment) ==  expectation, sourceLocation: location)
    //=------------------------------------------=
    if  increment {
        #expect(instance.complement() == expectation.value, sourceLocation: location)
    }
    //=------------------------------------------=
    // the 1's and 2's complement are reversible
    //=------------------------------------------=
    let inverse = instance.veto(expectation.error)
    #expect(inverse.value.toggled().incremented(increment) == expectation, sourceLocation: location)
    #expect(expectation.value.toggled().incremented(increment) == inverse, sourceLocation: location)
}
