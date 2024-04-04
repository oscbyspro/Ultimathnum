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
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible
            
            Test().same(T.distance(-1 as T, to: -1 as T, as: IX.self), F( 0 as IX))
            Test().same(T.distance(-1 as T, to:  0 as T, as: IX.self), F( 1 as IX))
            Test().same(T.distance( 0 as T, to: -1 as T, as: IX.self), F(-1 as IX))
            Test().same(T.distance( 0 as T, to:  0 as T, as: IX.self), F( 0 as IX))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible
            
            Test().same(T.distance( 0 as T, to:  0 as T, as: IX.self), F( 0 as IX))
            Test().same(T.distance( 0 as T, to:  1 as T, as: IX.self), F( 1 as IX))
            Test().same(T.distance( 1 as T, to:  0 as T, as: IX.self), F(-1 as IX))
            Test().same(T.distance( 1 as T, to:  1 as T, as: IX.self), F( 0 as IX))
        }
        
        for type in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
