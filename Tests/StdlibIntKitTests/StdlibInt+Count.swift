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
import RandomIntKit
import StdlibIntKit
import TestKit2

//*============================================================================*
// MARK: * Stdlib Int x Count
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
@Suite struct StdlibIntTestsOnCount {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("StdlibInt/count: vs StdlibInt.Base", .tags(.forwarding, .random), arguments: fuzzers)
    func forwarding(_ randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< 1024 {
            let random = IXL.entropic(through: Shift.max(or: 255), using: &randomness)
            
            always: do {
                let a = StdlibInt(random).bitWidth
                let b = Swift.Int(IX(raw: random.entropy()))
                try #require(a == b)
            }
            
            always: do {
                let a = StdlibInt(random).trailingZeroBitCount
                let b = Swift.Int(IX(IX(raw: random.ascending(Bit.zero)).magnitude()))
                try #require(a == b)
            }
        }
    }
}

//*============================================================================*
// MARK: * Stdlib Int x Count x Edge Cases
//*============================================================================*

@Suite struct StdlibIntTestsOnCountEdgeCases {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("StdlibInt/count/edge-cases: 0.trailingZeroBitCount", .tags(.exhaustive))
    func trailingZeroBitCountOfZero() {
        #expect(IXL.zero.ascending(Bit.zero) == Count.infinity)
        #expect(StdlibInt(IXL.zero).trailingZeroBitCount == 1)
        #expect(StdlibInt(IXL.zero).trailingZeroBitCount == StdlibInt.zero.bitWidth)
    }
}
