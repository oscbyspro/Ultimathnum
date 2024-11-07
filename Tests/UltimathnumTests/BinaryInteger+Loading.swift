//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Loading
//*============================================================================*

@Suite struct BinaryIntegerTestsOnLoading {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// Loads random bit patterns consisting of `3` parts.
    ///
    ///     format: [payload][extension][junk]
    ///
    /// - Note: The `payload` content and size is random.
    ///
    /// - Note: The `junk` part starts at the end of the type's body.
    ///
    @Test(
        "BinaryInteger/loading: random payload-extension-junk",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func randomPayloadExtensionJunk(
        type: any BinaryInteger.Type,
        randomness: consuming FuzzerInt
    )   throws {
        
        for element in typesAsSystemsIntegerAsUnsigned {
            try whereIs(type, element: element)
        }
        
        func whereIs<T, E>(_ type: T.Type, element: E.Type)
        throws where T: BinaryInteger, E: SystemsIntegerAsUnsigned {
            let size = IX(size: T.self) ?? 256
            let capacity = Swift.Int(size / IX(size: E.self))
            var body = Array(repeating: E.zero, count: 2 * Swift.max(2, capacity))
            
            for _ in 0 ..< conditional(debug: 32, release: 64) {
                let end = (0000...capacity).randomElement(using: &randomness.stdlib)!
                let appendix = T.appendices.randomElement(using: &randomness.stdlib)!
                
                try body.withUnsafeMutableBufferPointer {
                    for index in $0.indices {
                        $0[index] = E.random(using: &randomness)
                    }
                    
                    $0[end..<capacity].initialize(repeating: E(repeating: appendix))
                    
                    if  T.size < E.size {
                        try #require($0.isEmpty == false)
                        try #require(IX(capacity).isZero)
                        $0[Swift.Int.zero]  = $0[Swift.Int.zero].up(T.size)
                        $0[Swift.Int.zero] ^= E(repeating: appendix)
                    }
                    
                    if  T.isCompact, !IX(capacity).isZero {
                        $0[capacity - 1][Shift.max] = appendix
                    }
                }
                
                let instance = T(load: body[..<capacity], repeating: appendix)
                try Ɣrequire(instance, matches: body[..<capacity], repeating: appendix)
                
                end: do {
                    let other = body[..<end].withUnsafeBinaryIntegerBody {
                        T(load: DataInt($0, repeating: appendix))
                    }
                    
                    try #require(other  == instance)
                    try Ɣrequire(other, matches: body[..<capacity], repeating: appendix)
                }
                
                max: if !T.isArbitrary {
                    let other = body.withUnsafeBinaryIntegerBody {
                        T(load: DataInt($0, repeating: appendix))
                    }
                    
                    try #require(other  == instance)
                    try Ɣrequire(other, matches: body[..<capacity], repeating: appendix)
                }
                
                always: do {
                    let other = instance.withUnsafeBinaryIntegerElements {
                        T(load: $0)
                    }
                    
                    try #require(other  == instance)
                    try Ɣrequire(other, matches: body[..<capacity], repeating: appendix)
                }
                
                always: do {
                    let other = instance.withUnsafeBinaryIntegerElements(as: U8.self) {
                        T(load: $0)
                    }
                    
                    try #require(other  == instance)
                    try Ɣrequire(other, matches: body[..<capacity], repeating: appendix)
                }
                
                always: do {
                    let opaque: some BinaryInteger = instance
                    let other = T(load: opaque)
                    
                    try #require(other  == instance)
                    try Ɣrequire(other, matches: body[..<capacity], repeating: appendix)
                }
            }
        }
    }
    
    func Ɣrequire<Integer, Body>(
        _ integer: Integer,
        matches body: Body,
        repeating appendix: Bit
    )   throws where Integer: BinaryInteger, Body: Contiguous, Body.Element: SystemsIntegerAsUnsigned {
        try withOnlyOneCallToRequire((integer, body)) { require in
            integer.withUnsafeBinaryIntegerElements(as: U8.self) { integer in
                require(integer.appendix == appendix)
                body.withUnsafeBufferPointer { body in
                    body.withMemoryRebound(to: U8.self) { body in
                        for index in body.indices {
                            require(integer[UX(IX(index))] == body[index])
                        }
                    }
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Loading x Conveniences
//*============================================================================*

@Suite struct BinaryIntegerTestsOnLoadingConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("BinaryInteger/loading/conveniences: default appendix is zero")
    func defaultAppendixIsZero() {
        #expect(IX(load: [] as [U8]) == IX.zero)
        #expect(UX(load: [] as [U8]) == UX.zero)
    }
}

//*============================================================================*
// MARK: * Binary Integer x Loading x Disambiguation
//*============================================================================*

@Suite(.tags(.disambiguation)) struct BinaryIntegerTestsOnLoadingDisambiguation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/loading/disambiguation: { IX, UX } from T where T.Element is { IX, UX }"
    )   func tokenFromBinaryIntegerWhereElementIsToken() {
        
        let ix = IX.random()
        let ux = UX.random()
        
        #expect(IX(load: InfiniInt<IX>(load: ix)) == ix)
        #expect(IX(load: InfiniInt<UX>(load: ix)) == ix)
        #expect(UX(load: InfiniInt<IX>(load: ux)) == ux)
        #expect(UX(load: InfiniInt<UX>(load: ux)) == ux)
        
        #expect(IX(load: DoubleInt<IX>(load: ix)) == ix)
        #expect(IX(load: DoubleInt<UX>(load: ix)) == ix)
        #expect(UX(load: DoubleInt<IX>(load: ux)) == ux)
        #expect(UX(load: DoubleInt<UX>(load: ux)) == ux)
    }
}
