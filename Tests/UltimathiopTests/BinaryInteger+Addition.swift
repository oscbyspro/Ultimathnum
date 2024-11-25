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
// MARK: * Binary Integer x Stdlib x Addition
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnAddition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/addition: as Swift.BinaryInteger",
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
                let c = a.plus(b) as Fallible<T>

                if  let c: T = c.optional() {
                    try #require(T.Stdlib(c) == reduce(T.Stdlib(a), +,  T.Stdlib(b)))
                    try #require(T.Stdlib(c) == reduce(T.Stdlib(a), +=, T.Stdlib(b)))
                    try #require(T.Stdlib(a) == reduce(T.Stdlib(c), -,  T.Stdlib(b)))
                    try #require(T.Stdlib(a) == reduce(T.Stdlib(c), -=, T.Stdlib(b)))
                }   else {
                    try #require(!T.isArbitrary)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger.Stdlib/addition: as Swift.FixedWidthInteger",
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
                let c = a.plus(b) as Fallible<T>
                
                always: do {
                    try #require(T.Stdlib(c.value) == reduce(T.Stdlib(a), &+,  T.Stdlib(b)))
                    try #require(T.Stdlib(c.value) == reduce(T.Stdlib(a), &+=, T.Stdlib(b)))
                    try #require(T.Stdlib(a) == reduce(T.Stdlib(c.value), &-,  T.Stdlib(b)))
                    try #require(T.Stdlib(a) == reduce(T.Stdlib(c.value), &-=, T.Stdlib(b)))
                }

                always: do {
                    let x = T.Stdlib(a).addingReportingOverflow(T.Stdlib(b))
                    try #require(x == (partialValue: T.Stdlib(c.value), overflow: c.error))
                }
                
                always: do {
                    let x = T.Stdlib(c.value).subtractingReportingOverflow(T.Stdlib(b))
                    try #require(x == (partialValue: T.Stdlib(a), overflow: c.error))
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger.Stdlib/addition: as Swift.SignedInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsSignedIntegerInteroperable, fuzzers
    )   func asSwiftSignedInteger(
        type: any SignedIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SignedIntegerInteroperable {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< 32 {
                let x = T.entropic(size: size, using: &randomness)
                let y = x.negated() as Fallible<T>
                
                if  let y: T = y.optional() {
                    try #require(T.Stdlib(x) == reduce(T.Stdlib(y)) { -$0          })
                    try #require(T.Stdlib(y) == reduce(T.Stdlib(x)) { -$0          })
                    try #require(T.Stdlib(x) == reduce(T.Stdlib(y)) {  $0.negate() })
                    try #require(T.Stdlib(y) == reduce(T.Stdlib(x)) {  $0.negate() })
                }   else {
                    try #require(!T.isArbitrary)
                }
            }
        }
    }
}
