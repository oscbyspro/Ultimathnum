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
import TestKit2

//*============================================================================*
// MARK: * Binary Integer x Floats x Samples
//*============================================================================*

@Suite(.serialized, .tags(.generic)) struct BinaryIntegerTestsOnFloatsSamples {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let naturals: [(Float64, IXL)] = [
        
        (Float64(         0.0), IXL(0)),
        (Float64(         1.0), IXL(1)),
        (Float64(         2.0), IXL(2)),
        (Float64(         3.0), IXL(3)),
        (Float64(         4.0), IXL(4)),
        (Float64(         5.0), IXL(5)),
        (Float64(         6.0), IXL(6)),
        (Float64(         7.0), IXL(7)),
        (Float64(         8.0), IXL(8)),
        (Float64(         9.0), IXL(9)),
        
        (Float64(       127.0), IXL(I8 .max)),
        (Float64(       128.0), IXL(U8 .msb)),
        (Float64(       255.0), IXL(U8 .max)),
        (Float64(     32767.0), IXL(I16.max)),
        (Float64(     32768.0), IXL(U16.msb)),
        (Float64(     65535.0), IXL(U16.max)),
        (Float64(2147483647.0), IXL(I32.max)),
        (Float64(2147483648.0), IXL(U32.msb)),
        (Float64(4294967295.0), IXL(U32.max)),
        
        (Float64(         1.0), IXL(         1)),
        (Float64(        12.0), IXL(        12)),
        (Float64(       123.0), IXL(       123)),
        (Float64(      1234.0), IXL(      1234)),
        (Float64(     12345.0), IXL(     12345)),
        (Float64(    123456.0), IXL(    123456)),
        (Float64(   1234567.0), IXL(   1234567)),
        (Float64(  12345678.0), IXL(  12345678)),
        (Float64( 123456789.0), IXL( 123456789)),
        (Float64(1234567890.0), IXL(1234567890)),
        
        (Float64(Float32.greatestFiniteMagnitude), IXL("""
        0000000000000000000000000340282346638528859811704183484516925440
        """)!),
         
        (Float64(Float64.greatestFiniteMagnitude), IXL("""
        0000000000017976931348623157081452742373170435679807056752584499\
        6598917476803157260780028538760589558632766878171540458953514382\
        4642343213268894641827684675467035375169860499105765512820762454\
        9009038932894407586850845513394230458323690322294816580855933212\
        3348274797826204144723168738177180919299881250404026184124858368
        """)!),
        
    ]
    
    static let integers: [(Float64, IXL)] = {
        Self.naturals +
        Self.naturals.map({( -$0.0, -$0.1 )})
    }()
    
    static let integersButOneFractionalStepAwayFromZero: [(Float64, Fallible<IXL>)] = Self.integers.compactMap { a, b in
        if  a.ulp >= 1 {
            return nil
        }   else if b.isNegative {
            return (a - a.ulp, b.veto())
        }   else {
            return (a + a.ulp, b.veto())
        }
    }
    
    static let integersButOneFractionalStepTowardsZero: [(Float64, Fallible<IXL>)] = Self.integers.compactMap { a, b in
        if  b.isZero {
            return nil
        }   else if a.ulp >= 1 {
            return nil
        }   else if b.isNegative {
            return (a + a.ulp, b.incremented().veto())
        }   else {
            return (a - a.ulp, b.decremented().veto())
        }
    }
    
    static let nonresults: [Float64] = {
        var result = [Float64]()
        
        result.append( Float64.infinity)
        result.append(-Float64.infinity)
        
        for nan: UInt64 in 0..<2 {
            for signaling: Bool in Bool.all {
                result.append( Float64(nan: nan, signaling: signaling))
                result.append(-Float64(nan: nan, signaling: signaling))
            }
        }
        
        return result
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/floats/samples: none",
        arguments: Self.nonresults
    )   func nonresults(float: Float64) throws {
        for source in typesAsSwiftBinaryFloatingPoint {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: Swift.BinaryFloatingPoint, B: BinaryInteger {
            if  let source = A(exactly: float) {
                try Ɣrequire(source,is: Optional<Fallible<B>>.none)
            }
        }
    }
    
    @Test(
        "BinaryInteger/floats/samples: integers",
        arguments: Self.integers
    )   func integers(float: Float64, integer: IXL) throws {
        for source in typesAsSwiftBinaryFloatingPoint {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: Swift.BinaryFloatingPoint, B: BinaryInteger {
            if  let source = A(exactly: float) {
                try Ɣrequire(source,is: integer.veto(false), as: B.self)
            }
        }
    }
    
    @Test(
        "BinaryInteger/floats/samples: integers but one fractional step away from zero",
        arguments: Self.integersButOneFractionalStepAwayFromZero
    )   func integersButOneFractionalStepAwayFromZero(float: Float64, integer: Fallible<IXL>) throws {
        for source in typesAsSwiftBinaryFloatingPoint {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: Swift.BinaryFloatingPoint, B: BinaryInteger {
            if  let source = A(exactly: float) {
                try Ɣrequire(source,is: integer, as: B.self)
            }
        }
    }
    
    @Test(
        "BinaryInteger/floats/samples: integers but one fractional step towards zero",
        arguments: Self.integersButOneFractionalStepTowardsZero
    )   func integersButOneFractionalStepTowardsZero(float: Float64, integer: Fallible<IXL>) throws {
        for source in typesAsSwiftBinaryFloatingPoint {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: Swift.BinaryFloatingPoint, B: BinaryInteger {
            if  let source = A(exactly: float) {
                try Ɣrequire(source,is: integer, as: B.self)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private func Ɣrequire<A, B>(
        _ source: A,
        is destination: Fallible<IXL>,
        as type: B.Type,
        at location: SourceLocation = #_sourceLocation
    )   throws where A: Swift.BinaryFloatingPoint, B: BinaryInteger {
        
        let expectation: B?  = B.exactly(destination.value).optional()
        try Ɣrequire(source, is: expectation?.veto(destination.error))
    }
    
    private func Ɣrequire<A, B>(
        _ source: A,
        is destination: Optional<Fallible<B>>,
        at location: SourceLocation = #_sourceLocation
    )   throws where A: Swift.BinaryFloatingPoint, B: BinaryInteger {
        
        if  let destination {
            try #require(B.init     (source) == destination.value,      sourceLocation: location)
            try #require(B.exactly  (source) == destination.optional(), sourceLocation: location)
            try #require(B.leniently(source) == destination,            sourceLocation: location)
        }   else {
            try #require(B.exactly  (source) == nil, sourceLocation: location)
            try #require(B.leniently(source) == nil, sourceLocation: location)
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Floats x Generators
//*============================================================================*

@Suite struct BinaryIntegerTestsOnFloatsGenerators {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    @Test func fromPureExponentFloats() throws {
        for source in typesAsSwiftBinaryFloatingPoint {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: Swift.BinaryFloatingPoint, B: BinaryInteger {
            try withOnlyOneCallToRequire((source, destination)) { require in
                let size = IX(size: B.self) ?? 128
                
                for exponent: IX in -(2 * size) ..< (2 * size) {
                    let positive = Double(sign: .plus,  exponent: Int(exponent), significand: 1)
                    let negative = Double(sign: .minus, exponent: Int(exponent), significand: 1)
                    
                    if  exponent.isNegative {
                        require(B.leniently(positive) == B.zero.veto())
                        require(B.leniently(negative) == B.zero.veto())
                        
                    }   else if let distance = Shift<B.Magnitude>(exactly: Count(exponent)) {
                        let magnitude = B.Magnitude.lsb.up(distance)
                        require(B.exactly  (positive) == B.exactly(sign: Sign.plus,  magnitude: magnitude).optional())
                        require(B.exactly  (negative) == B.exactly(sign: Sign.minus, magnitude: magnitude).optional())
                        
                    }   else {
                        require(B.leniently(positive) == nil)
                        require(B.leniently(negative) == nil)
                    }
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Arbitrary
    //=------------------------------------------------------------------------=
    
    /// Checks some bit patterns for exponents >= 52 (64-bit).
    ///
    ///     1000000000000000000000000000000000000000000000000000110011000011 →
    ///     1100000000000000000000000000000000000000000000000000110011000011 →
    ///     1110000000000000000000000000000000000000000000000000110011000011 →
    ///     1111000000000000000000000000000000000000000000000000110011000011 →
    ///
    ///     1111111111111111111111111111111111111111111111111000110011000011 →
    ///     1111111111111111111111111111111111111111111111111100110011000011 →
    ///     1111111111111111111111111111111111111111111111111110110011000011 →
    ///     1111111111111111111111111111111111111111111111111111110011000011 →
    ///
    @Test func fromLargeNegativeFloats() throws {
        for source in typesAsSwiftBinaryFloatingPoint {
            try whereIs(source: source, destination: InfiniInt<IX>.self)
            try whereIs(source: source, destination: InfiniInt<UX>.self)
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: Swift.BinaryFloatingPoint, B: ArbitraryInteger {
            //=----------------------------------=
            let start = A.significandBitCount
            let end   = A.significandBitCount + 32
            let steps = A.significandBitCount
            //=----------------------------------=
            for exponent in start ..< end {
                try withOnlyOneCallToRequire((source, destination)) { require in
                    var source = A.init(
                        sign: FloatingPointSign.minus,
                        exponent: A.Exponent(exponent),
                        significand: 1.0 as A
                    )
                    
                    var sourceStep: A = source.ulp
                    var destination = B.isSigned ? B(-1) << IX(exponent) : nil
                    var destinationStep = B.exactly(sourceStep)!
                    
                    for _ in 0 ..< steps {
                        source          -= sourceStep
                        sourceStep      += sourceStep
                        destination?    -= destinationStep
                        destinationStep += destinationStep
                        require(destination == B.exactly(source))
                    }
                }
            }
        }
    }
    
    /// Checks some bit patterns for exponents >= 52 (64-bit).
    ///
    ///     0000000000000000000000000000000000000000000000000000110011000011 →
    ///     1000000000000000000000000000000000000000000000000000110011000011 →
    ///     0100000000000000000000000000000000000000000000000000110011000011 →
    ///     1100000000000000000000000000000000000000000000000000110011000011 →
    ///
    ///     0010000000000000000000000000000000000000000000000000110011000011 →
    ///     1010000000000000000000000000000000000000000000000000110011000011 →
    ///     0110000000000000000000000000000000000000000000000000110011000011 →
    ///     1110000000000000000000000000000000000000000000000000110011000011 →
    ///
    @Test func fromLargeNegativeFloatsNearMinSignificandBitPattern() throws {
        for source in typesAsSwiftBinaryFloatingPoint {
            try whereIs(source: source, destination: InfiniInt<IX>.self)
            try whereIs(source: source, destination: InfiniInt<UX>.self)
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: Swift.BinaryFloatingPoint, B: ArbitraryInteger {
            //=----------------------------------=
            let start = A.significandBitCount
            let end   = A.significandBitCount + 32
            let steps = 32
            try #require(1 == A(sign: .minus, exponent: A.Exponent(start), significand: 1).ulp)
            //=----------------------------------=
            for exponent in start ..< end {
                try withOnlyOneCallToRequire((source, destination)) { require in
                    var source = A.init(
                        sign: FloatingPointSign.minus,
                        exponent: A.Exponent(exponent),
                        significand: 1.0 as A
                    )
                    
                    let sourceStep: A = source.ulp
                    var destination = B.isSigned ? B(-1) << IX(exponent) : nil
                    let destinationStep = B.exactly(sourceStep)!
                    
                    for _ in 0 ..< steps {
                        require(destination == B.exactly(source))
                        source -= sourceStep
                        destination? -= destinationStep
                    }
                }
            }
        }
    }
    
    /// Checks some bit patterns for exponents >= 52 (64-bit).
    ///
    ///     1111111111111111111111111111111111111111111111111111110011000011 →
    ///     0111111111111111111111111111111111111111111111111111110011000011 →
    ///     1011111111111111111111111111111111111111111111111111110011000011 →
    ///     0011111111111111111111111111111111111111111111111111110011000011 →
    ///
    ///     1101111111111111111111111111111111111111111111111111110011000011 →
    ///     0101111111111111111111111111111111111111111111111111110011000011 →
    ///     1001111111111111111111111111111111111111111111111111110011000011 →
    ///     0001111111111111111111111111111111111111111111111111110011000011 →
    ///
    @Test func fromLargeNegativeFloatsNearMaxSignificandBitPattern() throws {
        for source in typesAsSwiftBinaryFloatingPoint {
            try whereIs(source: source, destination: InfiniInt<IX>.self)
            try whereIs(source: source, destination: InfiniInt<UX>.self)
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: Swift.BinaryFloatingPoint, B: ArbitraryInteger {
            //=----------------------------------=
            let start = A.significandBitCount + 1
            let end   = A.significandBitCount + 1 + 32
            let steps = 32
            try #require(2 == A(sign: .minus, exponent: A.Exponent(start), significand: 1).ulp)
            try #require(1 == A(sign: .minus, exponent: A.Exponent(start), significand: 1).nextUp.ulp)
            //=----------------------------------=
            for exponent in start ..< end {
                try withOnlyOneCallToRequire((source, destination)) { require in
                    var source = A.init(
                        sign: FloatingPointSign.minus,
                        exponent: A.Exponent(exponent),
                        significand: 1.0 as A
                    )
                    
                    let sourceStep: A = source.nextUp.ulp
                    var destination = B.isSigned ? B(-1) << IX(exponent) : nil
                    let destinationStep = B.exactly(sourceStep)!
                    
                    for _ in 0 ..< steps {
                        source += sourceStep
                        destination? += destinationStep
                        require(destination == B.exactly(source))
                    }
                }
            }
        }
    }
    
    /// Checks some bit patterns for exponents >= 52 (64-bit).
    ///
    ///     1000000000000000000000000000000000000000000000000000110011000010 →
    ///     1100000000000000000000000000000000000000000000000000110011000010 →
    ///     1110000000000000000000000000000000000000000000000000110011000010 →
    ///     1111000000000000000000000000000000000000000000000000110011000010 →
    ///
    ///     1111111111111111111111111111111111111111111111111000110011000010 →
    ///     1111111111111111111111111111111111111111111111111100110011000010 →
    ///     1111111111111111111111111111111111111111111111111110110011000010 →
    ///     1111111111111111111111111111111111111111111111111111110011000010 →
    ///
    @Test func fromLargePositiveFloats() throws {
        for source in typesAsSwiftBinaryFloatingPoint {
            try whereIs(source: source, destination: InfiniInt<IX>.self)
            try whereIs(source: source, destination: InfiniInt<UX>.self)
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: Swift.BinaryFloatingPoint, B: ArbitraryInteger {
            //=----------------------------------=
            let start = A.significandBitCount
            let end   = A.significandBitCount + 32
            let steps = A.significandBitCount
            //=----------------------------------=
            for exponent in start ..< end {
                try withOnlyOneCallToRequire((source, destination)) { require in
                    var source = A.init(
                        sign: FloatingPointSign.plus,
                        exponent: A.Exponent(exponent),
                        significand: 1.0 as A
                    )
                    
                    var sourceStep: A = source.ulp
                    var destination = B.lsb << IX(exponent)
                    var destinationStep = B.exactly(sourceStep)!
                    
                    for _ in 0 ..< steps {
                        source          += sourceStep
                        sourceStep      += sourceStep
                        destination     += destinationStep
                        destinationStep += destinationStep
                        require(destination == B.exactly(source))
                    }
                }
            }
        }
    }
    
    /// Checks some bit patterns for exponents >= 52 (64-bit).
    ///
    ///     0000000000000000000000000000000000000000000000000000110011000010 →
    ///     1000000000000000000000000000000000000000000000000000110011000010 →
    ///     0100000000000000000000000000000000000000000000000000110011000010 →
    ///     1100000000000000000000000000000000000000000000000000110011000010 →
    ///
    ///     0010000000000000000000000000000000000000000000000000110011000010 →
    ///     1010000000000000000000000000000000000000000000000000110011000010 →
    ///     0110000000000000000000000000000000000000000000000000110011000010 →
    ///     1110000000000000000000000000000000000000000000000000110011000010 →
    ///
    @Test func fromLargePositiveFloatsNearMinSignificandBitPattern() throws {
        for source in typesAsSwiftBinaryFloatingPoint {
            try whereIs(source: source, destination: InfiniInt<IX>.self)
            try whereIs(source: source, destination: InfiniInt<UX>.self)
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: Swift.BinaryFloatingPoint, B: ArbitraryInteger {
            //=----------------------------------=
            let start = A.significandBitCount
            let end   = A.significandBitCount + 32
            let steps = 32
            try #require(1 == A(sign: .plus, exponent: A.Exponent(start), significand: 1).ulp)
            //=----------------------------------=
            for exponent in start ..< end {
                try withOnlyOneCallToRequire((source, destination)) { require in
                    var source = A.init(
                        sign: FloatingPointSign.plus,
                        exponent: A.Exponent(exponent),
                        significand: 1.0 as A
                    )
                    
                    let sourceStep: A = source.ulp
                    var destination = B.lsb << exponent
                    let destinationStep = B.exactly(sourceStep)!
                    
                    for _ in 0 ..< steps {
                        require(destination == B.exactly(source))
                        source += sourceStep
                        destination += destinationStep
                    }
                }
            }
        }
    }
    
    /// Checks some bit patterns for exponents >= 52 (64-bit).
    ///
    ///     1111111111111111111111111111111111111111111111111111110011000010 →
    ///     0111111111111111111111111111111111111111111111111111110011000010 →
    ///     1011111111111111111111111111111111111111111111111111110011000010 →
    ///     0011111111111111111111111111111111111111111111111111110011000010 →
    ///
    ///     1101111111111111111111111111111111111111111111111111110011000010 →
    ///     0101111111111111111111111111111111111111111111111111110011000010 →
    ///     1001111111111111111111111111111111111111111111111111110011000010 →
    ///     0001111111111111111111111111111111111111111111111111110011000010 →
    ///
    @Test func fromLargePositiveFloatsNearMaxSignificandBitPattern() throws {
        for source in typesAsSwiftBinaryFloatingPoint {
            try whereIs(source: source, destination: InfiniInt<IX>.self)
            try whereIs(source: source, destination: InfiniInt<UX>.self)
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: Swift.BinaryFloatingPoint, B: ArbitraryInteger {
            //=----------------------------------=
            let start = A.significandBitCount + 1
            let end   = A.significandBitCount + 1 + 32
            let steps = 32
            try #require(2 == A(sign: .plus, exponent: A.Exponent(start), significand: 1).ulp)
            try #require(1 == A(sign: .plus, exponent: A.Exponent(start), significand: 1).nextDown.ulp)
            //=----------------------------------=
            for exponent in start ..< end {
                try withOnlyOneCallToRequire((source, destination)) { require in
                    var source = A(sign: .plus, exponent: A.Exponent(exponent), significand: 1)
                    let sourceStep: A = source.nextDown.ulp
                    var destination = B.lsb << IX(exponent)
                    let destinationStep = B.exactly(sourceStep)!
                    
                    for _ in 0 ..< steps {
                        source -= sourceStep
                        destination -= destinationStep
                        require(destination == B.exactly(source))
                    }
                }
            }
        }
    }
}
