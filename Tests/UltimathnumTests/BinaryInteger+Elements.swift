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
import TestKit2

//*============================================================================*
// MARK: * Binary Integer x Elements
//*============================================================================*

@Suite struct BinaryIntegerTestsOnElements {
        
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
        "BinaryInteger/elements: loading random bits",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func loadingRandomBits(
        type: any BinaryInteger.Type,
        randomness: consuming FuzzerInt
    )   throws {
        #warning("typesAsSystemsIntegerAsUnsigned")
        for element in typesAsCoreIntegersAsUnsigned {
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
            
            func Ɣrequire(_ instance: T, matches body: ArraySlice<E>, repeating appendix: Bit) throws {
                try withOnlyOneCallToRequire((instance, body)) { require in
                    instance.withUnsafeBinaryIntegerElements(as: U8.self) { instance in
                        require(instance.appendix == appendix)
                        body.withUnsafeBytes { body in
                            for index: Swift.Int in body.indices {
                                let lhs = instance[UX(IX(index))]
                                let rhs = body.load(fromByteOffset: index, as: U8.self)
                                require(lhs == rhs)
                            }
                        }
                    }
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Elements x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerTestsOnElementsEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Systems or Arbitrary
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/elements/edge-cases: systems(...) is like init(load:) or nil",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func systemsIsLikeInitLoadOrNil(
        type: any BinaryInteger.Type,
        randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size   = IX(size: T.self) ?? 256
            let count  = size /  IX(size: T.Element.Magnitude.self)
            var source = Array(repeating: T.Element.Magnitude.zero, count: Swift.Int(count))
            try source.withUnsafeMutableBinaryIntegerBody { source in
                for _ in 0 ..< 32 {
                    randomness.fill(source)
                    
                    let result: Optional<T> = T.systems {
                        $0.initialize(to: DataInt.Body(source))
                    }
                    
                    if  T.isArbitrary {
                        try #require(result == nil)
                    }   else {
                        try #require(result == T(load: DataInt(source)))
                    }
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/elements/edge-cases: arbitrary(...) is like init(load:) or nil",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func arbitraryIsLikeInitLoadOrNil(
        type: any BinaryInteger.Type,
        randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            var source = Array(repeating: T.Element.Magnitude.zero, count: 4)
            try source.withUnsafeMutableBinaryIntegerBody { source in
                for _ in 0 ..< 32 {
                    randomness.fill(source)
                    let length = IX.random(in: IX.zero...source.count, using: &randomness)
                    let prefix = DataInt.Body(source[unchecked: ..<length])
                    
                    always: do {
                        let result = T.arbitrary(uninitialized: prefix.count) {
                            $0.initialize(to: prefix)
                        }
                        
                        if  T.isArbitrary {
                            try #require(result == T(load: DataInt(prefix)))
                        }   else {
                            try #require(result == nil)
                        }
                    }
                    
                    always: do {
                        let result = T.arbitrary(uninitialized: source.count) {
                            $0[unchecked: ..<prefix.count].initialize(to: prefix)
                            return prefix.count as IX
                        }
                        
                        if  T.isArbitrary {
                            try #require(result == T(load: DataInt(prefix)))
                        }   else {
                            try #require(result == nil)
                        }
                    }
                    
                    for bit in Bit.all {
                        let result = T.arbitrary(uninitialized: prefix.count, repeating: bit) {
                            $0.initialize(to: prefix)
                        }
                        
                        if  T.isArbitrary {
                            try #require(result == T(load: DataInt(prefix, repeating: bit)))
                        }   else {
                            try #require(result == nil)
                        }
                    }
                    
                    for bit in Bit.all {
                        let result = T.arbitrary(uninitialized: source.count, repeating: bit) {
                            $0[unchecked: ..<prefix.count].initialize(to: prefix)
                            return prefix.count as IX
                        }
                        
                        if  T.isArbitrary {
                            try #require(result == T(load: DataInt(prefix, repeating: bit)))
                        }   else {
                            try #require(result == nil)
                        }
                    }
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/elements/edge-cases: arbitrary(...) where count is invalid is nil",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func arbitraryWhereCountIsInvalidIsNil(
        type: any BinaryInteger.Type,
        randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let capacity: IX = DataInt<T.Element.Magnitude>.capacity
            
            for _ in 0 ..< 32 {
                try whereIs(count: IX.random(in: capacity...IX.max, using: &randomness))
                try whereIs(count: IX.random(in: IX.min..<00000000, using: &randomness)!)
            }
            
            func whereIs(count: IX) throws {
                always: do {
                    try #require(nil == T.arbitrary(uninitialized: count) { _ in IX.zero })
                    try #require(nil == T.arbitrary(uninitialized: count) { _ in Void( ) })
                }
                
                for bit in Bit.all {
                    try #require(nil == T.arbitrary(uninitialized: count, repeating: bit) { _ in IX.zero })
                    try #require(nil == T.arbitrary(uninitialized: count, repeating: bit) { _ in Void( ) })
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Elements x Disambiguation
//*============================================================================*

@Suite(.tags(.disambiguation)) struct BinaryIntegerTestsOnElementsDisambiguation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/elements/disambiguation: loading T where T.Element is token as token"
    )   func loadingBinaryIntegerWhereElementIsTokenAsToken() {
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
