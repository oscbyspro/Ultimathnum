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
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Stdlib x Shift
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnShift {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/shift: as Swift.BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        .serialized,
        arguments: typesAsFiniteIntegerInteroperable, fuzzers
    )   func asSwiftBinaryInteger(
        type: any FiniteIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        for  distance in typesAsFiniteIntegerInteroperable {
            try whereIs(type, distance: distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, distance: U.Type)
        throws where T: FiniteIntegerInteroperable, U: FiniteIntegerInteroperable {
            let x: IX = T.isArbitrary ? 8 : IX(size: U.self) ?? 256
            
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let value    = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let distance = U.entropic(size: x, as: Domain.natural, using: &randomness)
                                
                let (up) = (value << distance)
                let down = (value >> distance)
                
                try #require(T.Stdlib((up)) == reduce(T.Stdlib(value), <<,  U.Stdlib(distance)))
                try #require(T.Stdlib((up)) == reduce(T.Stdlib(value), <<=, U.Stdlib(distance)))
                try #require(T.Stdlib(down) == reduce(T.Stdlib(value), >>,  U.Stdlib(distance)))
                try #require(T.Stdlib(down) == reduce(T.Stdlib(value), >>=, U.Stdlib(distance)))
            }
        }
    }
    
    @Test(
        "BinaryInteger.Stdlib/shift: as Swift.FixedWidthInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsSystemsIntegerInteroperable, fuzzers
    )   func asSwiftFixedWidthInteger(
        type: any SystemsIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        for  distance in typesAsFiniteIntegerInteroperable {
            try whereIs(type, distance: distance)
        }
        
        func whereIs<T, U>(_ type: T.Type, distance: U.Type)
        throws where T: SystemsIntegerInteroperable, U: FiniteIntegerInteroperable {
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let value    = T.entropic(using: &randomness)
                let distance = U.entropic(through: Shift.max(or: 255), using: &randomness)
                
                always: do {
                    let expectation: T = value &<< distance
                    try #require(T.Stdlib(expectation) == reduce(T.Stdlib(value), &<<,  U.Stdlib(distance)))
                    try #require(T.Stdlib(expectation) == reduce(T.Stdlib(value), &<<=, U.Stdlib(distance)))
                }
                
                always: do {
                    let expectation: T = value &>> distance
                    try #require(T.Stdlib(expectation) == reduce(T.Stdlib(value), &>>,  U.Stdlib(distance)))
                    try #require(T.Stdlib(expectation) == reduce(T.Stdlib(value), &>>=, U.Stdlib(distance)))
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Stdlib x Shift x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnShiftEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/shift/edge-case: about Int.max (↑)",
        Tag.List.tags(.documentation, .generic, .random),
        arguments: typesAsFiniteIntegerInteroperable, fuzzers
    )   func aboutIntMaxUp(
        type: any FiniteIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteIntegerInteroperable {
            always: do {
                try whereIs(T.zero)
            }
            
            if  let size = IX(size: T.self) {
                for _ in 0 ..< 32 {
                    try whereIs(T.entropic(size: size, using: &randomness))
                }
            }
            
            func whereIs(_ value: T) throws {
                let expectation = T(repeating: Bit.zero)
                try #require(T.Stdlib(expectation) == (T.Stdlib(value) >>  Swift.Int.min))
                try #require(T.Stdlib(expectation) == (T.Stdlib(value) >> -Swift.Int.max))
                try #require(T.Stdlib(expectation) == (T.Stdlib(value) <<  Swift.Int.max))
                try #require(T.Stdlib(expectation) == (T.Stdlib(value) <<  Swift.Int.min.magnitude))
            }
        }
    }
    
    @Test(
        "BinaryInteger.Stdlib/shift/edge-cases: about Int.max (↓)",
        Tag.List.tags(.documentation, .generic, .random),
        arguments: typesAsFiniteIntegerInteroperable, fuzzers
    )   func aboutIntMaxDown(
        type: any FiniteIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteIntegerInteroperable {
            always: do {
                try whereIs(T(repeating: Bit.one ))
                try whereIs(T(repeating: Bit.zero))
            }
            
            for _ in 0 ..< 32 {
                try whereIs(T.entropic(through: Shift.max(or: 255), using: &randomness))
            }


            func whereIs(_ value: T) throws {
                let expectation = T(repeating: value.appendix)
                try #require(T.Stdlib(expectation) == (T.Stdlib(value) <<  Swift.Int.min))
                try #require(T.Stdlib(expectation) == (T.Stdlib(value) << -Swift.Int.max))
                try #require(T.Stdlib(expectation) == (T.Stdlib(value) >>  Swift.Int.max))
                try #require(T.Stdlib(expectation) == (T.Stdlib(value) >>  Swift.Int.min.magnitude))
            }
        }
    }
}
