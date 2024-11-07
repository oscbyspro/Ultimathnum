//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Stride
//*============================================================================*

@Suite struct BinaryIntegerTestsOnStride {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/stride: advanced(by:) vs ArbitraryInteger.±(_:_:)",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func advancedByVersusArbitraryInteger(randomness: consuming FuzzerInt) throws {
        for type in typesAsBinaryInteger {
            for distance in typesAsBinaryIntegerAsSigned {
                try whereIs(type: type, distance: distance)
            }
        }
        
        func whereIs<A, B>(type: A.Type, distance: B.Type) throws where A: BinaryInteger, B: SignedInteger {
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let start    = A.entropic(through: Shift.max(or: 255), using: &randomness)
                let distance = B.entropic(through: Shift.max(or: 255), using: &randomness)
                let end      = start.advanced(by: distance) as Fallible<A>
                
                if !start.isInfinite {
                    try #require(end == A.exactly(IXL(start) + IXL(distance)))
                    
                }   else if !distance.isNegative {
                    try #require(end == UXL(start).plus (UXL(distance.magnitude())).map(A.exactly))
                    
                }   else {
                    try #require(end == UXL(start).minus(UXL(distance.magnitude())).map(A.exactly))
                    try #require(end.error == false)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/stride: distance(to:) vs ArbitraryInteger.±(_:_:)",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func distanceToVersusArbitraryInteger(randomness: consuming FuzzerInt) throws {
        for type in typesAsBinaryInteger {
            for distance in typesAsBinaryIntegerAsSigned {
                try whereIs(type: type, distance: distance)
            }
        }
        
        func whereIs<A, B>(type: A.Type, distance: B.Type) throws where A: BinaryInteger, B: SignedInteger {
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let start    = A.entropic(through: Shift.max(or: 255), using: &randomness)
                let end      = A.entropic(through: Shift.max(or: 255), using: &randomness)
                let distance = start.distance(to: end) as Fallible<B>
                
                if !start.isInfinite, !end.isInfinite {
                    try #require(distance == B.exactly(IXL(end) - IXL(start)))
                    
                }   else if start <= end {
                    try #require(distance == B.exactly(sign: Sign.plus,  magnitude: UXL(end - start)))
                    
                }   else {
                    try #require(distance == B.exactly(sign: Sign.minus, magnitude: UXL(start - end)))
                }
            }
        }
    }
}
