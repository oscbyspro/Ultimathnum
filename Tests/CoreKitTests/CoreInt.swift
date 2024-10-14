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
        typesAsCoreInteger
    }
            
    static var typesWhereIsSigned: [any (SystemsInteger & SignedInteger).Type] {
        typesAsCoreIntegerAsSigned
    }
    
    static var typesWhereIsUnsigned: [any (SystemsInteger & UnsignedInteger).Type] {
        typesAsCoreIntegerAsUnsigned
    }
}
