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
// MARK: * Binary Integer x Stdlib x Division
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnDivision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/division: as Swift.BinaryInteger",
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
                let c = a.division(b) as Optional<Fallible<Division<T, T>>>
                
                if  let c: Division<T, T> = c?.optional() {
                    let (q,r) = c.components()
                    try #require(T.Stdlib(q) == reduce(T.Stdlib(a), /,  T.Stdlib(b)))
                    try #require(T.Stdlib(q) == reduce(T.Stdlib(a), /=, T.Stdlib(b)))
                    try #require(T.Stdlib(q) == T.Stdlib(a).quotientAndRemainder(dividingBy: T.Stdlib(b)).quotient)
                    try #require(T.Stdlib(r) == reduce(T.Stdlib(a), %,  T.Stdlib(b)))
                    try #require(T.Stdlib(r) == reduce(T.Stdlib(a), %=, T.Stdlib(b)))
                    try #require(T.Stdlib(r) == T.Stdlib(a).quotientAndRemainder(dividingBy: T.Stdlib(b)).remainder)
                    
                }   else if c != nil {
                    try #require(T.isSigned && !T.isArbitrary)
                    
                }   else {
                    try #require(b.isZero)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger.Stdlib/division: as Swift.FixedWidthInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsSystemsIntegerInteroperable, fuzzers
    )   func asSwiftFixedWidthInteger(
        type: any SystemsIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerInteroperable {
            if  T.isSigned {
                let x = Division(quotient: T.min, remainder: T.zero).veto()
                try whereIs(T.min, by: -1, is: x)
            }
            
            for _ in 0 ..< 32 {
                let x = T.entropic(using: &randomness)
                try whereIs(x, by: T.zero, is: nil)
            }
            
            for _ in 0 ..< 32 {
                let a = T.entropic(using: &randomness)
                let b = T.entropic(using: &randomness)
                try whereIs(a, by: b, is: a.division(b))
            }
            
            for _ in 0 ..< 32 {
                typealias M = T.Magnitude
                let a = M.entropic(using: &randomness)
                let b = T.entropic(using: &randomness)
                let c = T.entropic(using: &randomness)
                guard let divisor = Nonzero(exactly: c) else { continue }
                let dividend = Doublet(low: a, high: b)
                guard let division = T.division(dividend, by: divisor).optional() else { continue }
                let (q, r) = T.Stdlib(c).dividingFullWidth((high: T.Stdlib(b), low: M.Stdlib(a)))
                try #require(q == T.Stdlib(division.quotient ))
                try #require(r == T.Stdlib(division.remainder))
            }
            
            func whereIs(_ a: T, by b: T, is c: Optional<Fallible<Division<T, T>>>) throws {
                let q = T.Stdlib(a)  .dividedReportingOverflow(by:         T.Stdlib(b))
                let r = T.Stdlib(a).remainderReportingOverflow(dividingBy: T.Stdlib(b))
                             
                if  let c = c {
                    try #require(q == (partialValue: T.Stdlib(c.value.quotient ), overflow: c.error))
                    try #require(r == (partialValue: T.Stdlib(c.value.remainder), overflow: c.error))
                    
                }   else {
                    try #require(b.isZero)
                    try #require(q == (partialValue: T.Stdlib(a), overflow: true))
                    try #require(r == (partialValue: T.Stdlib(a), overflow: true))
                }
            }
        }
    }
}
