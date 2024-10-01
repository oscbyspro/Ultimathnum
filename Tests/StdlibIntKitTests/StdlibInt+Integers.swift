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
// MARK: * Stdlib Int x Integers
//*============================================================================*

extension StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        Test().same(T(-2).magnitude, 2 as T)
        Test().same(T(-1).magnitude, 1 as T)
        Test().same(T( 0).magnitude, 0 as T)
        Test().same(T( 1).magnitude, 1 as T)
        Test().same(T( 2).magnitude, 2 as T)
    }
    
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
}
