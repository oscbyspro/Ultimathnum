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
import StdlibIntKit
import TestKit

//*============================================================================*
// MARK: * Stdlib Int x Literals
//*============================================================================*

/// An `StdlibInt` test suite.
///
/// ### Wrapper
///
/// `StdlibInt` should forward most function calls to its underlying model.
///
/// ### Development
///
/// - TODO: Test `StdlibInt` forwarding in generic `BinaryInteger` tests.
///
@Suite struct StdlibIntTestsOnLiterals {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "StdlibInt/literals: Self vs Base",
        Tag.List.tags(.forwarding),
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
        typealias Base = IXL
        
        let base   = Base.init(integerLiteral: literal)
        let stdlib = StdlibInt(integerLiteral: literal)
        
        try #require(base == Base(stdlib))
        try #require(Base.exactly(LiteralInt(literal)).optional() == base)
    }
}
