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
import TestKit2

//*============================================================================*
// MARK: * Binary Integer x Literals
//*============================================================================*

@Suite struct BinaryIntegerTestsOnLiterals {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let minI128 = IXL(repeating: Bit.one).up(Count(127))
    static let maxI128 = IXL(repeating: Bit.one).up(Count(127)).toggled()
    static let maxU128 = IXL(repeating: Bit.one).up(Count(128)).toggled()
    
    static let minI256 = IXL(repeating: Bit.one).up(Count(255))
    static let maxI256 = IXL(repeating: Bit.one).up(Count(255)).toggled()
    static let maxU256 = IXL(repeating: Bit.one).up(Count(256)).toggled()
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Literal Int
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/literals: from LiteralInt near zero",
        Tag.List.tags(.generic),
        arguments: [
            
            (LiteralInt(-4), IXL.zero - 4),
            (LiteralInt(-3), IXL.zero - 3),
            (LiteralInt(-2), IXL.zero - 2),
            (LiteralInt(-1), IXL.zero - 1),
            (LiteralInt( 0), IXL.zero + 0),
            (LiteralInt( 1), IXL.zero + 1),
            (LiteralInt( 2), IXL.zero + 2),
            (LiteralInt( 3), IXL.zero + 3),
            
    ] as [(LiteralInt, IXL)])
    func fromLiteralIntNearZero(literal: LiteralInt, expectation: IXL) throws {
        for type in typesAsBinaryInteger {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try #require(T.exactly(literal) == T.exactly(expectation))
        }
    }
    
    @Test(
        "BinaryInteger/literals: from LiteralInt near edges of signed",
        Tag.List.tags(.generic),
        arguments: [
    
            (LiteralInt(-129), IXL(I8.min) - 1),
            (LiteralInt(-128), IXL(I8.min)    ),
            (LiteralInt(-127), IXL(I8.min) + 1),
            (LiteralInt( 126), IXL(I8.max) - 1),
            (LiteralInt( 127), IXL(I8.max)    ),
            (LiteralInt( 128), IXL(I8.max) + 1),
        
            (LiteralInt(-32769), IXL(I16.min) - 1),
            (LiteralInt(-32768), IXL(I16.min)    ),
            (LiteralInt(-32767), IXL(I16.min) + 1),
            (LiteralInt( 32766), IXL(I16.max) - 1),
            (LiteralInt( 32767), IXL(I16.max)    ),
            (LiteralInt( 32768), IXL(I16.max) + 1),
            
            (LiteralInt(-2147483649), IXL(I32.min) - 1),
            (LiteralInt(-2147483648), IXL(I32.min)    ),
            (LiteralInt(-2147483647), IXL(I32.min) + 1),
            (LiteralInt( 2147483646), IXL(I32.max) - 1),
            (LiteralInt( 2147483647), IXL(I32.max)    ),
            (LiteralInt( 2147483648), IXL(I32.max) + 1),
            
            (LiteralInt(-9223372036854775809), IXL(I64.min) - 1),
            (LiteralInt(-9223372036854775808), IXL(I64.min)    ),
            (LiteralInt(-9223372036854775807), IXL(I64.min) + 1),
            (LiteralInt( 9223372036854775806), IXL(I64.max) - 1),
            (LiteralInt( 9223372036854775807), IXL(I64.max)    ),
            (LiteralInt( 9223372036854775808), IXL(I64.max) + 1),
            
            (LiteralInt(-170141183460469231731687303715884105729), BinaryIntegerTestsOnLiterals.minI128 - 1),
            (LiteralInt(-170141183460469231731687303715884105728), BinaryIntegerTestsOnLiterals.minI128    ),
            (LiteralInt(-170141183460469231731687303715884105727), BinaryIntegerTestsOnLiterals.minI128 + 1),
            (LiteralInt( 170141183460469231731687303715884105726), BinaryIntegerTestsOnLiterals.maxI128 - 1),
            (LiteralInt( 170141183460469231731687303715884105727), BinaryIntegerTestsOnLiterals.maxI128    ),
            (LiteralInt( 170141183460469231731687303715884105728), BinaryIntegerTestsOnLiterals.maxI128 + 1),
            
            (LiteralInt(-57896044618658097711785492504343953926634992332820282019728792003956564819969), BinaryIntegerTestsOnLiterals.minI256 - 1),
            (LiteralInt(-57896044618658097711785492504343953926634992332820282019728792003956564819968), BinaryIntegerTestsOnLiterals.minI256    ),
            (LiteralInt(-57896044618658097711785492504343953926634992332820282019728792003956564819967), BinaryIntegerTestsOnLiterals.minI256 + 1),
            (LiteralInt( 57896044618658097711785492504343953926634992332820282019728792003956564819966), BinaryIntegerTestsOnLiterals.maxI256 - 1),
            (LiteralInt( 57896044618658097711785492504343953926634992332820282019728792003956564819967), BinaryIntegerTestsOnLiterals.maxI256    ),
            (LiteralInt( 57896044618658097711785492504343953926634992332820282019728792003956564819968), BinaryIntegerTestsOnLiterals.maxI256 + 1),
            
    ] as [(LiteralInt, IXL)])
    func fromLiteralIntNearEdgesOfSignedIntegers(literal: LiteralInt, expectation: IXL) throws {
        for type in typesAsBinaryInteger {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try #require(T.exactly(literal) == T.exactly(expectation))
        }
    }
    
    @Test(
        "BinaryInteger/literals: from LiteralInt near size edges of unsigned",
        Tag.List.tags(.generic),
        arguments: [
            
            (LiteralInt( 254), IXL(U8.max) - 1),
            (LiteralInt( 255), IXL(U8.max)    ),
            (LiteralInt( 256), IXL(U8.max) + 1),
            
            (LiteralInt( 65534), IXL(U16.max) - 1),
            (LiteralInt( 65535), IXL(U16.max)    ),
            (LiteralInt( 65536), IXL(U16.max) + 1),
            
            (LiteralInt( 4294967294), IXL(U32.max) - 1),
            (LiteralInt( 4294967295), IXL(U32.max)    ),
            (LiteralInt( 4294967296), IXL(U32.max) + 1),
            
            (LiteralInt( 18446744073709551614), IXL(U64.max) - 1),
            (LiteralInt( 18446744073709551615), IXL(U64.max)    ),
            (LiteralInt( 18446744073709551616), IXL(U64.max) + 1),
            
            (LiteralInt( 340282366920938463463374607431768211454), BinaryIntegerTestsOnLiterals.maxU128 - 1),
            (LiteralInt( 340282366920938463463374607431768211455), BinaryIntegerTestsOnLiterals.maxU128    ),
            (LiteralInt( 340282366920938463463374607431768211456), BinaryIntegerTestsOnLiterals.maxU128 + 1),

            (LiteralInt( 115792089237316195423570985008687907853269984665640564039457584007913129639934), BinaryIntegerTestsOnLiterals.maxU256 - 1),
            (LiteralInt( 115792089237316195423570985008687907853269984665640564039457584007913129639935), BinaryIntegerTestsOnLiterals.maxU256    ),
            (LiteralInt( 115792089237316195423570985008687907853269984665640564039457584007913129639936), BinaryIntegerTestsOnLiterals.maxU256 + 1),
            
    ] as [(LiteralInt, IXL)])
    func fromLiteralIntNearSizeEdgesOfUnsigned(literal: LiteralInt, expectation: IXL) throws {
        for type in typesAsBinaryInteger {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try #require(T.exactly(literal) == T.exactly(expectation))
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Literals x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerTestsOnLiteralsEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// Checks that integer literals aren't inferred as `Int` or `Double`.
    ///
    /// - Note: Neither `Int` nor `Double` can represent `I256.max`.
    ///
    /// - Note: Most, or all, literal conversions are `BinaryInteger` extensions.
    ///
    /// - Seealso: https://github.com/oscbyspro/Ultimathnum/issues/25
    ///
    @Test(
        "BinaryInteger/literals/edge-cases: generic type inference",
        Tag.List.tags(.generic, .important),
        arguments: typesAsArbitraryInteger
    )   func genericTypeInference(type: any ArbitraryInteger.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            let expectation = T.init(BinaryIntegerTestsOnLiterals.maxI256)
            
            let a: T =          (57896044618658097711785492504343953926634992332820282019728792003956564819967)
            let b: T = T        (57896044618658097711785492504343953926634992332820282019728792003956564819967)
            let c: T = T.init   (57896044618658097711785492504343953926634992332820282019728792003956564819967)
            let d: T = T.exactly(57896044618658097711785492504343953926634992332820282019728792003956564819967).value
            
            #expect(a == expectation)
            #expect(b == expectation)
            #expect(c == expectation)
            #expect(d == expectation)
        }
    }
}
