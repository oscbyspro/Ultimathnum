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
        
        for type in typesAsBinaryInteger {
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
        
        for destination in typesAsBinaryInteger {
            for source in typesAsSystemsInteger {
                whereTheSourceIs(source: source, destination: destination)
            }
            
            for source in typesAsSystemsIntegerAsSigned {
                whereTheSourceIsIsSigned(source: source, destination: destination)
            }
            
            for source in typesAsSystemsIntegerAsUnsigned {
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
        
        for destination in typesAsBinaryInteger {
            #if DEBUG
            whereIs(source: I32.self, destination: destination)
            whereIs(source: U32.self, destination: destination)
            #else
            for source in typesAsSystemsInteger {
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
        
        for destination in typesAsBinaryInteger {
            #if DEBUG
            whereIs(source: I32.self, destination: destination)
            whereIs(source: U32.self, destination: destination)
            #else
            for source in typesAsSystemsInteger {
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
    func testExactlytypesAsSystemsIntegerlicesOf0s() {
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
        
        for destination in typesAsBinaryInteger {
            #if DEBUG
            whereIs(source: I32.self, destination: destination)
            whereIs(source: U32.self, destination: destination)
            #else
            for source in typesAsSystemsInteger {
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
    func testExactlytypesAsSystemsIntegerlicesOf1s() {
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
        
        for destination in typesAsBinaryInteger {
            #if DEBUG
            whereIs(source: I32.self, destination: destination)
            whereIs(source: U32.self, destination: destination)
            #else
            for source in typesAsSystemsInteger {
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
    func testtypesAsSystemsIntegerCanClampInfiniteValues() {
        func whereIs<A, B>(_ source: A.Type, _ destination: B.Type) where A: ArbitraryInteger & UnsignedInteger, B: SystemsInteger {
            Test().same(B(clamping: A.max    ), B.max)
            Test().same(B(clamping: A.max - 1), B.max)
        }
        
        for source in typesAsArbitraryIntegerAsUnsigned {
            for destination in typesAsSystemsInteger {
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
        for source in typesAsBinaryInteger {
            for destination in typesAsBinaryInteger {
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
