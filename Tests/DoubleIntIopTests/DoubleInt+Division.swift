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
import DoubleIntIop
import DoubleIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Double Int x Stdlib x Division
//*============================================================================*

@Suite struct DoubleIntStdlibTestsOnDivision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DoubleInt.Stdlib/division: Self vs Base as Swift.BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func divisionAsSwiftBinaryInteger(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< conditional(debug: 64, release: 128) {
                let a = T.Base.entropic(size: size, using: &randomness)
                let b = T.Base.entropic(size: size, using: &randomness)
                let c = a.division(b) as Optional<Fallible<Division<T.Base, T.Base>>>
                
                if  let c:  Division<T.Base, T.Base> = c?.optional() {
                    let (q, r) = c.components()
                    try #require(T(q) == reduce(T(a), /,  T(b)))
                    try #require(T(q) == reduce(T(a), /=, T(b)))
                    try #require(T(q) == T(a).quotientAndRemainder(dividingBy: T(b)).quotient)
                    try #require(T(r) == reduce(T(a), %,  T(b)))
                    try #require(T(r) == reduce(T(a), %=, T(b)))
                    try #require(T(r) == T(a).quotientAndRemainder(dividingBy: T(b)).remainder)
                }   else if c == nil {
                    try #require(b.isZero)
                }   else {
                    try #require(!T.Base.isArbitrary && T.Base.isSigned)
                }
            }
        }
    }
    
    @Test(
        "DoubleInt.Stdlib/division: Self vs Base as Swift.FixedWidthInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func divisionAsSwiftFixedWidthInteger(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            let size = IX(size: T.Base.self) ?? 256
            
            if  T.Base.isSigned {
                let x = Division(quotient: T.Base.min, remainder: T.Base.zero).veto()
                try whereIs(T.Base.min, by: -1, is: x)
            }
            
            for _ in 0 ..< conditional(debug: 64, release: 128) {
                let x = T.Base.entropic(size: size, using: &randomness)
                try whereIs(x, by: T.Base.zero, is: nil)
            }
            
            for _ in 0 ..< conditional(debug: 64, release: 128) {
                let a = T.Base.entropic(size: size, using: &randomness)
                let b = T.Base.entropic(size: size, using: &randomness)
                try whereIs(a, by: b, is: a.division(b))
            }
            
            func whereIs(_ a: T.Base, by b: T.Base, is c: Optional<Fallible<Division<T.Base, T.Base>>>) throws {
                let q = T(a)  .dividedReportingOverflow(by:         T(b))
                let r = T(a).remainderReportingOverflow(dividingBy: T(b))
                             
                if  let c = c {
                    try #require(q == (partialValue: T(c.value.quotient),  overflow: c.error))
                    try #require(r == (partialValue: T(c.value.remainder), overflow:   false))
                    
                }   else {
                    try #require(b.isZero)
                    try #require(q == (partialValue: T(a), overflow: true))
                    try #require(r == (partialValue: T(a), overflow: true))
                }
            }
        }
    }
    
    @Test(
        "DoubleInt.Stdlib/division: dividing full width of Self vs Base (2-by-1)",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func divisionAsSwiftFixedWidthInteger21(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            for _ in 0 ..< conditional(debug: 64, release: 128) {
                let divisor = T.Base.entropic(using: &randomness)
                if  let divisor = Nonzero(exactly: divisor) {
                    let low  = T.Base.Magnitude.entropic(using: &randomness)
                    let high = T.Base.entropic(using: &randomness)
                    let dividend = Doublet(low: low, high: high)
                    let expectation = T.Base.division(dividend, by: divisor)
                    try whereIs(dividend, by: divisor, is: expectation)
                }
            }
            
            func whereIs(_ a: Doublet<T.Base>, by b: Nonzero<T.Base>, is c: Fallible<Division<T.Base, T.Base>>) throws {
                if  let c = c.optional() {
                    let (q, r) = T(b.value).dividingFullWidth((high: T(a.high), low: T.Magnitude(a.low)))
                    try #require(q == T(c.quotient ))
                    try #require(r == T(c.remainder))
                }
            }
        }
    }
}
