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
// MARK: * Sign
//*============================================================================*

final class SignTests: XCTestCase {
    
    typealias T = Sign
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBit() {
        Test().same(T(0 as Bit), T.plus )
        Test().same(T(1 as Bit), T.minus)
        
        Test().same(T(raw: 0 as Bit), T.plus )
        Test().same(T(raw: 1 as Bit), T.minus)
        
        Test().same(Bit(T.plus ), 0 as Bit)
        Test().same(Bit(T.minus), 1 as Bit)
        
        Test().same(Bit(raw: T.plus ), 0 as Bit)
        Test().same(Bit(raw: T.minus), 1 as Bit)
    }
    
    func testBool() {
        Test().same(T(false), T.plus )
        Test().same(T(true ), T.minus)
        
        Test().same(T(raw: false), T.plus )
        Test().same(T(raw: true ), T.minus)
        
        Test().same(Bool(T.plus ), false)
        Test().same(Bool(T.minus), true )
        
        Test().same(Bool(raw: T.plus ), false)
        Test().same(Bool(raw: T.minus), true )
    }
    
    func testFloatingPointSign() {
        Test().same(T(FloatingPointSign.plus ), T.plus )
        Test().same(T(FloatingPointSign.minus), T.minus)
        
        Test().same(T(raw: FloatingPointSign.plus ), T.plus )
        Test().same(T(raw: FloatingPointSign.minus), T.minus)
        
        Test().same(FloatingPointSign(T.plus ), FloatingPointSign.plus )
        Test().same(FloatingPointSign(T.minus), FloatingPointSign.minus)
        
        Test().same(FloatingPointSign(raw: T.plus ), FloatingPointSign.plus )
        Test().same(FloatingPointSign(raw: T.minus), FloatingPointSign.minus)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        Test().not(T.plus,  T.minus)
        Test().not(T.minus, T.plus )
        
        Test().same({ var x = T.plus;  x.toggle(); return x }(), T.minus)
        Test().same({ var x = T.minus; x.toggle(); return x }(), T.plus )
    }
    
    func testLogicalAnd() {
        Test().and(T.plus , T.plus , T.plus )
        Test().and(T.plus , T.minus, T.plus )
        Test().and(T.minus, T.plus , T.plus )
        Test().and(T.minus, T.minus, T.minus)
    }
    
    func testLogicalOr() {
        Test().or (T.plus , T.plus , T.plus )
        Test().or (T.plus , T.minus, T.minus)
        Test().or (T.minus, T.plus , T.minus)
        Test().or (T.minus, T.minus, T.minus)
    }
    
    func testLogcialXor() {
        Test().xor(T.plus , T.plus , T.plus )
        Test().xor(T.plus , T.minus, T.minus)
        Test().xor(T.minus, T.plus , T.minus)
        Test().xor(T.minus, T.minus, T.plus )
    }
}
