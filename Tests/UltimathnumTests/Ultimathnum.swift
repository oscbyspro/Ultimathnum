//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Ultimathnum
import TestKit

//*============================================================================*
// MARK: * Ultimathnum
//*============================================================================*

final class UltimathnumTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    static let types = bitIntList + coreIntList
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data x Modules
    //=------------------------------------------------------------------------=
    
    static let bitIntList: [any SystemsInteger.Type] = [
        I1.self,
        U1.self,
    ]
        
    static let coreIntList: [any SystemsInteger.Type] = [
        IX .self,
        I8 .self,
        I16.self,
        I32.self,
        I64.self,
        UX .self,
        U8 .self,
        U16.self,
        U32.self,
        U64.self,
    ]
}
