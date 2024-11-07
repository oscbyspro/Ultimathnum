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
import InfiniIntKit
import StdlibIntKit
import TestKit

//*============================================================================*
// MARK: * Stdlib Int x Division
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
@Suite("StdlibInt/division") struct StdlibIntTestsOnDivision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("StdlibInt/division: vs StdlibInt.Base", .tags(.forwarding, .random), arguments: fuzzers)
    func forwarding(_ randomness: consuming FuzzerInt) {
        for _ in 0 ..< conditional(debug: 64, release: 128) {
            let dividend = IXL.entropic(through: Shift.max(or: 255), using: &randomness)
            let divisor  = IXL.entropic(through: Shift.max(or: 255), using: &randomness)
            
            if  let divisor = Nonzero(exactly: divisor) {
                let a = StdlibInt(dividend)
                let b = StdlibInt(divisor.value)
                let c = a.quotientAndRemainder(dividingBy: b)
                
                #expect(c.quotient  == ( a / b ))
                #expect(c.remainder == ( a % b ))
                #expect(c.quotient  == { var x = a; x /= b; return x }())
                #expect(c.remainder == { var x = a; x %= b; return x }())
                
                let division = Fallible(Division(quotient: IXL(c.quotient), remainder: IXL(c.remainder)))
                Ɣexpect(bidirectional: dividend, by: divisor, is: division)
            }   else {
                Ɣexpect(bidirectional: dividend, by: divisor, is: nil)
            }
        }
    }
}
