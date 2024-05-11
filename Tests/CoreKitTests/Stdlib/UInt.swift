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
// MARK: * UInt
//*============================================================================*

final class UIntTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt() {
        typealias X = UX
        typealias Y = Swift.UInt
        
        Test().same(Y(X.min),  Y.min)
        Test().same(Y(X.max),  Y.max)
        
        Test().same(Y(raw: X.min), Y.min)
        Test().same(Y(raw: X.max), Y.max)
    }
    
    func testUInt8() {
        typealias X = U8
        typealias Y = Swift.UInt8
        
        Test().same(Y(X.min),  Y.min)
        Test().same(Y(X.max),  Y.max)
        
        Test().same(Y(raw: X.min), Y.min)
        Test().same(Y(raw: X.max), Y.max)
    }
    
    func testUInt16() {
        typealias X = U16
        typealias Y = Swift.UInt16
        
        Test().same(Y(X.min),  Y.min)
        Test().same(Y(X.max),  Y.max)
        
        Test().same(Y(raw: X.min), Y.min)
        Test().same(Y(raw: X.max), Y.max)
    }
    
    func testUInt32() {
        typealias X = U32
        typealias Y = Swift.UInt32
        
        Test().same(Y(X.min),  Y.min)
        Test().same(Y(X.max),  Y.max)
        
        Test().same(Y(raw: X.min), Y.min)
        Test().same(Y(raw: X.max), Y.max)
    }
    
    func testUInt64() {
        typealias X = U64
        typealias Y = Swift.UInt64
        
        Test().same(Y(X.min),  Y.min)
        Test().same(Y(X.max),  Y.max)
        
        Test().same(Y(raw: X.min), Y.min)
        Test().same(Y(raw: X.max), Y.max)
    }
}
