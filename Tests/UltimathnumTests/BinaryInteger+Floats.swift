//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Floats
//*============================================================================*

final class BinaryIntegerTestsOnFloats: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitFloatRoundsTowardsZero() {
        func whereIs<A, B>(source: A.Type, destination: B.Type) where A: Swift.BinaryFloatingPoint, B: BinaryInteger {
            Test().stdlib(A( 0.00), is: 0 as B, exactly: true)
            Test().stdlib(A( 0.25), is: 0 as B)
            Test().stdlib(A( 0.50), is: 0 as B)
            Test().stdlib(A( 0.75), is: 0 as B)
            Test().stdlib(A( 1.00), is: 1 as B, exactly: true)
            Test().stdlib(A( 1.25), is: 1 as B)
            Test().stdlib(A( 1.50), is: 1 as B)
            Test().stdlib(A( 1.75), is: 1 as B)
            Test().stdlib(A( 2.00), is: 2 as B, exactly: true)
            Test().stdlib(A( 2.25), is: 2 as B)
            Test().stdlib(A( 2.50), is: 2 as B)
            Test().stdlib(A( 2.75), is: 2 as B)
            Test().stdlib(A( 3.00), is: 3 as B, exactly: true)
            
            Test().stdlib(A(-0.00), is: 0 as B, exactly: true)
            Test().stdlib(A(-0.25), is: 0 as B)
            Test().stdlib(A(-0.50), is: 0 as B)
            Test().stdlib(A(-0.75), is: 0 as B)
            Test().stdlib(A(-1.00), is: B.isSigned ? -1 as B : nil, exactly: true)
            Test().stdlib(A(-1.25), is: B.isSigned ? -1 as B : nil)
            Test().stdlib(A(-1.50), is: B.isSigned ? -1 as B : nil)
            Test().stdlib(A(-1.75), is: B.isSigned ? -1 as B : nil)
            Test().stdlib(A(-2.00), is: B.isSigned ? -2 as B : nil, exactly: true)
            Test().stdlib(A(-2.25), is: B.isSigned ? -2 as B : nil)
            Test().stdlib(A(-2.50), is: B.isSigned ? -2 as B : nil)
            Test().stdlib(A(-2.75), is: B.isSigned ? -2 as B : nil)
            Test().stdlib(A(-3.00), is: B.isSigned ? -3 as B : nil, exactly: true)
            
            Test().stdlib( A.pi, is: 3 as B)
            Test().stdlib(-A.pi, is: B.isSigned ? -3 as B : nil)
            
            Test().stdlib( A.ulpOfOne, is: B.zero)
            Test().stdlib(-A.ulpOfOne, is: B.zero)
            
            Test().stdlib( A.leastNormalMagnitude,  is: B.zero)
            Test().stdlib(-A.leastNormalMagnitude,  is: B.zero)
            
            Test().stdlib( A.leastNonzeroMagnitude, is: B.zero)
            Test().stdlib(-A.leastNonzeroMagnitude, is: B.zero)
        }
        
        for source in stdlibSystemsFloats {
            for destination in binaryIntegers {
                whereIs(source: source, destination: destination)
            }
        }
    }
    
    func testInitFloatNanIsNil() {
        func whereIs<A, B>(source: A.Type, destination: B.Type) where A: Swift.BinaryFloatingPoint, B: BinaryInteger {
            Test().stdlib( A.nan, is: Optional<B>.none)
            Test().stdlib(-A.nan, is: Optional<B>.none)
        }
        
        for source in stdlibSystemsFloats {
            for destination in binaryIntegers {
                whereIs(source: source, destination: destination)
            }
        }
    }
    
    func testInitFloatInfinityIsNil() {
        func whereIs<A, B>(source: A.Type, destination: B.Type) where A: Swift.BinaryFloatingPoint, B: BinaryInteger {
            Test().stdlib( A.infinity, is: Optional<B>.none)
            Test().stdlib(-A.infinity, is: Optional<B>.none)
        }
        
        for source in stdlibSystemsFloats {
            for destination in binaryIntegers {
                whereIs(source: source, destination: destination)
            }
        }
    }
    
    func testInitFloatPureExponent() {
        func whereIs<A, B>(source: A.Type, destination: B.Type) where A: Swift.BinaryFloatingPoint, B: BinaryInteger {
            let size = IX(size: B.self) ?? 128
            for exponent: IX in 0 ..< 2 * size {
                //=------------------------------=
                let positive = Double(sign: .plus,  exponent: Int(exponent), significand: 1)
                let negative = Double(sign: .minus, exponent: Int(exponent), significand: 1)
                //=------------------------------=
                if  let distance  = Shift<B.Magnitude>(exactly: Count(exponent)) {
                    let magnitude = B.Magnitude.lsb.up(distance)
                    Test().stdlib(positive, is: B.exactly(sign: .plus,  magnitude: magnitude).optional(), exactly: true)
                    Test().stdlib(negative, is: B.exactly(sign: .minus, magnitude: magnitude).optional(), exactly: true)
                }   else {
                    Test().stdlib(positive, is: Optional<B>.none)
                    Test().stdlib(negative, is: Optional<B>.none)
                }
            }
        }
        
        for source in stdlibSystemsFloats {
            for destination in binaryIntegers {
                whereIs(source: source, destination: destination)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitGreatestFiniteMagnitudeAsFloat32() {
        let positive = IXL(340282346638528859811704183484516925440)
        let negative = positive.negated().unwrap()
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Test().stdlib( Float32.greatestFiniteMagnitude, is: T.exactly(positive).optional(), exactly: true)
            Test().stdlib(-Float32.greatestFiniteMagnitude, is: T.exactly(negative).optional(), exactly: true)
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testInitGreatestFiniteMagnitudeAsFloat64() {
        let positive = IXL("""
        0000000000017976931348623157081452742373170435679807056752584499\
        6598917476803157260780028538760589558632766878171540458953514382\
        4642343213268894641827684675467035375169860499105765512820762454\
        9009038932894407586850845513394230458323690322294816580855933212\
        3348274797826204144723168738177180919299881250404026184124858368
        """)!
        let negative = positive.negated().unwrap()
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Test().stdlib( Float64.greatestFiniteMagnitude, is: T.exactly(positive).optional(), exactly: true)
            Test().stdlib(-Float64.greatestFiniteMagnitude, is: T.exactly(negative).optional(), exactly: true)
        }
        
        for type in binaryIntegers {
            whereIs(type)
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
    func testInitLargeNegativeFloats() {
        func whereIs<A, B>(
            source: A.Type, destination: B.Type, exponents: IX, steps: IX
        )   where A: Swift.BinaryFloatingPoint, B: ArbitraryInteger {
            //=--------------------------------------=
            let start = A.significandBitCount
            //=--------------------------------------=
            for exponent in start ..< start + Swift.Int(exponents) {
                var source = A(sign: .minus, exponent: A.Exponent(exponent), significand: 1)
                var sourceStep: A = source.ulp
                var destination = B.isSigned ? B(-1) << IX(exponent) : nil
                var destinationStep = B.exactly(sourceStep)!

                for _ in 0 ..< steps {
                    source          -= sourceStep
                    sourceStep      += sourceStep
                    destination?    -= destinationStep
                    destinationStep += destinationStep
                    Test().stdlib(source, is: destination, exactly: true)
                }
            }
        }
        
        for source in stdlibSystemsFloats {
            let steps = IX(source.significandBitCount)
            whereIs(source: source, destination: InfiniInt<IX>.self, exponents: 32, steps: steps)
            whereIs(source: source, destination: InfiniInt<UX>.self, exponents: 32, steps: steps)
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
    func testInitLargeNegativeFloatsNearMinSignificandBitPattern() {
        func whereIs<A, B>(
            source: A.Type, destination: B.Type, exponents: IX, steps: IX
        )   where A: Swift.BinaryFloatingPoint, B: ArbitraryInteger {
            //=----------------------------------=
            let start = A.significandBitCount
            Test().same(A(sign: .minus, exponent: A.Exponent(start), significand: 1).ulp, 1)
            //=----------------------------------=
            for exponent in start ..< start + Swift.Int(exponents) {
                var source = A(sign: .minus, exponent: A.Exponent(exponent), significand: 1)
                let sourceStep: A = source.ulp
                var destination = B.isSigned ? B(-1) << IX(exponent) : nil
                let destinationStep = B.exactly(sourceStep)!
                
                for _ in 0 ..< steps {
                    Test().stdlib(source, is: destination, exactly: true)
                    source -= sourceStep
                    destination? -= destinationStep
                }
            }
        }
        
        for source in stdlibSystemsFloats {
            whereIs(source: source, destination: InfiniInt<IX>.self, exponents: 32, steps: 32)
            whereIs(source: source, destination: InfiniInt<UX>.self, exponents: 32, steps: 32)
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
    func testInitLargeNegativeFloatsNearMaxSignificandBitPattern() {
        func whereIs<A, B>(
            source: A.Type, destination: B.Type, exponents: IX, steps: IX
        )   where A: Swift.BinaryFloatingPoint, B: ArbitraryInteger {
            //=----------------------------------=
            let start = A.significandBitCount + 1
            Test().same(A(sign: .minus, exponent: A.Exponent(start), significand: 1).ulp, 2)
            Test().same(A(sign: .minus, exponent: A.Exponent(start), significand: 1).nextUp.ulp, 1)
            //=----------------------------------=
            for exponent in start ..< start + Swift.Int(exponents) {
                var source = A(sign: .minus, exponent: A.Exponent(exponent), significand: 1)
                let sourceStep: A = source.nextUp.ulp
                var destination = B.isSigned ? B(-1) << IX(exponent) : nil
                let destinationStep = B.exactly(sourceStep)!
                
                for _ in 0 ..< steps {
                    source += sourceStep
                    destination? += destinationStep
                    Test().stdlib(source, is: destination, exactly: true)
                }
            }
        }
        
        for source in stdlibSystemsFloats {
            whereIs(source: source, destination: InfiniInt<IX>.self, exponents: 32, steps: 32)
            whereIs(source: source, destination: InfiniInt<UX>.self, exponents: 32, steps: 32)
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
    func testInitLargePositiveFloats() {
        func whereIs<A, B>(
            source: A.Type, destination: B.Type, exponents: IX, steps: IX
        )   where A: Swift.BinaryFloatingPoint, B: ArbitraryInteger {
            //=--------------------------------------=
            let start = A.significandBitCount
            //=--------------------------------------=
            for exponent in start ..< start + Swift.Int(exponents) {
                var source = A(sign: .plus, exponent: A.Exponent(exponent), significand: 1)
                var sourceStep: A = source.ulp
                var destination = B.lsb << IX(exponent)
                var destinationStep = B.exactly(sourceStep)!

                for _ in 0 ..< steps {
                    source          += sourceStep
                    sourceStep      += sourceStep
                    destination     += destinationStep
                    destinationStep += destinationStep
                    Test().stdlib(source, is: destination, exactly: true)
                }
            }
        }
        
        for source in stdlibSystemsFloats {
            let steps = IX(source.significandBitCount)
            whereIs(source: source, destination: InfiniInt<IX>.self, exponents: 32, steps: steps)
            whereIs(source: source, destination: InfiniInt<UX>.self, exponents: 32, steps: steps)
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
    func testInitLargePositiveFloatsNearMinSignificandBitPattern() {
        func whereIs<A, B>(
            source: A.Type, destination: B.Type, exponents: IX, steps: IX
        )   where A: Swift.BinaryFloatingPoint, B: ArbitraryInteger {
            //=--------------------------------------=
            let start = A.significandBitCount
            Test().same(A(sign: .plus, exponent: A.Exponent(start), significand: 1).ulp, 1)
            //=--------------------------------------=
            for exponent in start ..< start + Swift.Int(exponents) {
                var source = A(sign: .plus, exponent: A.Exponent(exponent), significand: 1)
                let sourceStep: A = source.ulp
                var destination = B.lsb << exponent
                let destinationStep = B.exactly(sourceStep)!
                
                for _ in 0 ..< steps {
                    Test().stdlib(source, is: destination, exactly: true)
                    source += sourceStep
                    destination += destinationStep
                }
            }
        }
        
        for source in stdlibSystemsFloats {
            whereIs(source: source, destination: InfiniInt<IX>.self, exponents: 32, steps: 32)
            whereIs(source: source, destination: InfiniInt<UX>.self, exponents: 32, steps: 32)
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
    func testInitLargePositiveFloatsNearMaxSignificandBitPattern() {
        func whereIs<A, B>(
            source: A.Type, destination: B.Type, exponents: IX, steps: IX
        )   where A: Swift.BinaryFloatingPoint, B: ArbitraryInteger {
            //=----------------------------------=
            let start = A.significandBitCount + 1
            Test().same(A(sign: .plus, exponent: A.Exponent(start), significand: 1).ulp, 2)
            Test().same(A(sign: .plus, exponent: A.Exponent(start), significand: 1).nextDown.ulp, 1)
            //=----------------------------------=
            for exponent in start ..< start + Swift.Int(exponents) {
                var source = A(sign: .plus, exponent: A.Exponent(exponent), significand: 1)
                let sourceStep: A = source.nextDown.ulp
                var destination = B.lsb << IX(exponent)
                let destinationStep = B.exactly(sourceStep)!
                
                for _ in 0 ..< steps {
                    source -= sourceStep
                    destination -= destinationStep
                    Test().stdlib(source, is: destination, exactly: true)
                }
            }
        }
        
        for source in stdlibSystemsFloats {
            whereIs(source: source, destination: InfiniInt<IX>.self, exponents: 32, steps: 32)
            whereIs(source: source, destination: InfiniInt<UX>.self, exponents: 32, steps: 32)
        }
    }
}
