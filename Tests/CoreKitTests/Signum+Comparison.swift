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
// MARK: * Signum x Comparison
//*============================================================================*

@Suite struct SignumTestsOnComparison {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Signum/isNegative", .serialized, arguments: [
        
        Some(Signum.negative, yields: true ),
        Some(Signum.zero,     yields: false),
        Some(Signum.positive, yields: false),
        
    ])  func isNegative(_ arguments: Some<Signum, Bool>) {
        #expect(arguments.input.isNegative == arguments.output)
    }
    
    @Test("Signum/isZero", .serialized, arguments: [
        
        Some(Signum.negative, yields: false),
        Some(Signum.zero,     yields: true ),
        Some(Signum.positive, yields: false),
        
    ])  func isZero(_ arguments: Some<Signum, Bool>) {
        #expect(arguments.input.isZero == arguments.output)
    }
    
    @Test("Signum/isPositive", .serialized, arguments: [
        
        Some(Signum.negative, yields: false),
        Some(Signum.zero,     yields: false),
        Some(Signum.positive, yields: true ),
        
    ])  func isPositive(_ argument: Some<Signum, Bool>) {
        #expect(argument.input.isPositive == argument.output)
    }
    
    @Test("Signum/compared(to:)", .serialized, arguments: [
        
        Some(Signum.negative, Signum.negative, yields: Signum.zero),
        Some(Signum.negative, Signum.zero,     yields: Signum.negative),
        Some(Signum.negative, Signum.positive, yields: Signum.negative),
        Some(Signum.zero,     Signum.negative, yields: Signum.positive),
        Some(Signum.zero,     Signum.zero,     yields: Signum.zero),
        Some(Signum.zero,     Signum.positive, yields: Signum.negative),
        Some(Signum.positive, Signum.negative, yields: Signum.positive),
        Some(Signum.positive, Signum.zero,     yields: Signum.positive),
        Some(Signum.positive, Signum.positive, yields: Signum.zero),
        
    ])  func compare(_ argument: Some<Signum, Signum, Signum>) {
        Ɣexpect(argument.0, equals: argument.1, is:    argument.output)
        #expect(argument.0.compared(to: argument.1) == argument.output)
    }
}
