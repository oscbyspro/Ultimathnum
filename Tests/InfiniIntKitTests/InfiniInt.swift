//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Infini Int
//*============================================================================*

final class InfiniIntTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
        
    static let types: [any ArbitraryInteger.Type] = {
        typesWhereIsSigned +
        typesWhereIsUnsigned
    }()
            
    static let typesWhereIsSigned: [any (ArbitraryInteger & SignedInteger).Type] = [
        InfiniInt<IX>.self,
        InfiniInt<I8>.self,
    ]
            
    static let typesWhereIsUnsigned: [any (ArbitraryInteger & UnsignedInteger).Type] = [
        InfiniInt<UX>.self,
        InfiniInt<U8>.self,
    ]
    
    static let elements: [any (BinaryInteger & SystemsInteger).Type] = {
        elementsWhereIsSigned +
        elementsWhereIsUnsigned
    }()
            
    static let elementsWhereIsSigned: [any (SignedInteger & SystemsInteger).Type] = [
        IX.self,
        I8.self,
    ]
            
    static let elementsWhereIsUnsigned: [any (UnsignedInteger & SystemsInteger).Type] = [
        UX.self,
        U8.self,
    ]
}
