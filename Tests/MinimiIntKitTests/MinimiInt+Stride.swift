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
    
    func testStrideAdvancedByI1() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
                        
            Test().same(T(-1).advanced(by: -1 as I1), F( 0 as T, error: true))
            Test().same(T(-1).advanced(by:  0 as I1), F(-1 as T))
            
            Test().same(T( 0).advanced(by: -1 as I1), F(-1 as T))
            Test().same(T( 0).advanced(by:  0 as I1), F( 0 as T))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().same(T( 0).advanced(by: -1 as IX), F( 1 as T, error: true))
            Test().same(T( 0).advanced(by:  0 as IX), F( 0 as T))
            
            Test().same(T( 1).advanced(by: -1 as IX), F( 0 as T))
            Test().same(T( 1).advanced(by:  0 as IX), F( 1 as T))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testStrideAdvancedByIX() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().same(T(-1).advanced(by:  IX .min), F(-1 as T, error: true))
            Test().same(T(-1).advanced(by: -2 as IX), F(-1 as T, error: true))
            Test().same(T(-1).advanced(by: -1 as IX), F( 0 as T, error: true))
            Test().same(T(-1).advanced(by:  0 as IX), F(-1 as T))
            Test().same(T(-1).advanced(by:  1 as IX), F( 0 as T))
            Test().same(T(-1).advanced(by:  2 as IX), F(-1 as T, error: true))
            Test().same(T(-1).advanced(by:  IX .max), F( 0 as T, error: true))
            
            Test().same(T( 0).advanced(by:  IX .min), F( 0 as T, error: true))
            Test().same(T( 0).advanced(by: -2 as IX), F( 0 as T, error: true))
            Test().same(T( 0).advanced(by: -1 as IX), F(-1 as T))
            Test().same(T( 0).advanced(by:  0 as IX), F( 0 as T))
            Test().same(T( 0).advanced(by:  1 as IX), F(-1 as T, error: true))
            Test().same(T( 0).advanced(by:  2 as IX), F( 0 as T, error: true))
            Test().same(T( 0).advanced(by:  IX .max), F(-1 as T, error: true))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().same(T( 0).advanced(by:  IX .min), F( 0 as T, error: true))
            Test().same(T( 0).advanced(by: -2 as IX), F( 0 as T, error: true))
            Test().same(T( 0).advanced(by: -1 as IX), F( 1 as T, error: true))
            Test().same(T( 0).advanced(by:  0 as IX), F( 0 as T))
            Test().same(T( 0).advanced(by:  1 as IX), F( 1 as T))
            Test().same(T( 0).advanced(by:  2 as IX), F( 0 as T, error: true))
            Test().same(T( 0).advanced(by:  IX .max), F( 1 as T, error: true))
            
            Test().same(T( 1).advanced(by:  IX .min), F( 1 as T, error: true))
            Test().same(T( 1).advanced(by: -2 as IX), F( 1 as T, error: true))
            Test().same(T( 1).advanced(by: -1 as IX), F( 0 as T))
            Test().same(T( 1).advanced(by:  0 as IX), F( 1 as T))
            Test().same(T( 1).advanced(by:  1 as IX), F( 0 as T, error: true))
            Test().same(T( 1).advanced(by:  2 as IX), F( 1 as T, error: true))
            Test().same(T( 1).advanced(by:  IX .max), F( 0 as T, error: true))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
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
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
