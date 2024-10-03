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
    
    @Test("StdlibInt/magnitude", .serialized, arguments: [
        
        (-2 as StdlibInt, 2 as StdlibInt),
        (-1 as StdlibInt, 1 as StdlibInt),
        ( 0 as StdlibInt, 0 as StdlibInt),
        ( 1 as StdlibInt, 1 as StdlibInt),
        ( 2 as StdlibInt, 2 as StdlibInt),
        
    ] as [(StdlibInt, StdlibInt)])
    func magnitude(instance: StdlibInt, expectation: StdlibInt) {
        #expect(instance.magnitude == expectation)
    }
    
    @Test("StdlibInt/magnitude - [forwarding][entropic]", arguments: fuzzers)
    func magnitude(randomness: consuming FuzzerInt) {
        for _ in 0 ..< 32 {
            let random = IXL.entropic(size: 256, using: &randomness)
            let expectation = IXL(random.magnitude())
            #expect(StdlibInt(random).magnitude == StdlibInt(expectation))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Swift.BinaryInteger
    //=------------------------------------------------------------------------=
    
    @Test("StdlibInt.init(some Swift.BinaryInteger)", .serialized, arguments: [
        
        (  Int8.min,               -0x80 as StdlibInt),
        (  Int8.max,                0x7f as StdlibInt),
        ( UInt8.min,                0x00 as StdlibInt),
        ( UInt8.max,                0xff as StdlibInt),
        ( Int16.min,             -0x8000 as StdlibInt),
        ( Int16.max,              0x7fff as StdlibInt),
        (UInt16.min,              0x0000 as StdlibInt),
        (UInt16.max,              0xffff as StdlibInt),
        ( Int32.min,         -0x80000000 as StdlibInt),
        ( Int32.max,          0x7fffffff as StdlibInt),
        (UInt32.min,          0x00000000 as StdlibInt),
        (UInt32.max,          0xffffffff as StdlibInt),
        ( Int64.min, -0x8000000000000000 as StdlibInt),
        ( Int64.max,  0x7fffffffffffffff as StdlibInt),
        (UInt64.min,  0x0000000000000000 as StdlibInt),
        (UInt64.max,  0xffffffffffffffff as StdlibInt),
        
    ] as [(any Swift.BinaryInteger, StdlibInt)])
    func initSwiftBinaryInteger(source: any Swift.BinaryInteger, destination: StdlibInt) throws {
        try Ɣexpect(source, is: destination)
    }
    
    @Test("StdlibInt.init(some Swift.BinaryInteger) - [entropic]", arguments: fuzzers)
    func initSwiftBinaryInteger(randomness: consuming FuzzerInt) throws {
        for _ in 0 ..<   conditional(debug: 032, release: 1024) {
            let random = IXL.entropic(size: 256, using: &randomness)
            #expect(IXL(StdlibInt(random))  ==   random)
            try Ɣexpect(StdlibInt(random),  is:  StdlibInt(random))
        }
    }
    
    func Ɣexpect<T>(
        _  source: T,
        is destination: StdlibInt,
        at location: SourceLocation = #_sourceLocation
    )   throws where T: Swift.BinaryInteger {
        
        #expect(StdlibInt(                    source) == destination, sourceLocation: location)
        #expect(StdlibInt(exactly:            source) == destination, sourceLocation: location)
        #expect(StdlibInt(clamping:           source) == destination, sourceLocation: location)
        #expect(StdlibInt(truncatingIfNeeded: source) == destination, sourceLocation: location)
        #expect(StdlibInt(InfiniInt<IX>(destination)) == destination, sourceLocation: location)
        
        if  T.isSigned == StdlibInt.isSigned, destination.bitWidth <= source.bitWidth {
            #expect(T(                    destination)  == source, sourceLocation: location)
            #expect(T(exactly:            destination)! == source, sourceLocation: location)
            #expect(T(clamping:           destination)  == source, sourceLocation: location)
            #expect(T(truncatingIfNeeded: destination)  == source, sourceLocation: location)
        }
        
        description: do {
            let radix10 = destination.description(as:     .decimal)
            let radix16 = destination.description(as: .hexadecimal)
            
            #expect(radix10 ==      source.description,        sourceLocation: location)
            #expect(radix10 == destination.description,        sourceLocation: location)
            #expect(radix10 == String(destination, radix: 10), sourceLocation: location)
            #expect(radix16 == String(destination, radix: 16), sourceLocation: location)
            
            #expect(    StdlibInt(radix10) ==                   destination, sourceLocation: location)
            #expect(try StdlibInt(radix10, as:     .decimal) == destination, sourceLocation: location)
            #expect(try StdlibInt(radix16, as: .hexadecimal) == destination, sourceLocation: location)
        }
    }
}
