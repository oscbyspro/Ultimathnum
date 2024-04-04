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
        func whereIs<T, U>(_ type: T.Type, _ distance: U.Type) where T: SystemsInteger, U: SystemsInteger & SignedInteger {
            typealias F = Fallible<T>
            
            Test().same(T.min.advanced(by: -1 as U), F(T.max, error: true))
            Test().same(T.min.advanced(by:  0 as U), F(T.min))
            Test().same(T.min.advanced(by:  1 as U), F(T.min + 1))
            Test().same(T.max.advanced(by: -1 as U), F(T.max - 1))
            Test().same(T.max.advanced(by:  0 as U), F(T.max))
            Test().same(T.max.advanced(by:  1 as U), F(T.min, error: true))
            
            if  UX(bitWidth: T.self) < UX(bitWidth: U.self) {
                Test().same(T(~0).advanced(by: U.min), F(~0 as T, error: true))
                Test().same(T( 0).advanced(by: U.min), F( 0 as T, error: true))
                Test().same(T( 1).advanced(by: U.min), F( 1 as T, error: true))

                Test().same(T(~0).advanced(by: U.max), F(~1 as T, error: true))
                Test().same(T( 0).advanced(by: U.max), F(~0 as T, error: true))
                Test().same(T( 1).advanced(by: U.max), F( 0 as T, error: true))
            }
        }
        
        for type in Self.types {
            for distance: any (SystemsInteger & SignedInteger).Type in [I8.self, I16.self, I32.self, I64.self, IX.self] {
                whereIs(type, distance)
            }
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
