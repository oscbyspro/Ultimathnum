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
// MARK: * Stdlib Int x Integers
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
@Suite struct StdlibIntTestsOnIntegers {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "StdlibInt/integers: magnitude",
        Tag.List.tags(.forwarding, .random),
        arguments: fuzzers
    )   func magnitude(
        randomness: consuming FuzzerInt
    )   throws {
        for _ in 0 ..< 32 {
            let random = IXL.entropic(size: 256, using: &randomness)
            let expectation = IXL(random.magnitude())
            try #require(StdlibInt(random).magnitude == StdlibInt(expectation))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Swift.BinaryInteger
    //=------------------------------------------------------------------------=
    
    @Test(
        "StdlibInt/integers: init(some Swift.BinaryInteger)",
        Tag.List.tags(.forwarding),
        ParallelizationTrait.serialized,
        arguments: Array<(any Swift.BinaryInteger & Sendable, StdlibInt)>([
        
        (  Int8.min as any (Swift.BinaryInteger & Sendable),               -0x80 as StdlibInt),
        (  Int8.max as any (Swift.BinaryInteger & Sendable),                0x7f as StdlibInt),
        ( UInt8.min as any (Swift.BinaryInteger & Sendable),                0x00 as StdlibInt),
        ( UInt8.max as any (Swift.BinaryInteger & Sendable),                0xff as StdlibInt),
        ( Int16.min as any (Swift.BinaryInteger & Sendable),             -0x8000 as StdlibInt),
        ( Int16.max as any (Swift.BinaryInteger & Sendable),              0x7fff as StdlibInt),
        (UInt16.min as any (Swift.BinaryInteger & Sendable),              0x0000 as StdlibInt),
        (UInt16.max as any (Swift.BinaryInteger & Sendable),              0xffff as StdlibInt),
        ( Int32.min as any (Swift.BinaryInteger & Sendable),         -0x80000000 as StdlibInt),
        ( Int32.max as any (Swift.BinaryInteger & Sendable),          0x7fffffff as StdlibInt),
        (UInt32.min as any (Swift.BinaryInteger & Sendable),          0x00000000 as StdlibInt),
        (UInt32.max as any (Swift.BinaryInteger & Sendable),          0xffffffff as StdlibInt),
        ( Int64.min as any (Swift.BinaryInteger & Sendable), -0x8000000000000000 as StdlibInt),
        ( Int64.max as any (Swift.BinaryInteger & Sendable),  0x7fffffffffffffff as StdlibInt),
        (UInt64.min as any (Swift.BinaryInteger & Sendable),  0x0000000000000000 as StdlibInt),
        (UInt64.max as any (Swift.BinaryInteger & Sendable),  0xffffffffffffffff as StdlibInt),
        
    ])) func initSwiftBinaryInteger(
        source: any Swift.BinaryInteger & Sendable, destination: StdlibInt
    )   throws {
        try Ɣrequire(source, is: destination)
    }
    
    @Test(
        "StdlibInt/integes: init(some Swift.BinaryInteger)",
        Tag.List.tags(.forwarding, .random),
        arguments: fuzzers
    )   func initSwiftBinaryInteger(
        randomness: consuming FuzzerInt
    )   throws {
        for _ in 0 ..<   conditional(debug: 032, release: 1024) {
            let random = IXL.entropic(size: 256, using: &randomness)
            try #require(IXL(StdlibInt(random)) == random)
            try Ɣrequire(StdlibInt(random), is: StdlibInt(random))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func Ɣrequire<T>(
        _  source: T,
        is destination: StdlibInt,
        at location: SourceLocation = #_sourceLocation
    )   throws where T: Swift.BinaryInteger {
        
        try #require(StdlibInt(                    source) == destination, sourceLocation: location)
        try #require(StdlibInt(exactly:            source) == destination, sourceLocation: location)
        try #require(StdlibInt(clamping:           source) == destination, sourceLocation: location)
        try #require(StdlibInt(truncatingIfNeeded: source) == destination, sourceLocation: location)
        try #require(StdlibInt(InfiniInt<IX>(destination)) == destination, sourceLocation: location)
        
        if  T.isSigned == StdlibInt.isSigned, destination.bitWidth <= source.bitWidth {
            try #require(T(                    destination)  == source, sourceLocation: location)
            try #require(T(exactly:            destination)! == source, sourceLocation: location)
            try #require(T(clamping:           destination)  == source, sourceLocation: location)
            try #require(T(truncatingIfNeeded: destination)  == source, sourceLocation: location)
        }
        
        description: do {
            let radix10 = destination.description(as:     .decimal)
            let radix16 = destination.description(as: .hexadecimal)
            
            try #require(radix10 ==      source.description,        sourceLocation: location)
            try #require(radix10 == destination.description,        sourceLocation: location)
            try #require(radix10 == String(destination, radix: 10), sourceLocation: location)
            try #require(radix16 == String(destination, radix: 16), sourceLocation: location)
            
            try #require(    StdlibInt(radix10) ==                   destination, sourceLocation: location)
            try #require(try StdlibInt(radix10, as:     .decimal) == destination, sourceLocation: location)
            try #require(try StdlibInt(radix16, as: .hexadecimal) == destination, sourceLocation: location)
        }
    }
}
