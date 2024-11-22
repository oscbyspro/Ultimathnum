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
// MARK: * Infini Int x Stdlib x Division
//*============================================================================*

@Suite struct InfiniIntStdlibTestsOnDivision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt.Stdlib/division: Self vs Base",
        Tag.List.tags(.forwarding, .random, .todo),
        arguments: fuzzers
    )   func forwarding(
        randomness: consuming FuzzerInt
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
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
}
