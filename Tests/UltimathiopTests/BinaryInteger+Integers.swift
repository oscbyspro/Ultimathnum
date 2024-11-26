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
// MARK: * Binary Integer x Stdlib x Integers
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnIntegers {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/integers: as Swift.BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: CollectionOfOne(typesAsFiniteIntegerInteroperable), fuzzers
    )   func asSwiftBinaryInteger(
        list: [any FiniteIntegerInteroperable.Type], randomnesss: consuming FuzzerInt
    )   throws {
        
        for source in list {
            for destination in list {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type)
        throws where A: FiniteIntegerInteroperable, B: FiniteIntegerInteroperable {
            let min: B? = IX(size: B.self).flatMap(B.minLikeSystemsInteger(size:))
            let max: B? = IX(size: B.self).flatMap(B.maxLikeSystemsInteger(size:))
            try withOnlyOneCallToRequire { require in
                
                if  let min, let source = A.exactly(min).optional() {
                    try whereIs((source))
                    
                    if  let below = source.decremented().optional() {
                        try whereIs(below)
                    }
                }
                
                if  let max, let source = A.exactly(max).optional() {
                    try whereIs((source))
                    
                    if  let above = source.incremented().optional() {
                        try whereIs(above)
                    }
                }
                
                for _ in 0 ..< conditional(debug: 8, release: 64) {
                    try whereIs(A.entropic(in:      B.self,   or: 256,  using: &randomnesss))
                    try whereIs(A.entropic(through: Shift.max(or: 255), using: &randomnesss))
                }
                
                func whereIs(_ source: A) throws {
                    let destination: Fallible<B> = B.exactly(source)
                    if  let destination: B = destination.optional() {
                        require(B.Stdlib(destination) == B.Stdlib(A.Stdlib(source)))
                        require(B.Stdlib(destination) == B.Stdlib(exactly:  A.Stdlib(source)))
                        require(B.Stdlib(destination) == B.Stdlib(clamping: A.Stdlib(source)))
                        require(B.Stdlib(destination) == B.Stdlib(truncatingIfNeeded: A.Stdlib(source)))
                    }   else {
                        let clamped = (source.isNegative ? min : max)!
                        require(B.Stdlib(exactly:  A.Stdlib(source)) == nil)
                        require(B.Stdlib(clamping: A.Stdlib(source)) == B.Stdlib(clamped))
                        require(B.Stdlib(truncatingIfNeeded: A.Stdlib(source)) == B.Stdlib(destination.value))
                    }
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger.Stdlib/integers: as Swift.FixedWidthInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsSystemsIntegerInteroperable, fuzzers
    )   func asSwiftFixedWidthInteger(
        type: any SystemsIntegerInteroperable.Type, randomnesss: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerInteroperable {
            for _ in 0 ..< 32 {
                let source = UX.entropic(using: &randomnesss)
                let destination = T(load:  source)
                try #require(T.Stdlib(destination) == T.Stdlib(_truncatingBits:    Swift.UInt(source)))
                try #require(T.Stdlib(destination) == T.Stdlib(truncatingIfNeeded: Swift.UInt(source)))
            }
        }
    }
}
