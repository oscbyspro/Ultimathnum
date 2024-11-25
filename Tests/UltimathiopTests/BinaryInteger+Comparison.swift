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
// MARK: * Binary Integer x Stdlib x Comparison
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnComparison {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/comparison: as Swift.BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsFiniteIntegerInteroperable, fuzzers
    )   func asSwiftBinaryInteger(
        type: any FiniteIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteIntegerInteroperable {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< conditional(debug: 64, release: 128) {
                let x = T.entropic(size: size, using: &randomness)
                
                always: do {
                    let expectation: Swift.Int = switch x.signum() {
                    case Signum.negative: -1
                    case Signum.zero:      0
                    case Signum.positive:  1
                    }
                    
                    try #require(expectation == T.Stdlib(x).signum())
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger.Stdlib/comparison: homogeneous as Swift.BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsFiniteIntegerInteroperable, fuzzers
    )   func homogeneousAsSwiftBinaryInteger(
        type: any FiniteIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteIntegerInteroperable {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< conditional(debug: 64, release: 128) {
                let a = T.entropic(size: size, using: &randomness)
                let b = T.entropic(size: size, using: &randomness)
                let c = a.compared(to: b)
                
                Ɣexpect(T.Stdlib(a), equals: T.Stdlib(b), is: c)
            }
        }
    }
    
    @Test(
        "BinaryInteger.Stdlib/comparison: heterogeneous as Swift.BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: CollectionOfOne(typesAsFiniteIntegerInteroperable), fuzzers
    )   func heterogeneousAsSwiftBinaryInteger(
        list: [any FiniteIntegerInteroperable.Type], randomness: consuming FuzzerInt
    )   throws {
        
        for lhs in list {
            for rhs in list {
                try whereIs(lhs, rhs)
            }
        }
        
        func whereIs<A, B>(_ lhs: A.Type, _ rhs: B.Type)
        throws where A: FiniteIntegerInteroperable, B: FiniteIntegerInteroperable {
            let lhsSize = IX(size: A.self) ?? 256
            let rhsSize = IX(size: B.self) ?? 256
                        
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let a = A.entropic(size: lhsSize, using: &randomness)
                let b = B.entropic(size: rhsSize, using: &randomness)
                let c = a.compared(to: b)
                
                try withOnlyOneCallToRequire((A.self, B.self)) { require in
                    require((A.Stdlib(a) <  B.Stdlib(b)) ==  c.isNegative)
                    require((A.Stdlib(a) >= B.Stdlib(b)) == !c.isNegative)
                    require((A.Stdlib(a) == B.Stdlib(b)) ==  c.isZero)
                    require((A.Stdlib(a) != B.Stdlib(b)) == !c.isZero)
                    require((A.Stdlib(a) >  B.Stdlib(b)) ==  c.isPositive)
                    require((A.Stdlib(a) <= B.Stdlib(b)) == !c.isPositive)
                }
            }
        }
    }
}
