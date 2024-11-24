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
// MARK: * Double Int x Stdlib x Multiplication
//*============================================================================*

@Suite struct DoubleIntStdlibTestsOnMultiplication {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DoubleInt.Stdlib/multiplication: Self vs Base as Swift.BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func multiplicationAsSwiftBinaryInteger(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< conditional(debug: 64, release: 128) {
                let a = T.Base.entropic(size: size, using: &randomness)
                let b = T.Base.entropic(size: size, using: &randomness)
                let c = a.times(b) as Fallible<T.Base>
                
                if  let c: T.Base = c.optional() {
                    try #require(T(c) == reduce(T(a), *,  T(b)))
                    try #require(T(c) == reduce(T(a), *=, T(b)))
                }   else {
                    try #require(!T.Base.isArbitrary)
                }
            }
        }
    }
    
    @Test(
        "DoubleInt.Stdlib/multiplication: Self vs Base as Swift.FixedWidthInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func multiplicationAsSwiftFixedWidthInteger(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            for _ in 0 ..< conditional(debug: 64, release: 128) {
                let lhs = T.Base.entropic(using: &randomness)
                let rhs = T.Base.entropic(using: &randomness)
                
                always: do {
                    let expectation = lhs.times(rhs) as Fallible<T.Base>
                    let result = T(lhs).multipliedReportingOverflow(by: T(rhs))
                    try #require(result.overflow     ==  (expectation.error))
                    try #require(result.partialValue == T(expectation.value))
                }
                
                always: do {
                    let expectation = lhs.multiplication(rhs) as Doublet<T.Base>
                    let result = T(lhs).multipliedFullWidth(by: T(rhs))
                    try #require(result.high ==           T(expectation.high))
                    try #require(result.low  == T.Magnitude(expectation.low ))
                }
            }
        }
    }
}
