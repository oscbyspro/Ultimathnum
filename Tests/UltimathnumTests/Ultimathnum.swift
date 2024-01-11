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
import XCTest

//*============================================================================*
// MARK: * Ultimathnum
//*============================================================================*

final class UltimathnumTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    static let signed:   [any Integer.Type] = [
        I1 .self,
        IX .self,
        I8 .self,
        I16.self,
        I32.self,
        I64.self,
    ]
    
    static let unsigned: [any Integer.Type] = [
        U1 .self,
        UX .self,
        U8 .self,
        U16.self,
        U32.self,
        U64.self,
    ]
    
    static let types: [any Integer.Type] = signed + unsigned
    
    //=------------------------------------------------------------------------=
    // MARK: State x Modules
    //=------------------------------------------------------------------------=
    
    static let bitInt: [any SystemInteger.Type] = [
        I1.self,
        U1.self,
    ]
        
    static let mainInt: [any SystemInteger.Type] = [
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
