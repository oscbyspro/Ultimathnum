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
        "Division/ceil: [I8, U8] x [I8, U8]",
        Tag.List.tags(.exhaustive),
        arguments: typesAsCoreIntegerAsByte, typesAsCoreIntegerAsByte
    )   func ceil(_ quotient: any SystemsInteger.Type, _ remainder: any SystemsInteger.Type) {
        whereIs(quotient, remainder)
        
        func whereIs<Q, R>(_ quotient: Q.Type, _ remainder: R.Type) where Q: SystemsInteger, R: SystemsInteger {
            var success = IX.zero
            for quotient in Q.all {
                for remainder in R.nonpositives {
                    let division = Division(quotient: quotient, remainder: remainder)
                    success &+= IX(Bit(division.ceil() == quotient.veto(false)))
                }
                
                for remainder in R.positives {
                    let division = Division(quotient: quotient, remainder: remainder)
                    success &+= IX(Bit(division.ceil() == quotient.incremented()))
                }
            }
            
            #expect(success == IX(Q.all.count) &* IX(R.all.count))
        }
    }
    
    @Test(
        "Division/ceil: [I8, U8] x [I8, U8]",
        Tag.List.tags(.exhaustive),
        arguments: typesAsCoreIntegerAsByte, typesAsCoreIntegerAsByte
    )   func floor(quotient: any SystemsInteger.Type, remainder: any SystemsInteger.Type) {
        whereIs(quotient, remainder)
        
        func whereIs<Q, R>(_ quotient: Q.Type, _ remainder: R.Type) where Q: SystemsInteger, R: SystemsInteger {
            var success = IX.zero
            for quotient in Q.all {
                for remainder in R.negatives {
                    let division = Division(quotient: quotient, remainder: remainder)
                    success &+= IX(Bit(division.floor() == quotient.decremented()))
                }
                
                for remainder in R.nonnegatives {
                    let division = Division(quotient: quotient, remainder: remainder)
                    success &+= IX(Bit(division.floor() == quotient.veto(false)))
                }
            }
            
            #expect(success == IX(Q.all.count) &* IX(R.all.count))
        }
    }
}
