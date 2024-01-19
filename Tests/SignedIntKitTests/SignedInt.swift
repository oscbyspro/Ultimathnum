//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import SignedIntKit
import TestKit

//*============================================================================*
// MARK: * Signed Int
//*============================================================================*

final class SignedIntTests: XCTestCase {
    
    typealias T32 = SignedInt<U32>
    typealias T64 = SignedInt<U64>
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
        
    static let types: [any Integer.Type] = [
        SignedInt<UX >.self,
        SignedInt<U1 >.self,
        SignedInt<U8 >.self,
        SignedInt<U16>.self,
        SignedInt<U32>.self,
        SignedInt<U64>.self,
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMinMax() {
        XCTAssertEqual(T32.min, try? T32(sign: Sign.minus, magnitude: 00000000004294967295 as U32))
        XCTAssertEqual(T32.max, try? T32(sign: Sign.plus,  magnitude: 00000000004294967295 as U32))
        XCTAssertEqual(T64.min, try? T64(sign: Sign.minus, magnitude: 18446744073709551615 as U64))
        XCTAssertEqual(T64.max, try? T64(sign: Sign.plus,  magnitude: 18446744073709551615 as U64))
    }
}
