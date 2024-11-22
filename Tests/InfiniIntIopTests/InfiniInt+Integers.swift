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
// MARK: * Infini Int x Stdlib x Integers
//*============================================================================*

@Suite struct InfiniIntStdlibTestsOnIntegers {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt.Stdlib/integers: init(_:)",
        Tag.List.tags(.forwarding, .generic, .todo),
        ParallelizationTrait.serialized,
        arguments: Array<(any Swift.BinaryInteger & Sendable, IXL)>.infer([
        
        (  Int8.min, IXL(              -0x80)),
        (  Int8.max, IXL(               0x7f)),
        ( UInt8.min, IXL(               0x00)),
        ( UInt8.max, IXL(               0xff)),
        ( Int16.min, IXL(            -0x8000)),
        ( Int16.max, IXL(             0x7fff)),
        (UInt16.min, IXL(             0x0000)),
        (UInt16.max, IXL(             0xffff)),
        ( Int32.min, IXL(        -0x80000000)),
        ( Int32.max, IXL(         0x7fffffff)),
        (UInt32.min, IXL(         0x00000000)),
        (UInt32.max, IXL(         0xffffffff)),
        ( Int64.min, IXL(-0x8000000000000000)),
        ( Int64.max, IXL( 0x7fffffffffffffff)),
        (UInt64.min, IXL( 0x0000000000000000)),
        (UInt64.max, IXL( 0xffffffffffffffff)),
        
    ])) func initSwiftBinaryIntegerSamples(
        source: any Swift.BinaryInteger & Sendable, destination: IXL
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
            try Ɣrequire(source, is: T.Base.exactly(destination).map(T.init))
        }
    }
    
    @Test(
        "StdlibInt/integers: init(_:) - some Swift.BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .todo),
        arguments: fuzzers
    )   func initSwiftBinaryInteger(
        randomness: consuming FuzzerInt
    )   throws {

        for source in typesAsCoreInteger {
            for destination in typesAsInfiniIntStdlib {
                try whereIs(source: source, destination: destination)
            }
        }

        func whereIs<A, B>(source: A.Type, destination: B.Type)
        throws where A: CoreInteger, B: AdapterInteger {
            
            for _ in 0 ..< conditional(debug: 032, release: 1024) {
                let source = A.entropic(using: &randomness)
                let destination = B.Base.exactly(source)
                try Ɣrequire(A.Stdlib(source), is: destination.map(B.init))
            }
        }
    }
    
    @Test(
        "StdlibInt/integers: init(_:) - some Swift.BinaryInteger as Self",
        Tag.List.tags(.forwarding, .generic, .todo),
        arguments: fuzzers
    )   func initSwiftBinaryIntegerAsSelf(
        randomness: consuming FuzzerInt
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< conditional(debug: 32, release: 1024) {
                let source = T(T.Base.entropic(size: size, using: &randomness))
                try Ɣrequire(source, is: Fallible(source))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func Ɣrequire<A, B>(
        _  source: A,
        is destination: Fallible<B>,
        at location: SourceLocation = #_sourceLocation
    )   throws where A: Swift.BinaryInteger, B: AdapterInteger {
                
        always: do {
            try #require(B(destination.value)          == destination.value, sourceLocation: location)
            try #require(B(truncatingIfNeeded: source) == destination.value, sourceLocation: location)
        }
        
        if  let destination: B = destination.optional() {
            try #require(B(source)           == destination, sourceLocation: location)
            try #require(B(exactly:  source) == destination, sourceLocation: location)
            try #require(B(clamping: source) == destination, sourceLocation: location)
            
            if (A.isSigned == B.isSigned), destination.bitWidth <= source.bitWidth {
                try #require(A(                    destination) == source, sourceLocation: location)
                try #require(A(exactly:            destination) == source, sourceLocation: location)
                try #require(A(clamping:           destination) == source, sourceLocation: location)
                try #require(A(truncatingIfNeeded: destination) == source, sourceLocation: location)
            }
        }
        
        if  let destination: B = destination.optional() {
            let radix10 = destination.description(using:     .decimal)
            let radix16 = destination.description(using: .hexadecimal)
            
            try #require(radix10 ==      source.description, sourceLocation: location)
            try #require(radix10 == destination.description, sourceLocation: location)
            
            try #require(radix10 == String(destination, radix: 10), sourceLocation: location)
            try #require(radix16 == String(destination, radix: 16), sourceLocation: location)

            try #require(B(radix10)                      == destination, sourceLocation: location)
            try #require(B(radix10, using:     .decimal) == destination, sourceLocation: location)
            try #require(B(radix16, using: .hexadecimal) == destination, sourceLocation: location)
        }
    }
}
