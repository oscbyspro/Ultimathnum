//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Infini Int x Stride
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// - Note: Arbitrary signed integers don't have edges.
    func testStrideNearEdgesOfSelf() {
        func whereIs<T, D>(_ type: T.Type, _ distance: D.Type) where T: UnsignedInteger, D: SignedInteger {
            for a: T in 0 ... 3 {
                for b: T in   0 ... 3 {
                    Test().distance(T.min + a, T.min &+ b, Fallible( (D(b) - D(a))))
                    Test().distance(T.min + a, T.min &- b, Fallible(-(D(b) + D(a)), error: b > 0))
                    Test().distance(T.max - a, T.max &+ b, Fallible( (D(a) + D(b)), error: b > 0))
                    Test().distance(T.max - a, T.max &- b, Fallible( (D(a) - D(b))))
                }
            }
        }
        
        for type in Self.typesWhereIsUnsigned {
            for distance in Self.typesWhereIsSigned {
                whereIs(type, distance)
            }
            
            for distance in typesAsCoreIntegerAsSigned {
                whereIs(type, distance)
            }
        }
    }
    
    func testStrideNearEdgesOfDistance() {
        func whereIs<T, D>(_ type: T.Type, _ distance: D.Type) where T: BinaryInteger, D: SystemsInteger & SignedInteger {
            for a: D in 0 ... 3 {
                for b: D in  -3 ... 3 {
                    Test().distance( T(a), T(load: D.max) &+ T(load: b + a), Fallible(D.max &+  b, error:  b > 0), lossy:  b > 0)
                    Test().distance(~T(a), T(load: D.min) &+ T(load: b - a), Fallible(D.min &- ~b, error: ~b > 0), lossy: ~b > 0)
                }
            }
        }
        
        for type in Self.types {
            for distance in typesAsCoreIntegerAsSigned {
                whereIs(type, distance)
            }
        }
    }
}
