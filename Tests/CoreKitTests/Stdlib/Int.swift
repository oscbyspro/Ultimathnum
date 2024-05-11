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
// MARK: * Int
//*============================================================================*

final class IntTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInt() {
        typealias X = IX
        typealias Y = Swift.Int
        
        Test().same(Y(X.min),  Y.min)
        Test().same(Y(X.max),  Y.max)
        
        Test().same(Y(raw: X.min), Y.min)
        Test().same(Y(raw: X.max), Y.max)
    }
    
    func testInt8() {
        typealias X = I8
        typealias Y = Swift.Int8
        
        Test().same(Y(X.min),  Y.min)
        Test().same(Y(X.max),  Y.max)
        
        Test().same(Y(raw: X.min), Y.min)
        Test().same(Y(raw: X.max), Y.max)
    }
    
    func testInt16() {
        typealias X = I16
        typealias Y = Swift.Int16
        
        Test().same(Y(X.min),  Y.min)
        Test().same(Y(X.max),  Y.max)
        
        Test().same(Y(raw: X.min), Y.min)
        Test().same(Y(raw: X.max), Y.max)
    }
    
    func testInt32() {
        typealias X = I32
        typealias Y = Swift.Int32
        
        Test().same(Y(X.min),  Y.min)
        Test().same(Y(X.max),  Y.max)
        
        Test().same(Y(raw: X.min), Y.min)
        Test().same(Y(raw: X.max), Y.max)
    }
    
    func testInt64() {
        typealias X = I64
        typealias Y = Swift.Int64
        
        Test().same(Y(X.min),  Y.min)
        Test().same(Y(X.max),  Y.max)
        
        Test().same(Y(raw: X.min), Y.min)
        Test().same(Y(raw: X.max), Y.max)
    }
}
