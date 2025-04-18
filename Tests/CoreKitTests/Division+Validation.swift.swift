//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Division x Validation
//*============================================================================*

@Suite struct DivisionTestsOnValidation {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
 
    @Test(
        "Division/validation: exactly()",
        Tag.List.tags(.generic),
        ParallelizationTrait.serialized,
        arguments: I8(-2)...I8(2), I8(-2)...I8(2)
    )   func exactly(quotient: I8, remainder: I8) throws {
        
        let error = !remainder.isZero
        for quotient in typesAsCoreInteger {
            for remainder in typesAsCoreInteger {
                try whereIs(quotient, remainder)
            }
        }
        
        func whereIs<Q, R>(_ first: Q.Type, _ second: R.Type) throws where Q: BinaryInteger, R: BinaryInteger {
            let division = Division(quotient: Q(load: quotient), remainder: R(load:  remainder))
            try #require(division.exactly() == Fallible(division.quotient, error: error))
        }
    }
}
