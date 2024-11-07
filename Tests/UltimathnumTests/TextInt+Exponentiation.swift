//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Text Int x Exponentiation
//*============================================================================*

@Suite struct TextIntTestsOnExponentiation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("TextInt.Exponentiation: each radix < 2 is nil", .tags(.exhaustive))
    func eachRadixLessThanTwoIsNil() throws {
        for radix: UX in 0 ..< 2 {
            #expect(throws: TextInt.Error.invalid) {
                try TextInt.Exponentiation(radix)
            }
        }
    }
    
    @Test("TextInt.Exponentiation: each radix in [2, 1024]")
    func eachRadixFromTwoThrough1024() throws {
        for radix: UX in 2...1024 {
            let radixLog2: UX = UX(raw: try #require(radix    .ilog2()))
            let radixLog2Log2 = UX(raw: try #require(radixLog2.ilog2()))
            
            let instance = try TextInt.Exponentiation(radix)
            if  radix == UX.lsb << (UX.lsb << radixLog2Log2) {
                try #require(instance.power.isZero)
                try #require(instance.exponent == IX(size: UX.self) >> IX(radixLog2Log2))
            }   else {
                try #require(instance.power   .isPositive)
                try #require(instance.exponent.isPositive)
            }
        }
    }
}
