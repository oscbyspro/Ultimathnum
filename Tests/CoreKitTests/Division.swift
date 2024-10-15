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
import TestKit2

//*============================================================================*
// MARK: * Division
//*============================================================================*

@Suite struct DivisionTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Division/init(raw:) - T.init(load:)", .serialized, arguments: I8(-2)...I8(2), I8(-2)...I8(2))
    func pattern(quotient: I8, remainder: I8) {
        for quotient in typesAsCoreInteger {
            for remainder in typesAsCoreInteger {
                whereIs(quotient, remainder)
            }
        }
        
        func whereIs<Q, R>(_ first: Q.Type,  _ second: R.Type) where Q: BinaryInteger, R: BinaryInteger {
            let normal    = Division(quotient: Q          (load: quotient), remainder: R          (load: remainder))
            let magnitude = Division(quotient: Q.Magnitude(load: quotient), remainder: R.Magnitude(load: remainder))
            let signitude = Division(quotient: Q.Signitude(load: quotient), remainder: R.Signitude(load: remainder))
            #expect(normal == Division<Q, R>(raw: magnitude))
            #expect(normal == Division<Q, R>(raw: signitude))
        }
    }
    
    @Test("Division/components() - T.init(load:)", .serialized, arguments: I8(-2)...I8(2), I8(-2)...I8(2))
    func components(quotient: I8, remainder: I8) {
        for quotient in typesAsCoreInteger {
            for remainder in typesAsCoreInteger {
                whereIs(quotient, remainder)
            }
        }
        
        func whereIs<Q, R>(_ first: Q.Type,  _ second: R.Type) where Q: BinaryInteger, R: BinaryInteger {
            let quotient  = Q(load: quotient )
            let remainder = R(load: remainder)
            let division  = Division(quotient: quotient, remainder: remainder)
            #expect(division.components() ==  (quotient, remainder))
        }
    }
}
