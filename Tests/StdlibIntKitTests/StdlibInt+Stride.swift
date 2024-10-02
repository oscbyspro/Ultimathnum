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
// MARK: * Stdlib Int x Stride
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
@Suite struct StdlibIntTestsOnStride {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("StdlibInt - stride [forwarding][entropic]", arguments: fuzzers)
    func stride(_ randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< 256 {
            let distance = IX.entropic(using: &randomness)
            let start = IXL.entropic(size: 256, using: &randomness)
            let end = try start.advanced(by: distance).prune(Bad.error)
            #expect(StdlibInt(start).advanced(by: Swift.Int(distance)) == StdlibInt(end))
            #expect(StdlibInt(start).distance(to: StdlibInt(end)) == Swift.Int(distance))
        }
    }
}
