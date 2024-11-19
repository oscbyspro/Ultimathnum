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
// MARK: * Stdlib Int x Shift
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
@Suite struct StdlibIntTestsOnShift {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "StdlibInt/shift: bidirectional <<(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .random),
        arguments: fuzzers
    )   func shift(randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< 128 {
            let random   = IXL.entropic(size: 000256, using: &randomness)
            let distance = IXL.random(in: -128...127, using: &randomness)
            let expectation: IXL = random   <<  distance
            try Ɣrequire(StdlibInt(random), up: StdlibInt(distance), is: StdlibInt(expectation))
        }
    }
    
    @Test(
        "StdlibInt/shift: bidirectional <<(_:_:) near Int.max of Self vs Base",
        Tag.List.tags(.forwarding)
    )   func shiftByDistancesNearMaxInt() throws {
        try Ɣrequire(StdlibInt.zero, up: StdlibInt(Int.max) + 2, is: StdlibInt.zero)
        try Ɣrequire(StdlibInt.zero, up: StdlibInt(Int.max) + 1, is: StdlibInt.zero)
        try Ɣrequire(StdlibInt.zero, up: StdlibInt(Int.max),     is: StdlibInt.zero)
        try Ɣrequire(StdlibInt.zero, up: StdlibInt(Int.max) - 1, is: StdlibInt.zero)
        try Ɣrequire(StdlibInt.zero, up: StdlibInt(Int.max) - 2, is: StdlibInt.zero)
    }
    
    @Test(
        "StdlibInt/shift: bidirectional <<(_:_:) near Int.min of Self vs Base",
        Tag.List.tags(.forwarding, .random),
        arguments: fuzzers
    )   func shiftByDistancesNearMinInt(randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< 32 {
            let random = StdlibInt(IXL.entropic(size: 256, using: &randomness))
            let expectation = StdlibInt(IXL(repeating: Bit(random < 0)))
            try Ɣrequire(random, up: StdlibInt(Int.min) + 2, is: expectation)
            try Ɣrequire(random, up: StdlibInt(Int.min) + 1, is: expectation)
            try Ɣrequire(random, up: StdlibInt(Int.min),     is: expectation)
            try Ɣrequire(random, up: StdlibInt(Int.min) - 1, is: expectation)
            try Ɣrequire(random, up: StdlibInt(Int.min) - 2, is: expectation)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func Ɣrequire(
        _  instance: StdlibInt, up distance: StdlibInt, is expectation: StdlibInt,
        at location: SourceLocation = #_sourceLocation
    )   throws {
        
        let opposite: StdlibInt = -distance
        
        if  instance != 0, distance >= 0 {
            try #require((instance.bitWidth + Int(distance)) == expectation.bitWidth, sourceLocation: location)
        }
        
        always: do {
            try #require(reduce(instance, <<,  distance) == expectation, sourceLocation: location)
            try #require(reduce(instance, <<=, distance) == expectation, sourceLocation: location)
        }
        
        always: do {
            try #require(reduce(instance, >>,  opposite) == expectation, sourceLocation: location)
            try #require(reduce(instance, >>=, opposite) == expectation, sourceLocation: location)
        }
        
        if  let distance = Swift.Int(exactly:  distance) {
            try #require(reduce(instance, <<,  distance) == expectation, sourceLocation: location)
            try #require(reduce(instance, <<=, distance) == expectation, sourceLocation: location)
        }
        
        if  let opposite = Swift.Int(exactly:  opposite) {
            try #require(reduce(instance, >>,  opposite) == expectation, sourceLocation: location)
            try #require(reduce(instance, >>=, opposite) == expectation, sourceLocation: location)
        }
    }
}
