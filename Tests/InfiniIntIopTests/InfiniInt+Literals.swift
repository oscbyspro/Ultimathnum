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
import InfiniIntIop
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Infini Int x Stdlib x Literals
//*============================================================================*

@Suite(.serialized) struct InfiniIntStdlibTestsOnLiterals {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt.Stdlib/literals: Self vs Base",
        Tag.List.tags(.forwarding, .generic, .todo),
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
        
    ])) func forwarding(literal: StaticBigInt) throws {

        try  whereIs(InfiniInt<I8>.Stdlib.self)
        try  whereIs(InfiniInt<IX>.Stdlib.self)
        
        func whereIs<T>(_ type: T.Type) throws where T: InfiniIntStdlib, T.IntegerLiteralType == StaticBigInt {
            let base   = T.Base(integerLiteral: literal)
            let stdlib = T.init(integerLiteral: literal)
            
            try #require(base == T.Base(stdlib))
            try #require(base == T.Base.exactly(LiteralInt(literal)).optional())
        }
    }
}
