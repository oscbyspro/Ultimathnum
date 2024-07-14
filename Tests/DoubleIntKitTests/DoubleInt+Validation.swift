//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import TestKit

//*============================================================================*
// MARK: * Double Int x Validation
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIntegerLiterals() {
        Test().same(I8x2.exactly(-0000032769 as RootInt), Fallible(I8x2.max, error: true))
        Test().same(I8x2.exactly(-0000032768 as RootInt), Fallible(I8x2.min))
        Test().same(I8x2.exactly( 0000032767 as RootInt), Fallible(I8x2.max))
        Test().same(I8x2.exactly( 0000032768 as RootInt), Fallible(I8x2.min, error: true))
        
        Test().same(U8x2.exactly(-0000000001 as RootInt), Fallible(U8x2.max, error: true))
        Test().same(U8x2.exactly( 0000000000 as RootInt), Fallible(U8x2.min))
        Test().same(U8x2.exactly( 0000065535 as RootInt), Fallible(U8x2.max))
        Test().same(U8x2.exactly( 0000065536 as RootInt), Fallible(U8x2.min, error: true))
        
        Test().same(I8x4.exactly(-2147483649 as RootInt), Fallible(I8x4.max, error: true))
        Test().same(I8x4.exactly(-2147483648 as RootInt), Fallible(I8x4.min))
        Test().same(I8x4.exactly( 2147483647 as RootInt), Fallible(I8x4.max))
        Test().same(I8x4.exactly( 2147483648 as RootInt), Fallible(I8x4.min, error: true))
                
        Test().same(U8x4.exactly(-0000000001 as RootInt), Fallible(U8x4.max, error: true))
        Test().same(U8x4.exactly( 0000000000 as RootInt), Fallible(U8x4.min))
        Test().same(U8x4.exactly( 4294967295 as RootInt), Fallible(U8x4.max))
        Test().same(U8x4.exactly( 4294967296 as RootInt), Fallible(U8x4.min, error: true))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testInitMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias F = Fallible<T>
            
            Test().same(T.exactly(magnitude:  M( 0)), F(T( 0)))
            Test().same(T.exactly(magnitude:  M( 1)), F(T( 1)))
            Test().same(T.exactly(magnitude: ~M.msb), F(T.max))
            Test().same(T.exactly(magnitude:  M.msb), F(T.msb, error: true))
            Test().same(T.exactly(magnitude:  M.max), F(T(-1), error: true))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias F = Fallible<T>
            
            Test().same(T.exactly(magnitude:  M.min), F(T.min))
            Test().same(T.exactly(magnitude:  M.max), F(T.max))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testMakeMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M  = T.Magnitude
            typealias AR = Fallible<T>
            
            Test().same((-1 as T).magnitude(),  1 as M)
            Test().same(( 0 as T).magnitude(),  0 as M)
            Test().same(( T .max).magnitude(), ~M .msb)
            Test().same(( T .min).magnitude(),  M .msb)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M  = T.Magnitude
            typealias AR = Fallible<T>
            
            Test().same(( 0 as T).magnitude(), 0 as M)
            Test().same(( 1 as T).magnitude(), 1 as M)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
