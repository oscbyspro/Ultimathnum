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
    )   func genericTypeInference(type: any ArbitraryInteger.Type) throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let expectation = T(repeating: Bit.one).up(Count(255)).toggled()
            
            let a: T =       (57896044618658097711785492504343953926634992332820282019728792003956564819967)
            let b: T = T     (57896044618658097711785492504343953926634992332820282019728792003956564819967)
            let c: T = T.init(57896044618658097711785492504343953926634992332820282019728792003956564819967)
            
            #expect(a == expectation)
            #expect(b == expectation)
            #expect(c == expectation)
        }
    }
}
