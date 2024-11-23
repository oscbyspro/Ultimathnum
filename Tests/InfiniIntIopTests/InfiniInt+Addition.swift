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
import InfiniIntIop
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Infini Int x Stdlib x Addition
//*============================================================================*

@Suite struct InfiniIntStdlibTestsOnAddition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt.Stdlib/addition: -(_:) of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: fuzzers
    )   func negation(
        randomness: consuming FuzzerInt
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: InfiniIntStdlib & Swift.SignedInteger {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< conditional(debug: 64, release: 128) {
                let x = T.Base.entropic(size: size, using: &randomness)
                let y = x.negated() as Fallible<T.Base>
                
                if  let y: T.Base = y.optional() {
                    try #require(T(x) == -T(y))
                    try #require(T(y) == -T(x))
                }   else {
                    try #require(!T.Base.isArbitrary)
                }
            }
        }
    }
    
    @Test(
        "InfiniInt.Stdlib/addition: +(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: fuzzers
    )   func addition(
        randomness: consuming FuzzerInt
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: InfiniIntStdlib {
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
            }
        }
    }
    
    @Test(
        "InfiniInt.Stdlib/addition: -(_:_:) of Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: fuzzers
    )   func subtraction(
        randomness: consuming FuzzerInt
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: InfiniIntStdlib {
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
            }
        }
    }
}
