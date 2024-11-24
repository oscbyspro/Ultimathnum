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
// MARK: * Double Int x Stdlib x Addition
//*============================================================================*

@Suite struct DoubleIntStdlibTestsOnAddition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DoubleInt.Stdlib/addition: -(_:) of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: typesAsDoubleIntStdlibAsSignedAsWorkaround, fuzzers
    )   func negation(
        type: AnyDoubleIntStdlibTypeAsSigned, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib & Swift.SignedInteger {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< conditional(debug: 64, release: 128) {
                let x = T.Base.entropic(size: size, using: &randomness)
                let y = x.negated() as Fallible<T.Base>
                
                if  let y: T.Base = y.optional() {
                    try #require(T(x) == -T(y))
                    try #require(T(y) == -T(x))
                    try #require(T(x) == reduce(T(y)) { $0.negate() })
                    try #require(T(y) == reduce(T(x)) { $0.negate() })
                }   else {
                    try #require(!T.Base.isArbitrary)
                }
            }
        }
    }
    
    @Test(
        "DoubleInt.Stdlib/addition: +(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func addition(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< conditional(debug: 64, release: 128) {
                let a = T.Base.entropic(size: size, using: &randomness)
                let b = T.Base.entropic(size: size, using: &randomness)
                let c = a.plus(b) as Fallible<T.Base>
                
                if  let c: T.Base = c.optional() {
                    try #require(T(c) == reduce(T(a), +,  T(b)))
                    try #require(T(c) == reduce(T(a), +=, T(b)))
                }   else {
                    try #require(!T.Base.isArbitrary)
                }
                
                try #require(T(c.value) == T(a).addingReportingOverflow(T(b)).partialValue)
                try #require( (c.error) == T(a).addingReportingOverflow(T(b)).overflow)
            }
        }
    }
    
    @Test(
        "DoubleInt.Stdlib/addition: -(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func subtraction(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< conditional(debug: 64, release: 128) {
                let a = T.Base.entropic(size: size, using: &randomness)
                let b = T.Base.entropic(size: size, using: &randomness)
                let c = a.minus(b) as Fallible<T.Base>
                
                if  let c: T.Base = c.optional() {
                    try #require(T(c) == reduce(T(a), -,  T(b)))
                    try #require(T(c) == reduce(T(a), -=, T(b)))
                }   else {
                    try #require(!T.Base.isArbitrary)
                }
                
                try #require(T(c.value) == T(a).subtractingReportingOverflow(T(b)).partialValue)
                try #require( (c.error) == T(a).subtractingReportingOverflow(T(b)).overflow)
            }
        }
    }
}
