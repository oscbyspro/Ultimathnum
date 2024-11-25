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
// MARK: * Binary Integer x Stdlib x Multiplication
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnMultiplication {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/multiplication: as Swift.BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsFiniteIntegerInteroperable, fuzzers
    )   func asSwiftBinaryInteger(
        type: any FiniteIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteIntegerInteroperable {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< 32 {
                let a = T.entropic(size: size, using: &randomness)
                let b = T.entropic(size: size, using: &randomness)
                let c = a.times(b) as Fallible<T>
                
                if  let c: T = c.optional() {
                    try #require(T(c) == reduce(T(a), *,  T(b)))
                    try #require(T(c) == reduce(T(a), *=, T(b)))
                }   else {
                    try #require(!T.isArbitrary)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger.Stdlib/multiplication: as Swift.FixedWidthInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsSystemsIntegerInteroperable, fuzzers
    )   func asSwiftFixedWidthInteger(
        type: any SystemsIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerInteroperable {
            for _ in 0 ..< 32 {
                let a = T.entropic(using: &randomness)
                let b = T.entropic(using: &randomness)
                let c = a.times(b) as Fallible<T>
                let d = a.multiplication(b) as Doublet<T>
                
                always: do {
                    try #require(T.Stdlib(c.value) == reduce(T.Stdlib(a), &*,  T.Stdlib(b)))
                    try #require(T.Stdlib(c.value) == reduce(T.Stdlib(a), &*=, T.Stdlib(b)))
                }
                
                always: do {
                    let x = T.Stdlib(a).multipliedReportingOverflow(by: T.Stdlib(b))
                    try #require(x == (partialValue: T.Stdlib(c.value), overflow: c.error))
                }
                
                always: do {
                    let x = T.Stdlib(a).multipliedFullWidth(by: T.Stdlib(b))
                    try #require(x == (high: T.Stdlib(d.high), low: T.Stdlib.Magnitude(d.low)))
                }
            }
        }
    }
}
