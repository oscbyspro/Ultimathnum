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
// MARK: * Division x Rounding
//*============================================================================*

@Suite struct DivisionTestsOnRounding {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Division/rounding: ceil()",
        Tag.List.tags(.exhaustive, .generic),
        arguments: typesAsCoreIntegerAsByte, typesAsCoreIntegerAsByte
    )   func ceil(
        quotient: any SystemsInteger.Type, remainder: any SystemsInteger.Type
    )   throws {
        
        try  whereIs(quotient, remainder)
        func whereIs<Q, R>(_ quotient: Q.Type, _ remainder: R.Type) throws where Q: SystemsInteger, R: SystemsInteger {
            try withOnlyOneCallToRequire((quotient, remainder)) { require in
                for quotient in Q.all {
                    for remainder in R.nonpositives {
                        let division = Division(quotient: quotient, remainder: remainder)
                        require(division.ceil() == quotient.veto(false))
                    }
                    
                    for remainder in R.positives {
                        let division = Division(quotient: quotient, remainder: remainder)
                        require(division.ceil() == quotient.incremented())
                    }
                }
            }
        }
    }
    
    @Test(
        "Division/rounding: floor()",
        Tag.List.tags(.exhaustive, .generic),
        arguments: typesAsCoreIntegerAsByte, typesAsCoreIntegerAsByte
    )   func floor(
        quotient: any SystemsInteger.Type, remainder: any SystemsInteger.Type
    )   throws {
        
        try  whereIs(quotient, remainder)
        func whereIs<Q, R>(_ quotient: Q.Type, _ remainder: R.Type) throws where Q: SystemsInteger, R: SystemsInteger {
            try withOnlyOneCallToRequire((quotient, remainder)) { require in
                for quotient in Q.all {
                    for remainder in R.negatives {
                        let division = Division(quotient: quotient, remainder: remainder)
                        require(division.floor() == quotient.decremented())
                    }
                    
                    for remainder in R.nonnegatives {
                        let division = Division(quotient: quotient, remainder: remainder)
                        require(division.floor() == quotient.veto(false))
                    }
                }
            }
        }
    }
}
