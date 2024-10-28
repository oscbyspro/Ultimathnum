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
import StdlibIntKit
import TestKit2

//*============================================================================*
// MARK: * Stdlib Int x Floats
//*============================================================================*

/// An `StdlibInt` test suite.
///
/// ### Wrapper
///
/// `StdlibInt` should forward most function calls to its underlying model.
///
/// ### Development
///
/// - TODO: Test `StdlibInt` forwarding in generic `BinaryInteger` tests.
///
@Suite struct StdlibIntTestsOnFloats {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Swift.BinaryFloatingPoint
    //=------------------------------------------------------------------------=
    
    @Test(
        "StdlibInt ← Swift.BinaryFloatingPoint - nan is nil",
        arguments: typesAsSwiftBinaryFloatingPoint
    )   func initSwiftBinaryFloatingPointNanIsNil(type: any Swift.BinaryFloatingPoint.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: Swift.BinaryFloatingPoint {
            Ɣexpect( T.nan, is: nil)
            Ɣexpect(-T.nan, is: nil)
        }
    }
    
    @Test(
        "StdlibInt ← Swift.BinaryFloatingPoint - infinity is nil",
        arguments: typesAsSwiftBinaryFloatingPoint
    )   func initSwiftBinaryFloatingPointInfinityIsNil(type: any Swift.BinaryFloatingPoint.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: Swift.BinaryFloatingPoint {
            Ɣexpect( T.infinity, is: nil)
            Ɣexpect(-T.infinity, is: nil)
        }
    }
    
    @Test(
        "StdlibInt ← Swift.BinaryFloatingPoint - rounds towards zero",
        arguments: typesAsSwiftBinaryFloatingPoint
    )   func initSwiftBinaryFloatingPointRoundsTowardsZero(type: any Swift.BinaryFloatingPoint.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: Swift.BinaryFloatingPoint {
            Ɣexpect( 2.00 as T, is:  2 as StdlibInt, exactly: true)
            Ɣexpect( 1.75 as T, is:  1 as StdlibInt)
            Ɣexpect( 1.50 as T, is:  1 as StdlibInt)
            Ɣexpect( 1.25 as T, is:  1 as StdlibInt)
            Ɣexpect( 1.00 as T, is:  1 as StdlibInt, exactly: true)
            Ɣexpect( 0.75 as T, is:  0 as StdlibInt)
            Ɣexpect( 0.50 as T, is:  0 as StdlibInt)
            Ɣexpect( 0.25 as T, is:  0 as StdlibInt)
            Ɣexpect( 0.00 as T, is:  0 as StdlibInt, exactly: true)
            Ɣexpect( 0.25 as T, is:  0 as StdlibInt)
            Ɣexpect( 0.50 as T, is:  0 as StdlibInt)
            Ɣexpect( 0.75 as T, is:  0 as StdlibInt)
            Ɣexpect(-1.00 as T, is: -1 as StdlibInt, exactly: true)
            Ɣexpect(-1.25 as T, is: -1 as StdlibInt)
            Ɣexpect(-1.50 as T, is: -1 as StdlibInt)
            Ɣexpect(-1.75 as T, is: -1 as StdlibInt)
            Ɣexpect(-2.00 as T, is: -2 as StdlibInt, exactly: true)

            Ɣexpect( T.pi, is:  3 as StdlibInt)
            Ɣexpect(-T.pi, is: -3 as StdlibInt)

            Ɣexpect( T.ulpOfOne, is: 0 as StdlibInt)
            Ɣexpect(-T.ulpOfOne, is: 0 as StdlibInt)

            Ɣexpect( T.leastNormalMagnitude,  is: 0 as StdlibInt)
            Ɣexpect(-T.leastNormalMagnitude,  is: 0 as StdlibInt)

            Ɣexpect( T.leastNonzeroMagnitude, is: 0 as StdlibInt)
            Ɣexpect(-T.leastNonzeroMagnitude, is: 0 as StdlibInt)
        }
    }
    
    @Test("StdlibInt ← Swift.BinaryFloatingPoint - greatest finite magnitude [32-bit]")
    func initGreatestFiniteMagnitudeAsFloat32() {
        let positive = IXL(340282346638528859811704183484516925440)
        
        Ɣexpect( Float32.greatestFiniteMagnitude, is: StdlibInt( positive), exactly: true)
        Ɣexpect(-Float32.greatestFiniteMagnitude, is: StdlibInt(-positive), exactly: true)
    }
    
    @Test("StdlibInt ← Swift.BinaryFloatingPoint - greatest finite magnitude [64-bit]")
    func initGreatestFiniteMagnitudeAsFloat64() {
        let positive = IXL("""
        0000000000017976931348623157081452742373170435679807056752584499\
        6598917476803157260780028538760589558632766878171540458953514382\
        4642343213268894641827684675467035375169860499105765512820762454\
        9009038932894407586850845513394230458323690322294816580855933212\
        3348274797826204144723168738177180919299881250404026184124858368
        """)!
        
        Ɣexpect( Float64.greatestFiniteMagnitude, is: StdlibInt( positive), exactly: true)
        Ɣexpect(-Float64.greatestFiniteMagnitude, is: StdlibInt(-positive), exactly: true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
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
    @Test(
        "StdlibInt ← Swift.BinaryFloatingPoint - [large][negative]",
        arguments: typesAsSwiftBinaryFloatingPoint
    )   func initLargeNegativeFloats(source: any Swift.BinaryFloatingPoint.Type) {
        whereIs(source: source, exponents: 32, steps: source.significandBitCount)
        
        func whereIs<T>(source: T.Type, exponents: Int, steps: Int) where T: Swift.BinaryFloatingPoint {
            //=----------------------------------=
            let start = T.significandBitCount
            //=----------------------------------=
            for exponent in start ..< start + exponents {
                var source = T(sign: .minus,  exponent: T.Exponent(exponent), significand: 1)
                var sourceStep: T = source.ulp
                var destination = StdlibInt.isSigned ? StdlibInt(-1) << exponent : nil
                var destinationStep = StdlibInt(exactly: sourceStep)!
                
                for _ in 0 ..< steps {
                    source          -= sourceStep
                    sourceStep      += sourceStep
                    destination?    -= destinationStep
                    destinationStep += destinationStep
                    Ɣexpect(source, is: destination, exactly: true)
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
    @Test(
        "StdlibInt ← Swift.BinaryFloatingPoint - [large][negative][min]",
        arguments: typesAsSwiftBinaryFloatingPoint
    )   func initLargeNegativeFloatsNearMinSignificandBitPattern(source: any Swift.BinaryFloatingPoint.Type) {
        whereIs(source: source, exponents: 32, steps: 32)
        
        func whereIs<T>(source: T.Type, exponents: Int, steps: Int) where T: Swift.BinaryFloatingPoint {
            //=----------------------------------=
            let start = T.significandBitCount
            //=----------------------------------=
            for exponent in start ..< start + exponents {
                var source = T(sign: .minus,  exponent: T.Exponent(exponent), significand: 1)
                let sourceStep: T = source.ulp
                var destination = StdlibInt.isSigned ? StdlibInt(-1) << exponent : nil
                let destinationStep = StdlibInt(exactly: sourceStep)!
                
                for _ in 0 ..< steps {
                    Ɣexpect(source, is: destination, exactly: true)
                    source -= sourceStep
                    destination? -= destinationStep
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
    @Test(
        "StdlibInt ← Swift.BinaryFloatingPoint - [large][negative][max]",
        arguments: typesAsSwiftBinaryFloatingPoint
    )   func initLargeNegativeFloatsNearMaxSignificandBitPattern(source: any Swift.BinaryFloatingPoint.Type) {
        whereIs(source: source, exponents: 32, steps: 32)
        
        func whereIs<T>(source: T.Type, exponents: Int, steps: Int) where T: Swift.BinaryFloatingPoint {
            //=----------------------------------=
            let start = T.significandBitCount + 1
            //=----------------------------------=
            for exponent in start ..< start + exponents {
                var source = T(sign: .minus,  exponent: T.Exponent(exponent), significand: 1)
                let sourceStep: T = source.nextUp.ulp
                var destination = StdlibInt.isSigned ? StdlibInt(-1) << exponent : nil
                let destinationStep = StdlibInt(exactly: sourceStep)!
                
                for _ in 0 ..< steps {
                    source += sourceStep
                    destination? += destinationStep
                    Ɣexpect(source, is: destination, exactly: true)
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
    @Test(
        "StdlibInt ← Swift.BinaryFloatingPoint - [large][positive]",
        arguments: typesAsSwiftBinaryFloatingPoint
    )   func initLargePositiveFloats(source: any Swift.BinaryFloatingPoint.Type) {
        whereIs(source: source, exponents: 32, steps: source.significandBitCount)
        
        func whereIs<T>(source: T.Type, exponents: Int, steps: Int) where T: Swift.BinaryFloatingPoint {
            //=----------------------------------=
            let start = T.significandBitCount
            //=----------------------------------=
            for exponent in start ..< start + exponents {
                var source = T(sign: .plus,   exponent: T.Exponent(exponent), significand: 1)
                var sourceStep: T = source.ulp
                var destination = StdlibInt(1) << exponent
                var destinationStep = StdlibInt(exactly: sourceStep)!

                for _ in 0 ..< steps {
                    source          += sourceStep
                    sourceStep      += sourceStep
                    destination     += destinationStep
                    destinationStep += destinationStep
                    Ɣexpect(source, is: destination, exactly: true)
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
    @Test(
        "StdlibInt ← Swift.BinaryFloatingPoint - [large][positive][min]",
        arguments: typesAsSwiftBinaryFloatingPoint
    )   func initLargePositiveFloatsNearMinSignificandBitPattern(source: any Swift.BinaryFloatingPoint.Type) {
        whereIs(source: source, exponents: 32, steps: 32)
        
        func whereIs<T>(source: T.Type, exponents: Int, steps: Int) where T: Swift.BinaryFloatingPoint {
            //=----------------------------------=
            let start = T.significandBitCount
            //=----------------------------------=
            for exponent in start ..< start + exponents {
                var source = T(sign: .plus,   exponent: T.Exponent(exponent), significand: 1)
                let sourceStep: T = source.ulp
                var destination = StdlibInt(1) << exponent
                let destinationStep = StdlibInt(exactly: sourceStep)!
                
                for _ in 0 ..< steps {
                    Ɣexpect(source, is: destination, exactly: true)
                    source += sourceStep
                    destination += destinationStep
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
    @Test(
        "StdlibInt ← Swift.BinaryFloatingPoint - [large][positive][max]",
        arguments: typesAsSwiftBinaryFloatingPoint
    )   func initLargePositiveFloatsNearMaxSignificandBitPattern(source: any Swift.BinaryFloatingPoint.Type) {
        whereIs(source: source, exponents: 32, steps: 32)
        
        func whereIs<T>(source: T.Type, exponents: Int, steps: Int) where T: Swift.BinaryFloatingPoint {
            //=----------------------------------=
            let start = T.significandBitCount + 1
            //=----------------------------------=
            for exponent in start ..< start + exponents {
                var source = T(sign: .plus,   exponent: T.Exponent(exponent), significand: 1)
                let sourceStep: T = source.nextDown.ulp
                var destination = StdlibInt(1) << exponent
                let destinationStep = StdlibInt(exactly: sourceStep)!
                
                for _ in 0 ..< steps {
                    source -= sourceStep
                    destination -= destinationStep
                    Ɣexpect(source, is: destination, exactly: true)
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func Ɣexpect<Source>(
        _  source: Source,
        is destination: StdlibInt?,
        exactly: Bool = false,
        at location: SourceLocation = #_sourceLocation
    )   where Source: Swift.BinaryFloatingPoint {
        
        if  let destination {
            #expect(StdlibInt(source) == destination)
        }
        
        if  let destination, exactly {
            #expect(Source(destination) == source)
        }
        
        #expect(StdlibInt(exactly: source) == (exactly ? destination : nil))
    }
}
