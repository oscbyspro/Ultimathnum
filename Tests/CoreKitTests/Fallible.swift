//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit2

//*============================================================================*
// MARK: * Fallible
//*============================================================================*

@Suite struct FallibleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Metadata
    //=------------------------------------------------------------------------=
    
    @Test("Optional<Fallible<T>> has same memory layout as Fallible<T>")
    func optionalFallibleHasSameMemoryLayoutAsFallible() {
        whereIs(Bool.self)
        whereIs(Void.self)
        
        for type in typesAsCoreInteger {
            whereIsBinaryInteger(type)
        }
        
        func whereIs<T>(_ type: T.Type) {
            Ɣexpect(MemoryLayout<Optional<Fallible<T>>>.self, equals: MemoryLayout<Fallible<T>>.self)
        }
        
        func whereIsBinaryInteger<T>(_ type: T.Type) where T: BinaryInteger {
            Ɣexpect(MemoryLayout<Optional<Fallible<T>>>.self, equals: MemoryLayout<Fallible<T>>.self)
        }
    }
}
