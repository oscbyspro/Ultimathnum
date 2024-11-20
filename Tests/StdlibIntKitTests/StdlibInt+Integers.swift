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
        "StdlibInt/integers: init(_:)",
        Tag.List.tags(.forwarding),
        ParallelizationTrait.serialized,
        arguments: Array<(any Swift.BinaryInteger & Sendable, StdlibInt)>.infer([
        
        (  Int8.min, StdlibInt(              -0x80)),
        (  Int8.max, StdlibInt(               0x7f)),
        ( UInt8.min, StdlibInt(               0x00)),
        ( UInt8.max, StdlibInt(               0xff)),
        ( Int16.min, StdlibInt(            -0x8000)),
        ( Int16.max, StdlibInt(             0x7fff)),
        (UInt16.min, StdlibInt(             0x0000)),
        (UInt16.max, StdlibInt(             0xffff)),
        ( Int32.min, StdlibInt(        -0x80000000)),
        ( Int32.max, StdlibInt(         0x7fffffff)),
        (UInt32.min, StdlibInt(         0x00000000)),
        (UInt32.max, StdlibInt(         0xffffffff)),
        ( Int64.min, StdlibInt(-0x8000000000000000)),
        ( Int64.max, StdlibInt( 0x7fffffffffffffff)),
        (UInt64.min, StdlibInt( 0x0000000000000000)),
        (UInt64.max, StdlibInt( 0xffffffffffffffff)),
        
    ])) func initSwiftBinaryIntegerSamples(
        source: any Swift.BinaryInteger & Sendable, destination: StdlibInt
    )   throws {
        try Ɣrequire(source, is: destination)
    }
    
    @Test(
        "StdlibInt/integers: init(_:)",
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
        
        if  T.isSigned == StdlibInt.isSigned,  destination.bitWidth <=  source.bitWidth {
            try #require(T(                    destination)  == source, sourceLocation: location)
            try #require(T(exactly:            destination)! == source, sourceLocation: location)
            try #require(T(clamping:           destination)  == source, sourceLocation: location)
            try #require(T(truncatingIfNeeded: destination)  == source, sourceLocation: location)
        }
        
        description: do {
            let radix10 = destination.description(using:     .decimal)
            let radix16 = destination.description(using: .hexadecimal)
            
            try #require(radix10 ==      source.description,        sourceLocation: location)
            try #require(radix10 == destination.description,        sourceLocation: location)
            try #require(radix10 == String(destination, radix: 10), sourceLocation: location)
            try #require(radix16 == String(destination, radix: 16), sourceLocation: location)
            
            try #require(StdlibInt(radix10) ==                      destination, sourceLocation: location)
            try #require(StdlibInt(radix10, using:     .decimal) == destination, sourceLocation: location)
            try #require(StdlibInt(radix16, using: .hexadecimal) == destination, sourceLocation: location)
        }
    }
}
