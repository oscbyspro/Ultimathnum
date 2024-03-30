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
// MARK: * Double Int x Stride
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testStrideAdvancedBy() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias F = Fallible
            
            Test().same(T.advanced(T.min, by: -1 as IX), F(T.max, error: true))
            Test().same(T.advanced(T.min, by:  0 as IX), F(T.min))
            Test().same(T.advanced(T.min, by:  1 as IX), F(T.min + 1))
            Test().same(T.advanced(T.max, by: -1 as IX), F(T.max - 1))
            Test().same(T.advanced(T.max, by:  0 as IX), F(T.max))
            Test().same(T.advanced(T.max, by:  1 as IX), F(T.min, error: true))
            
            if  UX(bitWidth: T.self) < IX.bitWidth {
                Test().same(T.advanced(0 as T, by: IX.min), F( 0 as T, error: true))
                Test().same(T.advanced(0 as T, by: IX.max), F(~0 as T, error: true))
            }
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testStrideDistanceTo() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias F = Fallible
            
            Test().same(T.distance(T.max, to: T.max.advanced(by: -129), as: I8.self), F(I8.max, error: true))
            Test().same(T.distance(T.max, to: T.max.advanced(by: -128), as: I8.self), F(I8.min))
            Test().same(T.distance(T.max, to: T.max.advanced(by: -127), as: I8.self), F(I8.min + 1))
            Test().same(T.distance(T.min, to: T.min.advanced(by:  126), as: I8.self), F(I8.max - 1))
            Test().same(T.distance(T.min, to: T.min.advanced(by:  127), as: I8.self), F(I8.max))
            Test().same(T.distance(T.min, to: T.min.advanced(by:  128), as: I8.self), F(I8.min, error: true))
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
}
