//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import MinimiIntKit
import TestKit

//*============================================================================*
// MARK: * Minimi Int x Stride
//*============================================================================*

extension MinimiIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testStrideAdvancedByMinimiInt() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
                        
            Test().same(T.min.advanced(by: I1.min), F(T.max, error: true))
            Test().same(T.min.advanced(by: I1.max), F(T.min))
            
            Test().same(T.max.advanced(by: I1.min), F(T.min))
            Test().same(T.max.advanced(by: I1.max), F(T.max))
        }
        
        for type in types {
            whereIs(type)
        }
    }
    
    func testStrideAdvancedByCoreSystemsInteger() {
        func whereIs<T, U>(_ type: T.Type, _ distance: U.Type) where T: SystemsInteger, U: SystemsInteger & SignedInteger {
            typealias F = Fallible<T>
            
            Test().same(T.min.advanced(by: U.min), F(T.min, error: true))
            Test().same(T.min.advanced(by: U(-4)), F(T.min, error: true))
            Test().same(T.min.advanced(by: U(-3)), F(T.max, error: true))
            Test().same(T.min.advanced(by: U(-2)), F(T.min, error: true))
            Test().same(T.min.advanced(by: U(-1)), F(T.max, error: true))
            Test().same(T.min.advanced(by: U( 0)), F(T.min))
            Test().same(T.min.advanced(by: U( 1)), F(T.max))
            Test().same(T.min.advanced(by: U( 2)), F(T.min, error: true))
            Test().same(T.min.advanced(by: U( 3)), F(T.max, error: true))
            Test().same(T.min.advanced(by: U.max), F(T.max, error: true))
            
            Test().same(T.max.advanced(by: U.min), F(T.max, error: true))
            Test().same(T.max.advanced(by: U(-4)), F(T.max, error: true))
            Test().same(T.max.advanced(by: U(-3)), F(T.min, error: true))
            Test().same(T.max.advanced(by: U(-2)), F(T.max, error: true))
            Test().same(T.max.advanced(by: U(-1)), F(T.min))
            Test().same(T.max.advanced(by: U( 0)), F(T.max))
            Test().same(T.max.advanced(by: U( 1)), F(T.min, error: true))
            Test().same(T.max.advanced(by: U( 2)), F(T.max, error: true))
            Test().same(T.max.advanced(by: U( 3)), F(T.min, error: true))
            Test().same(T.max.advanced(by: U.max), F(T.min, error: true))
        }
        
        for type in types {
            for distance in coreSystemsIntegersWhereIsSigned {
                whereIs(type, distance)
            }
        }
    }
    
    func testStrideDistanceTo() {
        func whereIs<T, U>(_ type: T.Type, _ distance: U.Type) where T: SystemsInteger, U: SystemsInteger & SignedInteger {
            Test().same(T.min.distance(to: T.min), U.exactly( 0))
            Test().same(T.min.distance(to: T.max), U.exactly( 1))
            Test().same(T.max.distance(to: T.min), U.exactly(-1))
            Test().same(T.max.distance(to: T.max), U.exactly( 0))
        }
        
        for type in types {
            whereIs(type, I1.self)
        }
        
        for type in types {
            for distance in coreSystemsIntegersWhereIsSigned {
                whereIs(type, distance)
            }
        }
    }
}
