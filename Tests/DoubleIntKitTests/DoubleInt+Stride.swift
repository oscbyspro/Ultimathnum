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
                        
            Test().same(T.min.advanced(by: -4 as U), F(T.min &- 4, error: true))
            Test().same(T.min.advanced(by: -3 as U), F(T.min &- 3, error: true))
            Test().same(T.min.advanced(by: -2 as U), F(T.min &- 2, error: true))
            Test().same(T.min.advanced(by: -1 as U), F(T.min &- 1, error: true))
            Test().same(T.min.advanced(by:  0 as U), F(T.min &+ 0))
            Test().same(T.min.advanced(by:  1 as U), F(T.min &+ 1))
            Test().same(T.min.advanced(by:  2 as U), F(T.min &+ 2))
            Test().same(T.min.advanced(by:  3 as U), F(T.min &+ 3))
            
            Test().same(T.max.advanced(by: -4 as U), F(T.max &- 4))
            Test().same(T.max.advanced(by: -3 as U), F(T.max &- 3))
            Test().same(T.max.advanced(by: -2 as U), F(T.max &- 2))
            Test().same(T.max.advanced(by: -1 as U), F(T.max &- 1))
            Test().same(T.max.advanced(by:  0 as U), F(T.max &+ 0))
            Test().same(T.max.advanced(by:  1 as U), F(T.max &+ 1, error: true))
            Test().same(T.max.advanced(by:  2 as U), F(T.max &+ 2, error: true))
            Test().same(T.max.advanced(by:  3 as U), F(T.max &+ 3, error: true))
            
            if  T.size < U.size {
                Test().same(T(~0).advanced(by: U.min), F(~0 as T, error: true))
                Test().same(T(~1).advanced(by: U.min), F(~1 as T, error: true))
                Test().same(T( 0).advanced(by: U.min), F( 0 as T, error: true))
                Test().same(T( 1).advanced(by: U.min), F( 1 as T, error: true))

                Test().same(T(~0).advanced(by: U.max), F(~1 as T, error: true))
                Test().same(T(~1).advanced(by: U.max), F(~2 as T, error: true))
                Test().same(T( 0).advanced(by: U.max), F(~0 as T, error: true))
                Test().same(T( 1).advanced(by: U.max), F( 0 as T, error: true))
            }
        }
        
        for type in Self.types {
            for distance in Self.typesWhereIsSigned {
                whereIs(type, distance)
            }
            
            for distance in coreSystemsIntegersWhereIsSigned {
                whereIs(type, distance)
            }
        }
    }
    
    func testStrideDistanceTo() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias F = Fallible
            
            always: do {
                Test().distance(T.min, T.min.advanced(by:    126), F(I8 .max - 1))
                Test().distance(T.min, T.min.advanced(by:    127), F(I8 .max))
                Test().distance(T.min, T.min.advanced(by:    128), F(I8 .min, error: true), lossy: T.size > Count(08))
                
                Test().distance(T.max, T.max.advanced(by:   -129), F(I8 .max, error: true), lossy: T.size > Count(08))
                Test().distance(T.max, T.max.advanced(by:   -128), F(I8 .min))
                Test().distance(T.max, T.max.advanced(by:   -127), F(I8 .min + 1))
            }
            
            if  T.size >= Count(16) {
                Test().distance(T.min, T.min.advanced(by:  32766), F(I16.max - 1))
                Test().distance(T.min, T.min.advanced(by:  32767), F(I16.max))
                Test().distance(T.min, T.min.advanced(by:  32768), F(I16.min, error: true), lossy: T.size > Count(16))
                
                Test().distance(T.max, T.max.advanced(by: -32769), F(I16.max, error: true), lossy: T.size > Count(16))
                Test().distance(T.max, T.max.advanced(by: -32768), F(I16.min))
                Test().distance(T.max, T.max.advanced(by: -32767), F(I16.min + 1))
            }
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
}
