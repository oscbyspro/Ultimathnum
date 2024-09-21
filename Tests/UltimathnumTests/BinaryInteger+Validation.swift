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
// MARK: * Binary Integer x Validation
//*============================================================================*

final class BinaryIntegerTestsOnValidation: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testExactlySameSizeIntegers() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            typealias S = T.Signitude
            typealias M = T.Magnitude
            
            Test().exactly( Esque<S>.min, Fallible( T(raw: Esque<S>.min), error: !T.isSigned))
            Test().exactly( Esque<S>.lsb, Fallible( T(raw: Esque<S>.lsb)))
            Test().exactly( Esque<S>.msb, Fallible( T(raw: Esque<S>.msb), error: !T.isSigned))
            Test().exactly( Esque<S>.max, Fallible( T(raw: Esque<S>.max)))
            
            Test().exactly(~Esque<S>.min, Fallible(~T(raw: Esque<S>.min)))
            Test().exactly(~Esque<S>.lsb, Fallible(~T(raw: Esque<S>.lsb), error: !T.isSigned))
            Test().exactly(~Esque<S>.msb, Fallible(~T(raw: Esque<S>.msb)))
            Test().exactly(~Esque<S>.max, Fallible(~T(raw: Esque<S>.max), error: !T.isSigned))
            
            Test().exactly( Esque<M>.min, Fallible( T(raw: Esque<M>.min)))
            Test().exactly( Esque<M>.lsb, Fallible( T(raw: Esque<M>.lsb)))
            Test().exactly( Esque<M>.msb, Fallible( T(raw: Esque<M>.msb), error:  T.isSigned && !T.isArbitrary))
            Test().exactly( Esque<M>.max, Fallible( T(raw: Esque<M>.max), error:  T.isSigned))
            
            Test().exactly(~Esque<M>.min, Fallible(~T(raw: Esque<M>.min), error:  T.isSigned))
            Test().exactly(~Esque<M>.lsb, Fallible(~T(raw: Esque<M>.lsb), error:  T.isSigned))
            Test().exactly(~Esque<M>.msb, Fallible(~T(raw: Esque<M>.msb), error: !T.isEdgy))
            Test().exactly(~Esque<M>.max, Fallible(~T(raw: Esque<M>.max)))
            
            if  T.isSigned, !T.isArbitrary {
                Test().exactly(Esque<M>.msb,     Fallible(Esque<T>.msb,     error: true))
                Test().exactly(Esque<M>.msb + 1, Fallible(Esque<T>.msb + 1, error: true))
            }
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testExactlySystemsInteger() {
        func whereTheSourceIs<T, U>(source: T.Type, destination: U.Type) where T: SystemsInteger, U: BinaryInteger {
            //=----------------------------------=
            // path: about T.max as U
            //=----------------------------------=
            if  U.size < T.size || (U.size == T.size && (U.isSigned, T.isSigned) != (false, true)) {
                let max: U = Esque<U>.max
                let maxAsOther: T = T(repeating: Bit.one) << T(load: UX(size: U.self)! - UX(Bit(U.isSigned))) ^ T(repeating: Bit.one)
                
                Test().exactly(maxAsOther &- 2, Fallible(max &- 2))
                Test().exactly(maxAsOther &- 1, Fallible(max &- 1))
                Test().exactly(maxAsOther,      Fallible(max     ))
                Test().exactly(maxAsOther &+ 1, Fallible(max &+ 1, error: U.size < T.size || (U.isSigned != T.isSigned)))
                Test().exactly(maxAsOther &+ 2, Fallible(max &+ 2, error: U.size < T.size || (U.isSigned != T.isSigned)))
            }   else {
                Test().exactly(Esque<U>.max, Fallible(T(repeating: Bit.one), error: true))
            }
        }
        
        func whereTheSourceIsIsSigned<T, U>(source: T.Type, destination: U.Type) where T: SystemsInteger & SignedInteger, U: BinaryInteger {
            let size = UX(size: T.self)
            //=----------------------------------=
            // path: about U.zero
            //=----------------------------------=
            always: do {
                let load = U.zero
                Test().exactly(T(repeating: Bit.zero) - 2, Fallible(load &- 2, error: !U.isSigned))
                Test().exactly(T(repeating: Bit.zero) - 1, Fallible(load &- 1, error: !U.isSigned))
                Test().exactly(T(repeating: Bit.zero),     Fallible(load     ))
                Test().exactly(T(repeating: Bit.zero) + 1, Fallible(load &+ 1))
                Test().exactly(T(repeating: Bit.zero) + 2, Fallible(load &+ 2))
            }
            //=----------------------------------=
            // path: about U.min
            //=----------------------------------=
            always: do {
                let load = U(repeating: Bit.one) << (size - 1)
                Test().exactly(T.min,      Fallible(load,      error: U.size < T.size || !U.isSigned))
                Test().exactly(T.min &+ 1, Fallible(load &+ 1, error: U.size < T.size || !U.isSigned))
                Test().exactly(T.min &+ 2, Fallible(load &+ 2, error: U.size < T.size || !U.isSigned))
            }
            //=----------------------------------=
            // path: about U.max
            //=----------------------------------=
            always: do {
                let load = U(repeating: Bit.one) << (size - 1) ^ U(repeating: Bit.one)
                Test().exactly(T.max,      Fallible(load,      error: U.size < T.size))
                Test().exactly(T.max &- 1, Fallible(load &- 1, error: U.size < T.size))
                Test().exactly(T.max &- 2, Fallible(load &- 2, error: U.size < T.size))
            }
            //=----------------------------------=
            // path: about T.min as U
            //=----------------------------------=
            if  U.isSigned, U.size <= T.size {
                let min: U = Esque<U>.min
                let minAsOther: T = T(repeating: Bit.one) << T(load: UX(size: U.self)! - 1)
                
                Test().exactly(minAsOther &- 2, Fallible(min &- 2, error: U.size < T.size))
                Test().exactly(minAsOther &- 1, Fallible(min &- 1, error: U.size < T.size))
                Test().exactly(minAsOther,      Fallible(min     ))
                Test().exactly(minAsOther &+ 1, Fallible(min &+ 1))
                Test().exactly(minAsOther &+ 2, Fallible(min &+ 2))
            }
        }
        
        func whereTheSourceIsUnsigned<T, U>(source: T.Type, destination: U.Type) where T: SystemsInteger & UnsignedInteger, U: BinaryInteger {
            let size = UX(size: T.self)
            //=----------------------------------=
            // path: about U.min
            //=----------------------------------=
            always: do {
                let load = U.zero
                Test().exactly(T(repeating: Bit.zero),     Fallible(load    ))
                Test().exactly(T(repeating: Bit.zero) + 1, Fallible(load + 1))
                Test().exactly(T(repeating: Bit.zero) + 2, Fallible(load + 2))
            }
            //=----------------------------------=
            // path: about U.max
            //=----------------------------------=
            always: do {
                let load = U(repeating: Bit.one) << size ^ U(repeating: Bit.one)
                Test().exactly(T(repeating: Bit.one) - 2, Fallible(load - 2, error: U.size < T.size || (U.isSigned && U.size == T.size)))
                Test().exactly(T(repeating: Bit.one) - 1, Fallible(load - 1, error: U.size < T.size || (U.isSigned && U.size == T.size)))
                Test().exactly(T(repeating: Bit.one),     Fallible(load,     error: U.size < T.size || (U.isSigned && U.size == T.size)))
            }
            //=----------------------------------=
            // path: about U.msb
            //=----------------------------------=
            always: do {
                let load = U(1) << (size - 1)
                Test().exactly(T.msb - 2, Fallible(load &- 2, error: U.size < T.size))
                Test().exactly(T.msb - 1, Fallible(load &- 1, error: U.size < T.size))
                Test().exactly(T.msb,     Fallible(load,      error: U.size < T.size || (U.isSigned && U.size == T.size)))
                Test().exactly(T.msb + 1, Fallible(load &+ 1, error: U.size < T.size || (U.isSigned && U.size == T.size)))
                Test().exactly(T.msb + 2, Fallible(load &+ 2, error: U.size < T.size || (U.isSigned && U.size == T.size)))
            }
        }
        
        for destination in binaryIntegers {
            for source in systemsIntegers {
                whereTheSourceIs(source: source, destination: destination)
            }
            
            for source in systemsIntegersWhereIsSigned {
                whereTheSourceIsIsSigned(source: source, destination: destination)
            }
            
            for source in systemsIntegersWhereIsUnsigned {
                whereTheSourceIsUnsigned(source: source, destination: destination)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// Tests binary integer conversions for sequences of descending 0s.
    ///
    ///     11111111111111111111111111111110 != 1s
    ///     11111111111111111111111111111100
    ///     11111111111111111111111111111000
    ///     ................................
    ///     11000000000000000000000000000000
    ///     10000000000000000000000000000000
    ///     00000000000000000000000000000000
    ///
    func testExactlySystemsIntegerRainOf0s() {
        /// Tests the sequence in reverse order because it's easier.
        func whereIs<T, U>(source: T.Type, destination: U.Type) where T: SystemsInteger, U: BinaryInteger {
            var lhs = T.zero
            var rhs = U.zero
            
            for ones in 0 ..< IX(size: T.self) {
                Test().ascending(lhs, Bit.one, Count(ones))
                Test().exactly(lhs, Fallible(rhs, error: U.isSigned ? U.size <= Count(ones) : U.size < Count(ones)))
                
                lhs <<= 1
                lhs  |= 1
                rhs <<= 1
                rhs  |= 1
            }
        }
        
        for destination in binaryIntegers {
            #if DEBUG
            whereIs(source: I32.self, destination: destination)
            whereIs(source: U32.self, destination: destination)
            #else
            for source in systemsIntegers {
                whereIs(source: source, destination: destination)
            }
            #endif
        }
    }
    
    /// Tests binary integer conversions for sequences of descending 1s.
    ///
    ///     00000000000000000000000000000001 != 0s
    ///     00000000000000000000000000000011
    ///     00000000000000000000000000000111
    ///     ................................
    ///     00111111111111111111111111111111
    ///     01111111111111111111111111111111
    ///     11111111111111111111111111111111
    ///
    func testExactlySystemsIntegerRainOf1s() {
        /// Tests the sequence in reverse order because it's easier.
        func whereIs<T, U>(source: T.Type, destination: U.Type) where T: SystemsInteger, U: BinaryInteger {
            var mask = U(repeating: Bit.one)
            
            if !T.isSigned {
                mask = mask.up(T.size).toggled()
            }
            
            always: do {
                var lhs = T(repeating: Bit.one)
                var rhs = U(repeating: Bit.one)
                
                for zeros in 0 ..< IX(size: T.self) {
                    let error = switch (U.isSigned, T.isSigned) {
                    case (true,  true ): U.size <= Count(zeros)
                    case (true,  false): U.size <= T.size
                    case (false, true ): ((((((true))))))
                    case (false, false): U.size <  T.size
                    }
                    
                    Test().ascending(lhs, Bit.zero, Count(zeros))
                    Test().exactly(lhs, Fallible(rhs & mask, error: error))
                    lhs <<= 1
                    rhs <<= 1
                }
            }
        }
        
        for destination in binaryIntegers {
            #if DEBUG
            whereIs(source: I32.self, destination: destination)
            whereIs(source: U32.self, destination: destination)
            #else
            for source in systemsIntegers {
                whereIs(source: source, destination: destination)
            }
            #endif
        }
    }
    
    /// Tests binary integer conversions for various slices of 0s.
    ///
    ///     00001111111111111111111111111111
    ///     10000111111111111111111111111111
    ///     11000011111111111111111111111111
    ///     ................................
    ///     11111111111111111111111111000011
    ///     11111111111111111111111111100001
    ///     11111111111111111111111111110000
    ///
    func testExactlySystemsIntegerSlicesOf0s() {
        func whereIs<T, U>(source: T.Type, destination: U.Type) where T: SystemsInteger, U: BinaryInteger {
            always: do {
                let patterns: [IX] = [~1, ~3, ~7, ~15]
                var mask = U(repeating: Bit.one)
                
                if !T.isSigned {
                    mask = mask.up(T.size).toggled()
                }
                
                for zeros in 1 ... IX(patterns.count) {
                    var ones: IX = 0
                    var lhs = T(load: patterns[Int(zeros - 1)])
                    var rhs = U(load: patterns[Int(zeros - 1)])
                    
                    forwards: while ones + zeros < IX(size: T.self) {
                        let error = switch (U.isSigned, T.isSigned) {
                        case (true,  true ): U.size <= Count(ones + zeros)
                        case (true,  false): U.size <= T.size
                        case (false, true ):   true
                        case (false, false): U.size <  T.size
                        }
                        
                        Test().exactly(lhs, Fallible(rhs & mask, error: error))
                        ones += 1
                        lhs <<= 1
                        lhs  |= 1
                        rhs <<= 1
                        rhs  |= 1
                    }
                    
                    Test().same(IX(size:    T.self), ones + zeros)
                    Test().descending(lhs, Bit.zero, Count(zeros))
                    
                    last: do {
                        let value = rhs & U(load: T.Magnitude(repeating: Bit.one))
                        let error = U.isSigned ? U.size <= Count(ones) : U.size < Count(ones)
                        Test().exactly(lhs, Fallible(value, error: error))
                    }
                }
            }
        }
        
        for destination in binaryIntegers {
            #if DEBUG
            whereIs(source: I32.self, destination: destination)
            whereIs(source: U32.self, destination: destination)
            #else
            for source in systemsIntegers {
                whereIs(source: source, destination: destination)
            }
            #endif
        }
    }
    
    /// Tests binary integer conversions for various slices of 1s.
    ///
    ///     11110000000000000000000000000000
    ///     01111000000000000000000000000000
    ///     00111100000000000000000000000000
    ///     ................................
    ///     00000000000000000000000000111100
    ///     00000000000000000000000000011110
    ///     00000000000000000000000000001111
    ///
    func testExactlySystemsIntegerSlicesOf1s() {
        func whereIs<T, U>(source: T.Type, destination: U.Type) where T: SystemsInteger, U: BinaryInteger {
            always: do {
                let patterns: [UX] = [1, 3, 7, 15]
                let mask = U(load: T.Magnitude(repeating: Bit.one))
                
                for ones in 1 ... IX(patterns.count) {
                    var zeros = IX()
                    var lhs = T(load: patterns[Int(ones - 1)])
                    var rhs = U(load: patterns[Int(ones - 1)])
                    
                    forwards: while zeros + ones < IX(size: T.self) {
                        let sum = Count(zeros + ones)
                        Test().exactly(lhs, Fallible(rhs & mask, error: U.isSigned ? U.size <= sum : U.size < sum))
                        zeros += 1
                        lhs  <<= 1
                        rhs  <<= 1
                    }
                    
                    Test().same(IX(size:   T.self), zeros + ones)
                    Test().descending(lhs, Bit.one, Count( ones))
                    
                    last: do {
                        let value = T.isSigned ? rhs ^ mask.toggled() : rhs & mask
                        let error = switch (U.isSigned, T.isSigned) {
                        case (true,  true ): U.size <  Count(zeros + ones)
                        case (true,  false): U.size <= Count(zeros + ones)
                        case (false, true ):   true
                        case (false, false): U.size <  Count(zeros + ones)
                        }
                        
                        Test().exactly(lhs, Fallible(value, error: error))
                    }
                }
            }
        }
        
        for destination in binaryIntegers {
            #if DEBUG
            whereIs(source: I32.self, destination: destination)
            whereIs(source: U32.self, destination: destination)
            #else
            for source in systemsIntegers {
                whereIs(source: source, destination: destination)
            }
            #endif
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Edge Cases
//=----------------------------------------------------------------------------=

extension BinaryIntegerTestsOnValidation {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// 2024-06-20: Signed systems integers should successfully clamp `∞`.
    func testSystemsIntegersCanClampInfiniteValues() {
        func whereIs<A, B>(_ source: A.Type, _ destination: B.Type) where A: ArbitraryInteger & UnsignedInteger, B: SystemsInteger {
            Test().same(B(clamping: A.max    ), B.max)
            Test().same(B(clamping: A.max - 1), B.max)
        }
        
        for source in arbitraryIntegersWhereIsUnsigned {
            for destination in systemsIntegers {
                whereIs(source, destination)
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension BinaryIntegerTestsOnValidation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testErrorPropagationMechanism() {
        func whereIs<A, B>(
            source: A.Type,
            destination: B.Type,
            size: IX,
            rounds: IX,
            randomness: consuming FuzzerInt
        ) where A: BinaryInteger, B: BinaryInteger {
            
            var success: IX = 0
            
            func random() -> A {
                let index = IX.random(in: 00000 ..< size, using: &randomness)!
                let pattern = A.Signitude.random(through: Shift(Count(index)), using: &randomness)
                return A(raw: pattern) // do not forget about infinite values!
            }
            
            for _ in 0 ..< rounds {
                let source: A = random()
                let destination =  B.exactly(source)
                success &+= IX(Bit(B.exactly(source.veto(false)) == destination))
                success &+= IX(Bit(B.exactly(source.veto(true )) == destination.veto()))
            }
            
            for _ in 0 ..< rounds {
                let sign = Sign(Bool.random(using: &randomness.stdlib))
                let magnitude = A.Magnitude(raw: random())
                let destination =  B.exactly(sign: sign, magnitude: magnitude)
                success &+= IX(Bit(B.exactly(sign: sign, magnitude: magnitude.veto(false)) == destination))
                success &+= IX(Bit(B.exactly(sign: sign, magnitude: magnitude.veto(true )) == destination.veto()))
            }
            
            Test().same(success, rounds &* 4)
        }
        
        #if DEBUG
        let rounds: IX = 08
        #else
        let rounds: IX = 32
        #endif
        for source in binaryIntegers {
            for destination in binaryIntegers {
                let size =  IX(size: source) ?? 256
                whereIs(
                    source:      source,
                    destination: destination,
                    size:        size,
                    rounds:      rounds,
                    randomness:  fuzzer
                )
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Validation x Stdlib
//*============================================================================*

final class BinaryIntegerTestsOnValidationOfStdlib: XCTestCase {
    
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
