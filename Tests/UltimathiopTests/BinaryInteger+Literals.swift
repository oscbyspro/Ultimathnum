//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreIop
import CoreKit
import DoubleIntIop
import DoubleIntKit
import InfiniIntIop
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Double Int x Stdlib x Literals
//*============================================================================*

@Suite(.serialized) struct BinaryIntegerStdlibTestsOnLiterals {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/literals: as Swift.BinaryInteger",
        Tag.List.tags(.generic, .todo),
        arguments: Array<StaticBigInt>.infer([
        
        StaticBigInt(-129),
        StaticBigInt(-128),
        StaticBigInt(-127),
        StaticBigInt( 126),
        StaticBigInt( 127),
        StaticBigInt( 128),
        
        StaticBigInt(-32769),
        StaticBigInt(-32768),
        StaticBigInt(-32767),
        StaticBigInt( 32766),
        StaticBigInt( 32767),
        StaticBigInt( 32768),
        
        StaticBigInt(-2147483649),
        StaticBigInt(-2147483648),
        StaticBigInt(-2147483647),
        StaticBigInt( 2147483646),
        StaticBigInt( 2147483647),
        StaticBigInt( 2147483648),
        
        StaticBigInt(-9223372036854775809),
        StaticBigInt(-9223372036854775808),
        StaticBigInt(-9223372036854775807),
        StaticBigInt( 9223372036854775806),
        StaticBigInt( 9223372036854775807),
        StaticBigInt( 9223372036854775808),
        
        StaticBigInt(-170141183460469231731687303715884105729),
        StaticBigInt(-170141183460469231731687303715884105728),
        StaticBigInt(-170141183460469231731687303715884105727),
        StaticBigInt( 170141183460469231731687303715884105726),
        StaticBigInt( 170141183460469231731687303715884105727),
        StaticBigInt( 170141183460469231731687303715884105728),
        
        StaticBigInt(-57896044618658097711785492504343953926634992332820282019728792003956564819969),
        StaticBigInt(-57896044618658097711785492504343953926634992332820282019728792003956564819968),
        StaticBigInt(-57896044618658097711785492504343953926634992332820282019728792003956564819967),
        StaticBigInt( 57896044618658097711785492504343953926634992332820282019728792003956564819966),
        StaticBigInt( 57896044618658097711785492504343953926634992332820282019728792003956564819967),
        StaticBigInt( 57896044618658097711785492504343953926634992332820282019728792003956564819968),
        
    ])) func asSwiftBinaryInteger(literal: StaticBigInt) throws {
        
        // TODO: IntegerLiteralType protocol requirements..?
        
        let value = IXL.Stdlib(IXL(integerLiteral: literal))
        
        try whereIs(IX .Stdlib.self)
        try whereIs(I8 .Stdlib.self)
        try whereIs(I16.Stdlib.self)
        try whereIs(I32.Stdlib.self)
        try whereIs(I64.Stdlib.self)
        
        try whereIs(UX .Stdlib.self)
        try whereIs(U8 .Stdlib.self)
        try whereIs(U16.Stdlib.self)
        try whereIs(U32.Stdlib.self)
        try whereIs(U64.Stdlib.self)
        
        try whereIs(DoubleInt<I8>.Stdlib.self)
        try whereIs(DoubleInt<U8>.Stdlib.self)
        
        try whereIs(DoubleInt<DoubleInt<I8>>.Stdlib.self)
        try whereIs(DoubleInt<DoubleInt<U8>>.Stdlib.self)
        
        try whereIs(InfiniInt<I8>.Stdlib.self)
        try whereIs(InfiniInt<IX>.Stdlib.self)
        
        func whereIs<T>(_ type: T.Type) throws where T: Swift.BinaryInteger, T.IntegerLiteralType == StaticBigInt {
            guard let expectation = T(exactly: value) else { return }
            try #require(expectation == T(integerLiteral: literal))
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: Swift.BinaryInteger, T.IntegerLiteralType: Swift.BinaryInteger {
            guard let expectation = T(exactly: value) else { return }
            guard let literal = T.IntegerLiteralType(exactly: value) else { return }
            try #require(expectation == T(integerLiteral: literal))
        }
    }
}
