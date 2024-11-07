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
import TestKit

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
    
    @Test("StdlibInt/stride: vs StdlibInt.Base", .tags(.forwarding, .random), arguments: fuzzers)
    func forwarding(randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< 256 {
            let start    = IXL.entropic(through: Shift.max(or: 255), using: &randomness)
            let distance = IX .entropic(through: Shift.max(or: 255), using: &randomness)
            let end      = try #require(start.advanced(by: distance).optional())
            
            try #require(StdlibInt(start).advanced(by: Swift.Int(distance)) == StdlibInt(end))
            try #require(StdlibInt(start).distance(to: StdlibInt(end)) == Swift.Int(distance))
        }
    }
}
