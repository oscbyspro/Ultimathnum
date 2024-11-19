//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Complement
//*============================================================================*

@Suite struct BinaryIntegerTestsOnComplement {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/complement: magnitude",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func magnitude(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..<  conditional(debug:  256, release: 1024) {
                let value = T.entropic(through: Shift.max(or: 255), using: &randomness)
                if  value.isNegative {
                    try #require(value.magnitude() == T.Magnitude(raw: value.complement()))
                }   else {
                    try #require(value.magnitude() == T.Magnitude(raw: value))
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/complement: complement vs toggle-increment",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func complementVersusToggleIncrement(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..<  conditional(debug:  256, release: 1024) {
                let value = T.entropic(through: Shift.max(or: 255), using: &randomness)
                for increment in Bool.all {
                    let result = value.complement(increment)
                    let expectation = value.toggled().incremented(increment)
                    try #require(result == expectation)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/complement: complement is reversible",
        Tag.List.tags(.documentation, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func complementIsReversible(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..<  conditional(debug:  256, release: 1024) {
                let value = T.entropic(through: Shift.max(or: 255), using: &randomness)
                for increment in Bool.all {
                    let (complement, error) = value.complement(increment).components()
                    try #require(complement.toggled().incremented(increment) == value.veto(error))
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/complement: complement is well-behaved",
        Tag.List.tags(.documentation, .generic),
        arguments: typesAsBinaryInteger
    )   func complementIsWellBehaved(type: any BinaryInteger.Type) throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let usmol: Bool = !T.isSigned && T.size == T.Element.size
            
            #expect(z([      ]).complement(false) == o([      ]).veto(false))
            #expect(z([      ]).complement(true ) == z([      ]).veto(!T.isSigned))
            
            #expect(z([~0    ]).complement(false) == o([ 0    ]).veto(false))
            #expect(z([~0    ]).complement(true ) == o([ 1    ]).veto(false))
            #expect(o([ 1    ]).complement(false) == z([~1    ]).veto(false))
            #expect(o([ 1    ]).complement(true ) == z([~0    ]).veto(false))
            
            #expect(o([ 0    ]).complement(false) == z([~0    ]).veto(false))
            #expect(o([ 0    ]).complement(true ) == z([ 0,  1]).veto(usmol))
            #expect(z([ 0,  1]).complement(false) == o([~0, ~1]).veto(false))
            #expect(z([ 0,  1]).complement(true ) == o([ 0    ]).veto(usmol))
            
            func z(_ body: [T.Element.Magnitude]) -> T {
                T(load: body, repeating: Bit.zero)
            }
            
            func o(_ body: [T.Element.Magnitude]) -> T {
                T(load: body, repeating: Bit.one)
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Complement x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerTestsOnComplementEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// Checks the following invariants for all edgy integers:
    ///
    ///     T.zero.complement(false) == T.zero.toggled()
    ///     T.zero.complement(true ) == T.zero.veto(!T.isSigned)
    ///
    /// - Note: `T.min.complement(true)` is the only `error` case.
    ///
    @Test(
        "BinaryInteger/complement/edge-cases: min and max",
        Tag.List.tags(.documentation, .exhaustive, .generic),
        arguments: typesAsBinaryInteger
    )   func complementOfZero(type: any BinaryInteger.Type) throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            #expect(T.zero.complement(false) == T.zero.toggled().veto(false))
            #expect(T.zero.complement(true ) == T.zero.veto(((!T.isSigned))))
        }
    }
    
    /// Checks the following invariants for all edgy integers:
    ///
    ///     T.min.complement(false) == T.max
    ///     T.min.complement(true ) == T.min.veto() // (!)
    ///     T.max.complement(false) == T.min
    ///     T.max.complement(true ) == T.min.incremented()
    ///
    /// - Note: `T.min.complement(true)` is the only `error` case.
    ///
    @Test(
        "BinaryInteger/complement/edge-cases: min and max",
        Tag.List.tags(.documentation, .exhaustive, .generic),
        arguments: typesAsEdgyInteger
    )   func complementOfEdges(type: any EdgyInteger.Type) throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: EdgyInteger {
            #expect(T.min.complement(false) == T.max.veto(false))
            #expect(T.min.complement(true ) == T.min.veto(true ))
            #expect(T.max.complement(false) == T.min.veto(false))
            #expect(T.max.complement(true ) == T.min.incremented())
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Complement x Conveniences
//*============================================================================*

@Suite struct BinaryIntegerTestsOnComplementConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/complement/conveniences: complement() vs complement(_:)",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func complementVersusComplementWithIncrement(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let value = T.entropic(through: Shift.max(or: 255), using: &randomness)
                try #require(value.complement() == value.complement(true).value)
            }
        }
    }
}
