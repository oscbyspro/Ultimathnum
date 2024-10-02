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
    
    @Test("StdlibInt.<<(_:_:) - [forwarding][entropic]", arguments: fuzzers)
    func shift(_ randomness: consuming FuzzerInt) {
        for _ in 0 ..< 32 {
            let instance = IXL.entropic(size: 000256, using: &randomness)
            let distance = IXL.random(in: -128...127, using: &randomness)
            let expectation = instance << distance
            Ɣexpect(StdlibInt(instance), up: StdlibInt(distance), is: StdlibInt(expectation))
        }
    }
    
    @Test("StdlibInt.<<(_:_:) - Int.max [forwarding]")
    func shiftByDistancesNearMaxInt() {
        Ɣexpect(StdlibInt.zero, up: StdlibInt(Int.max) + 2, is: StdlibInt.zero)
        Ɣexpect(StdlibInt.zero, up: StdlibInt(Int.max) + 1, is: StdlibInt.zero)
        Ɣexpect(StdlibInt.zero, up: StdlibInt(Int.max),     is: StdlibInt.zero)
        Ɣexpect(StdlibInt.zero, up: StdlibInt(Int.max) - 1, is: StdlibInt.zero)
        Ɣexpect(StdlibInt.zero, up: StdlibInt(Int.max) - 2, is: StdlibInt.zero)
    }
    
    @Test("StdlibInt.<<(_:_:) - Int.min [forwarding][entropic]", arguments: fuzzers)
    func shiftByDistancesNearMinInt(_ randomness: consuming FuzzerInt) {
        for _ in 0 ..< 32 {
            let random = StdlibInt(IXL.entropic(size: 256, using: &randomness))
            let expectation = StdlibInt(IXL(repeating: Bit(random < 0)))
            Ɣexpect(random, up: StdlibInt(Int.min) + 2, is: expectation)
            Ɣexpect(random, up: StdlibInt(Int.min) + 1, is: expectation)
            Ɣexpect(random, up: StdlibInt(Int.min),     is: expectation)
            Ɣexpect(random, up: StdlibInt(Int.min) - 1, is: expectation)
            Ɣexpect(random, up: StdlibInt(Int.min) - 2, is: expectation)
        }
    }
    
    /// - Note: This method checks `ascending` and `descending` shifts.
    func Ɣexpect(_ instance: StdlibInt, up distance: StdlibInt, is expectation: StdlibInt, at location: SourceLocation = #_sourceLocation) {
        //=--------------------------------------=
        let opposite: StdlibInt = -distance
        //=--------------------------------------=
        if  instance != 0, distance >= 0 {
            #expect((instance.bitWidth + Int(distance)) == expectation.bitWidth, sourceLocation: location)
        }
        
        always: do {
            #expect((instance << distance) == expectation, sourceLocation: location)
            #expect({ var x = instance; x <<= distance; return x }() == expectation, sourceLocation: location)
        }
        
        always: do {
            #expect((instance >> opposite) == expectation, sourceLocation: location)
            #expect({ var x = instance; x >>= opposite; return x }() == expectation, sourceLocation: location)
        }
        
        if  let distance = Swift.Int(exactly: distance) {
            #expect((instance << distance) == expectation, sourceLocation: location)
            #expect({ var x = instance; x <<= distance; return x }() == expectation, sourceLocation: location)
        }
        
        if  let opposite = Swift.Int(exactly: opposite) {
            #expect((instance >> opposite) == expectation, sourceLocation: location)
            #expect({ var x = instance; x >>= opposite; return x }() == expectation, sourceLocation: location)
        }
    }
}
