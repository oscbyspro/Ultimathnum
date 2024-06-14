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
// MARK: * Core Int
//*============================================================================*

final class CoreIntTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
        
    static var types: [any SystemsInteger.Type] {
        coreSystemsIntegers
    }
            
    static var typesWhereIsSigned: [any (SystemsInteger & SignedInteger).Type] {
        coreSystemsIntegersWhereIsSigned
    }
    
    static var typesWhereIsUnsigned: [any (SystemsInteger & UnsignedInteger).Type] {
        coreSystemsIntegersWhereIsUnsigned
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInvariants() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).mode(BinaryIntegerID())
            IntegerInvariants(T.self).size(SystemsIntegerID())
            IntegerInvariants(T.self).protocols()
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
