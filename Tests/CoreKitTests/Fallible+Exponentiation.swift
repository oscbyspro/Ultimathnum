//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Fallible x Exponentiation
//*============================================================================*

extension FallibleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBinaryIntegerExponentiation() {
        func whereIs<T>(_ type: T.Type, rounds: IX, randomness: consuming FuzzerInt) where T: SystemsInteger {
            var success: IX = 0
            
            for _ in 0 ..< rounds {
                let base = T.random()
                let exponent = Natural(T.random(in: 0...T.max))
                let expectation: Fallible<T> = base.power(exponent)
                success &+= IX(Bit(base            .power(exponent) == expectation))
                success &+= IX(Bit(base.veto(false).power(exponent) == expectation))
                success &+= IX(Bit(base.veto(true ).power(exponent) == expectation.veto()))
            }
            
            Test().same(success, rounds &* 3)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type, rounds: IX, randomness: consuming FuzzerInt) where T: SystemsInteger & UnsignedInteger {
            var success: IX = 0
            
            for _ in 0 ..< rounds {
                let base = T.random()
                let exponent = T.random(in: 0...T.max)
                let expectation: Fallible<T> = base.power(exponent)
                success &+= IX(Bit(base            .power(exponent)             == expectation))
                success &+= IX(Bit(base            .power(exponent.veto(false)) == expectation))
                success &+= IX(Bit(base            .power(exponent.veto(true )) == expectation.veto()))
                success &+= IX(Bit(base.veto(false).power(exponent)             == expectation))
                success &+= IX(Bit(base.veto(false).power(exponent.veto(false)) == expectation))
                success &+= IX(Bit(base.veto(false).power(exponent.veto(true )) == expectation.veto()))
                success &+= IX(Bit(base.veto(true ).power(exponent)             == expectation.veto()))
                success &+= IX(Bit(base.veto(true ).power(exponent.veto(false)) == expectation.veto()))
                success &+= IX(Bit(base.veto(true ).power(exponent.veto(true )) == expectation.veto()))
            }
            
            Test().same(success, rounds &* 9)
        }
        
        whereIs(I8.self,         rounds: 1024, randomness: fuzzer)
        whereIs(U8.self,         rounds: 1024, randomness: fuzzer)
        whereIsUnsigned(U8.self, rounds: 1024, randomness: fuzzer)
    }
}
