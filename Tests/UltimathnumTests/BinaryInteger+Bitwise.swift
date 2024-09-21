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
// MARK: * Binary Integer x Bitwise
//*============================================================================*

final class BinaryIntegerTestsOnBitwise: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBitOrRepeatingBit() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Test().same(T(Bit.zero), 0 as T)
            Test().same(T(Bit.one ), 1 as T)
            Test().same(T(repeating: Bit.zero),  (0 as T))
            Test().same(T(repeating: Bit.one ), ~(0 as T))
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testLsbEqualsIsOdd() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var isOdd =  false
            for small in I8.min ... I8.max {
                Test().same(T(load: small).lsb, Bit(isOdd))
                isOdd.toggle()
            }
            
            Test().same((Esque<T>.min    ).lsb, Bit.zero)
            Test().same((Esque<T>.min + 1).lsb, Bit.one )
            Test().same((Esque<T>.min + 2).lsb, Bit.zero)
            Test().same((Esque<T>.min + 3).lsb, Bit.one )
            
            Test().same((Esque<T>.max - 3).lsb, Bit.zero)
            Test().same((Esque<T>.max - 2).lsb, Bit.one )
            Test().same((Esque<T>.max - 1).lsb, Bit.zero)
            Test().same((Esque<T>.max    ).lsb, Bit.one )
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testMsbEqualsSignitudeIsNegative() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for small in I8.min ... I8.max {
                Test().same(T(load: small).msb, Bit(small.isNegative))
            }
            
            Test().same((Esque<T>.min    ).msb, Bit( T.isSigned))
            Test().same((Esque<T>.min + 1).msb, Bit( T.isSigned))
            Test().same((Esque<T>.min + 2).msb, Bit( T.isSigned))
            Test().same((Esque<T>.min + 3).msb, Bit( T.isSigned))
            
            Test().same((Esque<T>.max - 3).msb, Bit(!T.isSigned))
            Test().same((Esque<T>.max - 2).msb, Bit(!T.isSigned))
            Test().same((Esque<T>.max - 1).msb, Bit(!T.isSigned))
            Test().same((Esque<T>.max    ).msb, Bit(!T.isSigned))
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testLogicOfAlternatingBitEsque() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            let r10 = T.exactly(0x55555555555555555555555555555555).value // 128-bit: 1010...
            let r01 = T.exactly(0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA).value // 128-bit: 0101...
            let x00 = T.exactly(0x00000000000000000000000000000000).value // 128-bit: 0000...
            let xff = T.exactly(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF).value // 128-bit: 1111...
            
            Test().not( r10, T(repeating: Bit.one) - r10)
            Test().not(~r10, T(repeating: Bit.one) - r10.toggled())
            Test().not( r01, T(repeating: Bit.one) - r01)
            Test().not(~r01, T(repeating: Bit.one) - r01.toggled())
            
            Test().and( r10,  r10,  r10)
            Test().and( r10,  r01,  x00)
            Test().and( r01,  r10,  x00)
            Test().and( r01,  r01,  r01)
            Test().and(~r10, ~r10, ~r10)
            Test().and(~r10, ~r01, ~xff)
            Test().and(~r01, ~r10, ~xff)
            Test().and(~r01, ~r01, ~r01)
            
            Test().or ( r10,  r10,  r10)
            Test().or ( r10,  r01,  xff)
            Test().or ( r01,  r10,  xff)
            Test().or ( r01,  r01,  r01)
            Test().or (~r10, ~r10, ~r10)
            Test().or (~r10, ~r01, ~x00)
            Test().or (~r01, ~r10, ~x00)
            Test().or (~r01, ~r01, ~r01)
            
            Test().xor( r10,  r10,  x00)
            Test().xor( r10,  r01,  xff)
            Test().xor( r01,  r10,  xff)
            Test().xor( r01,  r01,  x00)
            Test().xor(~r10, ~r10,  x00)
            Test().xor(~r10, ~r01,  xff)
            Test().xor(~r01, ~r10,  xff)
            Test().xor(~r01, ~r01,  x00)
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Systems Integer
    //=------------------------------------------------------------------------=
    
    func testEndianness() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            //=----------------------------------=
            let size = IX(size: T.self)
            //=----------------------------------=
            Test().same(T(repeating: Bit.zero).endianness( .ascending), T(repeating: Bit.zero))
            Test().same(T(repeating: Bit.zero).endianness(.descending), T(repeating: Bit.zero))
            Test().same(T(repeating: Bit.one ).endianness( .ascending), T(repeating: Bit.one ))
            Test().same(T(repeating: Bit.one ).endianness(.descending), T(repeating: Bit.one ))
            
            Test().same(T(1).endianness( .endianess),                         T(1))
            Test().same(T(1).endianness( .endianess.reversed()),              T(1) << (size - 8))
            Test().same(T(5).endianness( .ascending).endianness( .ascending), T(5))
            Test().same(T(4).endianness( .ascending).endianness(.descending), T(4) << (size - 8))
            Test().same(T(3).endianness(.descending).endianness( .ascending), T(3) << (size - 8))
            Test().same(T(2).endianness(.descending).endianness(.descending), T(2))
        }
        
        for type in systemsIntegers {
            whereIs(type)
        }
    }
    
    func testGetSetBitAtIndex() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            var result: T   = T.zero
            var expectation = T.Magnitude.zero
            let range = 0 ..< IX(size: T.self)
            
            Test().same(result, T(repeating: Bit.zero))
            
            for index: IX in range {
                expectation <<= T.Magnitude.lsb
                expectation  |= T.Magnitude.lsb
                result[Shift(Count(index))].toggle()
                Test().same(result, T(raw: expectation))
            }
            
            Test().same(result, T(repeating: Bit.one))
            
            for index: IX in range {
                expectation <<= T.Magnitude.lsb
                result[Shift(Count(index))].toggle()
                Test().same(result, T(raw: expectation))
            }
            
            Test().same(result, T(repeating: Bit.zero))
            
            for index: IX in range.reversed() {
                expectation >>= T.Magnitude.lsb
                expectation  |= T.Magnitude.msb
                result[Shift(Count(index))].toggle()
                Test().same(result, T(raw: expectation))
            }
            
            Test().same(result, T(repeating: Bit.one))
            
            for index: IX in range.reversed() {
                expectation >>= T.Magnitude.lsb
                result[Shift(Count(index))].toggle()
                Test().same(result, T(raw: expectation))
            }
            
            Test().same(result, T(repeating: Bit.zero))
        }
        
        for type in systemsIntegers {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Random
    //=------------------------------------------------------------------------=
    
    func testOperationsByFuzzing() {
        func whereIs<T>(_ type: T.Type, size: IX, rounds: IX, randomness: consuming FuzzerInt) where T: BinaryInteger {
            func random() -> T {
                let index = IX.random(in: 00000 ..< size, using: &randomness)!
                let pattern = T.Signitude.random(through: Shift(Count(index)), using: &randomness)
                return T(raw: pattern) // do not forget about infinite values!
            }
            
            for _ in 0 ..< rounds {
                let a0 = random()
                let a1 = a0.toggled()
                let b0 = random()
                let b1 = b0.toggled()
                
                always: do {
                    Test().same(a0, a1.toggled())
                    Test().same(b0, b1.toggled())
                }

                always: do {
                    let c0 = a0 ^ b0
                    let c1 = c0.toggled()
                    
                    Test().same((c0 ^ a0), (b0))
                    Test().same((c0 ^ b0), (a0))
                    Test().same((c0 ^ a1), (b1))
                    Test().same((c0 ^ b1), (a1))
                    
                    Test().same((a0 ^ b0), (c0))
                    Test().same((a0 ^ b1), (c1))
                    Test().same((a1 ^ b0), (c1))
                    Test().same((a1 ^ b1), (c0))
                }
                
                always: do {
                    let c0 = a0 | b0
                    let c1 = c0.toggled()
                    
                    Test().same((c0 ^ a0), (b0 & a1))
                    Test().same((c0 ^ b0), (a0 & b1))
                    Test().same((c1 ^ a0), (b0 & a1).toggled())
                    Test().same((c1 ^ b0), (a0 & b1).toggled())
                }
            }
        }
        
        for type in binaryIntegers {
            whereIs(type, size: IX(size: type) ?? 256, rounds: 32, randomness: fuzzer)
        }
    }
}
