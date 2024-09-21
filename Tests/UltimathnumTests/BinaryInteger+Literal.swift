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
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Literal
//*============================================================================*

final class BinaryIntegerTestsOnLiteral: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// Here we check that integer literals aren't inferred as `Int` or `Double`.
    ///
    /// - Note: Neither `Int` nor `Double` can represent `I256.max`.
    ///
    /// - Note: Most, or all, literal conversions are `BinaryInteger` extensions.
    ///
    /// - Seealso: https://github.com/oscbyspro/Ultimathnum/issues/25
    ///
    func testGenericTypeInference() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            let expectation = T.lsb << 255 - 1
            
            let a: T =          (57896044618658097711785492504343953926634992332820282019728792003956564819967)
            let b: T = T        (57896044618658097711785492504343953926634992332820282019728792003956564819967)
            let c: T = T.init   (57896044618658097711785492504343953926634992332820282019728792003956564819967)
            let d: T = T.exactly(57896044618658097711785492504343953926634992332820282019728792003956564819967).value
            
            Test().same(a, expectation)
            Test().same(b, expectation)
            Test().same(c, expectation)
            Test().same(d, expectation)
        }
        
        whereIs(IXL.self)
        whereIs(UXL.self)
    }
    
    func testBigIntLiteralValuesNearSizeEdges() {
        struct Values {
            let size:  Count
            let base:  IXL
            let minM1: LiteralInt
            let min:   LiteralInt
            let minP1: LiteralInt
            let maxM1: LiteralInt
            let max:   LiteralInt
            let maxP1: LiteralInt
        }
        
        let arguments: [Values] = [
            Values(
                size:   Count(008),
                base:   127,
                minM1: -129,
                min:   -128,
                minP1: -127,
                maxM1:  126,
                max:    127,
                maxP1:  128
            ),
            Values(
                size:   Count(016),
                base:   32767,
                minM1: -32769,
                min:   -32768,
                minP1: -32767,
                maxM1:  32766,
                max:    32767,
                maxP1:  32768
            ),
            Values(
                size:   Count(032),
                base:   2147483647,
                minM1: -2147483649,
                min:   -2147483648,
                minP1: -2147483647,
                maxM1:  2147483646,
                max:    2147483647,
                maxP1:  2147483648
            ),
            Values(
                size:   Count(064),
                base:   9223372036854775807,
                minM1: -9223372036854775809,
                min:   -9223372036854775808,
                minP1: -9223372036854775807,
                maxM1:  9223372036854775806,
                max:    9223372036854775807,
                maxP1:  9223372036854775808
            ),
            Values(
               size:   Count(128),
               base:   170141183460469231731687303715884105727,
               minM1: -170141183460469231731687303715884105729,
               min:   -170141183460469231731687303715884105728,
               minP1: -170141183460469231731687303715884105727,
               maxM1:  170141183460469231731687303715884105726,
               max:    170141183460469231731687303715884105727,
               maxP1:  170141183460469231731687303715884105728
           ),
            Values(
               size:   Count(256),
               base:   57896044618658097711785492504343953926634992332820282019728792003956564819967,
               minM1: -57896044618658097711785492504343953926634992332820282019728792003956564819969,
               min:   -57896044618658097711785492504343953926634992332820282019728792003956564819968,
               minP1: -57896044618658097711785492504343953926634992332820282019728792003956564819967,
               maxM1:  57896044618658097711785492504343953926634992332820282019728792003956564819966,
               max:    57896044618658097711785492504343953926634992332820282019728792003956564819967,
               maxP1:  57896044618658097711785492504343953926634992332820282019728792003956564819968
           ),
        ]
                
        func whereIsSigned<T>(_ integer: T.Type, values: Values) where T: SignedInteger {
            Test().same(T.exactly(values.minM1), Fallible(T(load: ~values.base - 1), error: T.size <= values.size))
            Test().same(T.exactly(values.min  ), Fallible(T(load: ~values.base    ), error: T.size <  values.size))
            Test().same(T.exactly(values.minP1), Fallible(T(load: ~values.base + 1), error: T.size <  values.size))
            Test().same(T.exactly(values.maxM1), Fallible(T(load:  values.base - 1), error: T.size <  values.size))
            Test().same(T.exactly(values.max  ), Fallible(T(load:  values.base    ), error: T.size <  values.size))
            Test().same(T.exactly(values.maxP1), Fallible(T(load:  values.base + 1), error: T.size <= values.size))
        }
        
        func whereIsUnsigned<T>(_ integer: T.Type, values: Values) where T: UnsignedInteger {
            Test().same(T.exactly(values.minM1), Fallible(T(load: ~values.base - 1), error: true))
            Test().same(T.exactly(values.min  ), Fallible(T(load: ~values.base    ), error: true))
            Test().same(T.exactly(values.minP1), Fallible(T(load: ~values.base + 1), error: true))
            Test().same(T.exactly(values.maxM1), Fallible(T(load:  values.base - 1), error: T.size <  values.size))
            Test().same(T.exactly(values.max  ), Fallible(T(load:  values.base    ), error: T.size <  values.size))
            Test().same(T.exactly(values.maxP1), Fallible(T(load:  values.base + 1), error: T.size <  values.size))
        }
        
        for values in arguments {
            Test().same(values.base .entropy(), values.size)
            Test().same(values.minM1.entropy(), Count(IX(raw: values.size) + 1))
            Test().same(values.min  .entropy(), values.size)
            Test().same(values.minP1.entropy(), values.size)
            Test().same(values.maxM1.entropy(), values.size)
            Test().same(values.max  .entropy(), values.size)
            Test().same(values.maxP1.entropy(), Count(IX(raw: values.size) + 1))
            
            for integer in binaryIntegersWhereIsSigned {
                whereIsSigned(integer, values: values)
            }
            
            for integer in binaryIntegersWhereIsUnsigned {
                whereIsUnsigned(integer, values: values)
            }
        }
    }
}
