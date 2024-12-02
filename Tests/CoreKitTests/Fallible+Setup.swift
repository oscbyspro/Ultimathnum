//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Fallible x Setup
//*============================================================================*

@Suite struct FallibleTestsOnSetup {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fallible/setup: Self.init(_:setup:)",
        Tag.List.tags(.exhaustive),
        arguments: Bit.all, Bool.all
    )   func fromInoutValueAndInoutError(value: Bit, error: Bool) throws {
        #expect(Fallible(value, setup: { _, _ in                   }) == Fallible(value,    error: false))
        #expect(Fallible(value, setup: { $0 = Bit.zero; $1 = false }) == Fallible(Bit.zero, error: false))
        #expect(Fallible(value, setup: { $0 = Bit.zero; $1 = true  }) == Fallible(Bit.zero, error: true ))
        #expect(Fallible(value, setup: { $0 = Bit.one;  $1 = false }) == Fallible(Bit.one,  error: false))
        #expect(Fallible(value, setup: { $0 = Bit.one;  $1 = true  }) == Fallible(Bit.one,  error: true ))
    }
    
    @Test(
        "Fallible/setup: Self.init(_:error:setup:)",
        Tag.List.tags(.exhaustive),
        arguments: Bit.all, Bool.all
    )   func fromInoutValueAndInoutErrorWithCustomInitialError(value: Bit, error: Bool) throws {
        #expect(Fallible(value, error: error, setup: { _, _ in                   }) == Fallible(value,    error: error))
        #expect(Fallible(value, error: error, setup: { $0 = Bit.zero; $1 = false }) == Fallible(Bit.zero, error: false))
        #expect(Fallible(value, error: error, setup: { $0 = Bit.zero; $1 = true  }) == Fallible(Bit.zero, error: true ))
        #expect(Fallible(value, error: error, setup: { $0 = Bit.one;  $1 = false }) == Fallible(Bit.one,  error: false))
        #expect(Fallible(value, error: error, setup: { $0 = Bit.one;  $1 = true  }) == Fallible(Bit.one,  error: true ))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Error
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fallible/setup: Self.error(_:)",
        Tag.List.tags(.exhaustive),
        arguments: Bit.all
    )   func fromInoutErrorReturningValue(value: Bit) throws {
        #expect(Fallible.error({    _ in     return value }) == Fallible(value, error: false))
        #expect(Fallible.error({ $0 = false; return value }) == Fallible(value, error: false))
        #expect(Fallible.error({ $0 = true;  return value }) == Fallible(value, error: true ))
    }
    
    @Test(
        "Fallible/setup: Self.error(_:setup:)",
        Tag.List.tags(.exhaustive),
        arguments: Bit.all, Bool.all
    )   func fromInoutErrorReturningValueWithCustomInitialError(value: Bit, error: Bool) throws {
        #expect(Fallible.error(error, setup: {    _ in     return value }) == Fallible(value, error: error))
        #expect(Fallible.error(error, setup: { $0 = false; return value }) == Fallible(value, error: false))
        #expect(Fallible.error(error, setup: { $0 = true;  return value }) == Fallible(value, error: true ))
    }
}
