//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreIop
import CoreKit
import InfiniIntIop
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Infini Int x Stdlib x Shift
//*============================================================================*

@Suite struct InfiniIntStdlibTestsOnShift {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt.Stdlib/shift: bidirectional <<(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: fuzzers
    )   func shift(
        randomness: consuming FuzzerInt
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< 128 {
                let value =  T.Base.entropic(size:  size, using: &randomness)
                let distance = IXL.random(in: -128...127, using: &randomness)
                let expectation: T.Base =  value << distance
                try Ɣrequire(T(value), up: distance.stdlib(), is: T(expectation))
            }
        }        
    }
    
    @Test(
        "InfiniInt.Stdlib/shift: bidirectional <<(_:_:) near Int.max of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .todo)
    )   func shiftByDistancesNearMaxInt() throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
            try Ɣrequire(T.zero, up: IXL.Stdlib(Int.min) + 2, is: T.zero)
            try Ɣrequire(T.zero, up: IXL.Stdlib(Int.max) + 1, is: T.zero)
            try Ɣrequire(T.zero, up: IXL.Stdlib(Int.max),     is: T.zero)
            try Ɣrequire(T.zero, up: IXL.Stdlib(Int.max) - 1, is: T.zero)
            try Ɣrequire(T.zero, up: IXL.Stdlib(Int.max) - 2, is: T.zero)
        }
    }
    
    @Test(
        "InfiniInt.Stdlib/shift: bidirectional <<(_:_:) near Int.min of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: fuzzers
    )   func shiftByDistancesNearMinInt(
        randomness: consuming FuzzerInt
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< 32 {
                let value = T(T.Base.entropic(size: size, using: &randomness))
                let expectation = T(T.Base(repeating: Bit(value < 0)))
                try Ɣrequire(value, up: IXL.Stdlib(Int.min) + 2, is: expectation)
                try Ɣrequire(value, up: IXL.Stdlib(Int.min) + 1, is: expectation)
                try Ɣrequire(value, up: IXL.Stdlib(Int.min),     is: expectation)
                try Ɣrequire(value, up: IXL.Stdlib(Int.min) - 1, is: expectation)
                try Ɣrequire(value, up: IXL.Stdlib(Int.min) - 2, is: expectation)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func Ɣrequire<T>(
        _  instance: T, up distance: IXL.Stdlib, is expectation: T,
        at location: SourceLocation = #_sourceLocation
    )   throws where T: AdapterInteger {
        
        let opposite: IXL.Stdlib = -distance
        
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
        
        if  let distance = T(exactly:  distance) {
            try #require(reduce(instance, <<,  distance) == expectation, sourceLocation: location)
            try #require(reduce(instance, <<=, distance) == expectation, sourceLocation: location)
        }
        
        if  let opposite = T(exactly:  opposite) {
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
