//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit2

//*============================================================================*
// MARK: * Division x Rounding
//*============================================================================*

@Suite struct DivisionTestsOnRounding {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Division/ceil() - [I8, U8]", .tags(.exhaustive), arguments: typesAsCoreIntegerAsByte, typesAsCoreIntegerAsByte)
    func ceil(_ quotient: any SystemsInteger.Type, _ remainder: any SystemsInteger.Type) {
        whereIs(quotient, remainder)
        
        func whereIs<Q, R>(_ quotient: Q.Type, _ remainder: R.Type) where Q: SystemsInteger, R: SystemsInteger {
            var success:     U32 = 0000000000000
            let expectation: U32 = 3 * 256 * 256
            
            for quotient in Q.all {
                for remainder in R.nonpositives {
                    ceil(quotient, remainder, is: Fallible(quotient))
                }
                
                for remainder in R.positives {
                    ceil(quotient, remainder, is: quotient.plus(1))
                }
            }
            
            #expect(success == expectation)

            func ceil(_ quotient: Q, _ remainder: R, is expectation: Fallible<Q>) {
                let division = Division(quotient: quotient, remainder: remainder)
                success &+= U32(Bit(division            .ceil() == expectation))
                success &+= U32(Bit(division.veto(false).ceil() == expectation))
                success &+= U32(Bit(division.veto(true ).ceil() == expectation.veto()))
            }
        }
    }
    
    @Test("Division/floor() - [I8, U8]", .tags(.exhaustive), arguments: typesAsCoreIntegerAsByte, typesAsCoreIntegerAsByte)
    func floor(_ quotient: any SystemsInteger.Type, _ remainder: any SystemsInteger.Type) {
        whereIs(quotient, remainder)
        
        func whereIs<Q, R>(_ quotient: Q.Type, _ remainder: R.Type) where Q: SystemsInteger, R: SystemsInteger {
            var success:     U32 = 0000000000000
            let expectation: U32 = 3 * 256 * 256
            
            for quotient in Q.all {
                for remainder in R.negatives {
                    floor(quotient, remainder, is: quotient.minus(1))
                }
                
                for remainder in R.nonnegatives {
                    floor(quotient, remainder, is: Fallible(quotient))
                }
            }
            
            #expect(success == expectation)
            
            func floor(_ quotient: Q, _ remainder: R, is expectation: Fallible<Q>) {
                let division = Division(quotient: quotient, remainder: remainder)
                success &+= U32(Bit(division            .floor() == expectation))
                success &+= U32(Bit(division.veto(false).floor() == expectation))
                success &+= U32(Bit(division.veto(true ).floor() == expectation.veto()))
            }
        }
    }
}
