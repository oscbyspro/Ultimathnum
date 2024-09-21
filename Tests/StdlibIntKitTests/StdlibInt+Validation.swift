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
import TestKit

//*============================================================================*
// MARK: * Stdlib Int x Validation
//*============================================================================*

extension StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Swift.BinaryInteger
    //=------------------------------------------------------------------------=
    
    func testInitBinaryInteger() {
        self.integer(  Int8.min, is:               -0x80 as T)
        self.integer(  Int8.max, is:                0x7f as T)
        self.integer( UInt8.min, is:                0x00 as T)
        self.integer( UInt8.max, is:                0xff as T)
        self.integer( Int16.min, is:             -0x8000 as T)
        self.integer( Int16.max, is:              0x7fff as T)
        self.integer(UInt16.min, is:              0x0000 as T)
        self.integer(UInt16.max, is:              0xffff as T)
        self.integer( Int32.min, is:         -0x80000000 as T)
        self.integer( Int32.max, is:          0x7fffffff as T)
        self.integer(UInt32.min, is:          0x00000000 as T)
        self.integer(UInt32.max, is:          0xffffffff as T)
        self.integer( Int64.min, is: -0x8000000000000000 as T)
        self.integer( Int64.max, is:  0x7fffffffffffffff as T)
        self.integer(UInt64.min, is:  0x0000000000000000 as T)
        self.integer(UInt64.max, is:  0xffffffffffffffff as T)
    }
    
    func testInitBinaryIntegerForEachByteEntropy() {
        func whereIs<T>(_ source: T.Type) where T: Swift.BinaryInteger {
            let min = T.isSigned ? T(Int8.min) : T(UInt8.min)
            let max = T.isSigned ? T(Int8.max) : T(UInt8.max)
            
            var lhs = min
            var rhs = StdlibInt(min)
            
            while true {
                self.integer(lhs, is: rhs)
                guard lhs < max else { break }
                lhs += 1
                rhs += 1
            }
            
            Test().same(lhs, max)
            Test().same(rhs, StdlibInt(max))
        }
        
        whereIs( Int .self)
        whereIs(UInt .self)
        whereIs( Int8.self)
        whereIs(UInt8.self)
        whereIs(StdlibInt.self)
    }
    
    func testInitBinaryIntegerByFuzzing() {
        var randomness = fuzzer
        func random<T>(_ random: T.Type = T.self) -> T where T: BinaryInteger {
            let size  = IX(size: T.self) ?? 256
            let index = IX.random(in: 000000000 ..< size, using: &randomness)!
            return T.random(through: Shift(Count(index)), using: &randomness)
        }
        
        #if DEBUG
        let rounds = 0032
        #else
        let rounds = 1024
        #endif
        
        for _ in 0 ..< rounds {
            let random: IXL = random()
            let value = StdlibInt(  random)
            self.integer(value, is:  value)
            Test().same(IXL(value), random)
        }
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Tests x Swift.BinaryFloatingPoint
    //=------------------------------------------------------------------------=
    
    func testInitDoubleNanIsNil() {
        self.double( Double.nan, is: nil)
        self.double(-Double.nan, is: nil)
    }
    
    func testInitDoubleInfinityIsNil() {
        self.double( Double.infinity, is: nil)
        self.double(-Double.infinity, is: nil)
    }
    
    func testInitDoubleRoundsTowardsZero() {
        self.double( 2.00, is:  2 as T, exactly: true)
        self.double( 1.75, is:  1 as T)
        self.double( 1.50, is:  1 as T)
        self.double( 1.25, is:  1 as T)
        self.double( 1.00, is:  1 as T, exactly: true)
        self.double( 0.75, is:  0 as T)
        self.double( 0.50, is:  0 as T)
        self.double( 0.25, is:  0 as T)
        self.double( 0.00, is:  0 as T, exactly: true)
        self.double( 0.25, is:  0 as T)
        self.double( 0.50, is:  0 as T)
        self.double( 0.75, is:  0 as T)
        self.double(-1.00, is: -1 as T, exactly: true)
        self.double(-1.25, is: -1 as T)
        self.double(-1.50, is: -1 as T)
        self.double(-1.75, is: -1 as T)
        self.double(-2.00, is: -2 as T, exactly: true)
        
        self.double( Double.pi,       is:  3 as T)
        self.double(-Double.pi,       is: -3 as T)
        
        self.double( Double.ulpOfOne, is:  0 as T)
        self.double(-Double.ulpOfOne, is:  0 as T)
        
        self.double( Double.leastNormalMagnitude,  is: 0 as T)
        self.double(-Double.leastNormalMagnitude,  is: 0 as T)
        
        self.double( Double.leastNonzeroMagnitude, is: 0 as T)
        self.double(-Double.leastNonzeroMagnitude, is: 0 as T)
    }
    
    func testInitDoubleGreatestFiniteMagnitude() {
        let expectation = T("""
        0000000000017976931348623157081452742373170435679807056752584499\
        6598917476803157260780028538760589558632766878171540458953514382\
        4642343213268894641827684675467035375169860499105765512820762454\
        9009038932894407586850845513394230458323690322294816580855933212\
        3348274797826204144723168738177180919299881250404026184124858368
        """)!
        
        self.double( Double.greatestFiniteMagnitude, is:  expectation, exactly: true)
        self.double(-Double.greatestFiniteMagnitude, is: -expectation, exactly: true)
    }
    
    /// Checks some bit patterns for exponents >= 52.
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
    func testInitDoubleLargeNegativeValues() {
        //=--------------------------------------=
        let start = Double.significandBitCount
        //=--------------------------------------=
        for exponent: Swift.Int in start ..< start + 64 {
            var source = Double(sign: .minus, exponent: exponent, significand: 1)
            var sourceIncrement: Double = -source.ulp
            
            var destination = T(-1) << exponent
            var destinationincrement = T(sourceIncrement)
            
            for _ in 0 ..< Double.significandBitCount {                
                source               += sourceIncrement
                sourceIncrement      += sourceIncrement
                destination          += destinationincrement
                destinationincrement += destinationincrement
                self.double(source, is: destination, exactly: true)
            }
        }
    }
    
    /// Checks some bit patterns for exponents >= 52.
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
    func testInitDoubleLargeNegativeValuesNearMinSignificandBitPattern() {
        //=--------------------------------------=
        let start = Double.significandBitCount
        Test().same(Double(sign: .minus, exponent: start, significand: 1).ulp, 1)
        //=--------------------------------------=
        for exponent: Swift.Int in start ..< start + 64 {
            var source = Double(sign: .minus, exponent: exponent, significand: 1)
            var destination = T(-1) << exponent
            let sourceIncrement: Double = -source.ulp
            let destinationincrement = T(sourceIncrement)
            
            for _ in 0 ..< 32 {
                self.double(source, is: destination, exactly: true)
                source += sourceIncrement
                destination += destinationincrement
            }
        }
    }
    
    /// Checks some bit patterns for exponents >= 52.
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
    func testInitDoubleLargeNegativeValuesNearMaxSignificandBitPattern() {
        //=--------------------------------------=
        let start = Double.significandBitCount + 1
        Test().same(Double(sign: .minus, exponent: start, significand: 1).ulp, 2)
        Test().same(Double(sign: .minus, exponent: start, significand: 1).nextUp.ulp, 1)
        //=--------------------------------------=
        for exponent: Swift.Int in start ..< start + 64 {
            var source = Double(sign: .minus, exponent: exponent, significand: 1)
            let sourceIncrement: Double = source.nextUp.ulp
            var destination = T(-1) << exponent
            let destinationincrement = T(sourceIncrement)
            
            for _ in 0 ..< 32 {
                source += sourceIncrement
                destination += destinationincrement
                self.double(source, is: destination, exactly: true)
            }
        }
    }
    
    /// Checks some bit patterns for exponents >= 52.
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
    func testInitDoubleLargePositiveValues() {
        //=--------------------------------------=
        let start = Double.significandBitCount
        //=--------------------------------------=
        for exponent: Swift.Int in start ..< start + 64 {
            var source = Double(sign: .plus, exponent: exponent, significand: 1)
            var sourceIncrement: Double = source.ulp
            
            var destination = T(1) << exponent
            var destinationincrement = T(sourceIncrement)
            
            for _ in 0 ..< Double.significandBitCount {
                source               += sourceIncrement
                sourceIncrement      += sourceIncrement
                destination          += destinationincrement
                destinationincrement += destinationincrement
                self.double(source, is: destination, exactly: true)
            }
        }
    }
    
    /// Checks some bit patterns for exponents >= 52.
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
    func testInitDoubleLargePositiveValuesNearMinSignificandBitPattern() {
        //=--------------------------------------=
        let start = Double.significandBitCount
        Test().same(Double(sign: .plus, exponent: start, significand: 1).ulp, 1)
        //=--------------------------------------=
        for exponent: Swift.Int in start ..< start + 64 {
            var source = Double(sign: .plus, exponent: exponent, significand: 1)
            var destination = T(1) << exponent
            let sourceIncrement: Double = source.ulp
            let destinationincrement = T(sourceIncrement)
            
            for _ in 0 ..< 32 {
                self.double(source, is: destination, exactly: true)
                source += sourceIncrement
                destination += destinationincrement
            }
        }
    }
    
    /// Checks some bit patterns for exponents >= 52.
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
    func testInitDoubleLargePositiveValuesNearMaxSignificandBitPattern() {
        //=--------------------------------------=
        let start = Double.significandBitCount + 1
        Test().same(Double(sign: .plus, exponent: start, significand: 1).ulp, 2)
        Test().same(Double(sign: .plus, exponent: start, significand: 1).nextDown.ulp, 1)
        //=--------------------------------------=
        for exponent: Swift.Int in start ..< start + 64 {
            var source = Double(sign: .plus, exponent: exponent, significand: 1)
            let sourceIncrement: Double = -source.nextDown.ulp
            var destination = T(1) << exponent
            let destinationincrement = T(sourceIncrement)
            
            for _ in 0 ..< 32 {
                source += sourceIncrement
                destination += destinationincrement
                self.double(source, is: destination, exactly: true)
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func integer(_ source: some Swift.BinaryInteger, is destination: StdlibInt, file: StaticString = #file, line: UInt = #line) {
        let test = Test(file: file, line: line)
        
        test.same(T(                    source), destination)
        test.same(T(exactly:            source), destination)
        test.same(T(clamping:           source), destination)
        test.same(T(truncatingIfNeeded: source), destination)
        test.same(T(InfiniInt<IX>(destination)), destination)
            
        description: do {
            let     decimal = destination.description(as:     .decimal)
            let hexadecimal = destination.description(as: .hexadecimal)
            
            test.same(    decimal,      source.description)
            test.same(    decimal, destination.description)
            test.same(    decimal, String(destination, radix: 10))
            test.same(hexadecimal, String(destination, radix: 16))

            test.same(     T(    decimal),                   destination)
            test.same(try? T(    decimal, as:     .decimal), destination)
            test.same(try? T(hexadecimal, as: .hexadecimal), destination)
        }
    }

    func double(_ source: Double, is destination: StdlibInt?, exactly: Bool = false, file: StaticString = #file, line: UInt = #line) {
        let test = Test(file: file, line: line)
        
        if  let destination {
            test.same(StdlibInt(source), destination)
        }
        
        if  let destination, exactly {
            test.same(Double(destination), source)
        }
        
        test.same(T(exactly: source), exactly ? destination : nil)
    }
}
