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
import TestKit

//*============================================================================*
// MARK: * Infini Int x Multiplication
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplicationOfSmallBySmall() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            typealias F = Fallible<T>
            //=----------------------------------=
            Test().multiplication(~2 as T, ~2 as T, F( 9 as T, error: !T.isSigned))
            Test().multiplication(~2 as T, ~1 as T, F( 6 as T, error: !T.isSigned))
            Test().multiplication(~2 as T, ~0 as T, F( 3 as T, error: !T.isSigned))
            Test().multiplication(~2 as T,  0 as T, F( 0 as T))
            Test().multiplication(~2 as T,  1 as T, F(~2 as T))
            Test().multiplication(~2 as T,  2 as T, F(~5 as T, error: !T.isSigned))
            Test().multiplication(~2 as T,  3 as T, F(~8 as T, error: !T.isSigned))
            
            Test().multiplication(~1 as T, ~2 as T, F( 6 as T, error: !T.isSigned))
            Test().multiplication(~1 as T, ~1 as T, F( 4 as T, error: !T.isSigned))
            Test().multiplication(~1 as T, ~0 as T, F( 2 as T, error: !T.isSigned))
            Test().multiplication(~1 as T,  0 as T, F( 0 as T))
            Test().multiplication(~1 as T,  1 as T, F(~1 as T))
            Test().multiplication(~1 as T,  2 as T, F(~3 as T, error: !T.isSigned))
            Test().multiplication(~1 as T,  3 as T, F(~5 as T, error: !T.isSigned))
            
            Test().multiplication(~0 as T, ~2 as T, F( 3 as T, error: !T.isSigned))
            Test().multiplication(~0 as T, ~1 as T, F( 2 as T, error: !T.isSigned))
            Test().multiplication(~0 as T, ~0 as T, F( 1 as T, error: !T.isSigned))
            Test().multiplication(~0 as T,  0 as T, F( 0 as T))
            Test().multiplication(~0 as T,  1 as T, F(~0 as T))
            Test().multiplication(~0 as T,  2 as T, F(~1 as T, error: !T.isSigned))
            Test().multiplication(~0 as T,  3 as T, F(~2 as T, error: !T.isSigned))
            
            Test().multiplication( 0 as T, ~2 as T, F( 0 as T))
            Test().multiplication( 0 as T, ~1 as T, F( 0 as T))
            Test().multiplication( 0 as T, ~0 as T, F( 0 as T))
            Test().multiplication( 0 as T,  0 as T, F( 0 as T))
            Test().multiplication( 0 as T,  1 as T, F( 0 as T))
            Test().multiplication( 0 as T,  2 as T, F( 0 as T))
            Test().multiplication( 0 as T,  3 as T, F( 0 as T))
            
            Test().multiplication( 1 as T, ~2 as T, F(~2 as T))
            Test().multiplication( 1 as T, ~1 as T, F(~1 as T))
            Test().multiplication( 1 as T, ~0 as T, F(~0 as T))
            Test().multiplication( 1 as T,  0 as T, F( 0 as T))
            Test().multiplication( 1 as T,  1 as T, F( 1 as T))
            Test().multiplication( 1 as T,  2 as T, F( 2 as T))
            Test().multiplication( 1 as T,  3 as T, F( 3 as T))
            
            Test().multiplication( 2 as T, ~2 as T, F(~5 as T, error: !T.isSigned))
            Test().multiplication( 2 as T, ~1 as T, F(~3 as T, error: !T.isSigned))
            Test().multiplication( 2 as T, ~0 as T, F(~1 as T, error: !T.isSigned))
            Test().multiplication( 2 as T,  0 as T, F( 0 as T))
            Test().multiplication( 2 as T,  1 as T, F( 2 as T))
            Test().multiplication( 2 as T,  2 as T, F( 4 as T))
            Test().multiplication( 2 as T,  3 as T, F( 6 as T))
            
            Test().multiplication( 3 as T, ~2 as T, F(~8 as T, error: !T.isSigned))
            Test().multiplication( 3 as T, ~1 as T, F(~5 as T, error: !T.isSigned))
            Test().multiplication( 3 as T, ~0 as T, F(~2 as T, error: !T.isSigned))
            Test().multiplication( 3 as T,  0 as T, F( 0 as T))
            Test().multiplication( 3 as T,  1 as T, F( 3 as T))
            Test().multiplication( 3 as T,  2 as T, F( 6 as T))
            Test().multiplication( 3 as T,  3 as T, F( 9 as T))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testMultiplicationOfLargeBySmall() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            typealias F = Fallible<T>
            //=----------------------------------=
            let a1234 = T([1, 2, 3, 4] as [UX], repeating: 0)
            let a5678 = T([5, 6, 7, 8] as [UX], repeating: 0)
            //=----------------------------------=
            Test().multiplication( a1234,  5 as T, F(T([ 05,  10,  15,  20,  00] as [UX], repeating: 0)))
            Test().multiplication( a1234, ~5 as T, F(T([~05, ~12, ~18, ~24, ~00] as [UX], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a1234,  5 as T, F(T([~09, ~10, ~15, ~20, ~00] as [UX], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a1234, ~5 as T, F(T([ 12,  12,  18,  24,  00] as [UX], repeating: 0), error: !T.isSigned))
            
            Test().multiplication( a5678,  5 as T, F(T([ 25,  30,  35,  40,  00] as [UX], repeating: 0)))
            Test().multiplication( a5678, ~5 as T, F(T([~29, ~36, ~42, ~48, ~00] as [UX], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a5678,  5 as T, F(T([~29, ~30, ~35, ~40, ~00] as [UX], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a5678, ~5 as T, F(T([ 36,  36,  42,  48,  00] as [UX], repeating: 0), error: !T.isSigned))
            //=----------------------------------=
            let b1234 = T([1, 2, 3, 4] as [UX], repeating: 1)
            let b5678 = T([5, 6, 7, 8] as [UX], repeating: 1)
            //=----------------------------------=
            Test().multiplication( b1234,  5 as T, F(T([ 05,  10,  15,  20, ~04] as [UX], repeating: 1), error: !T.isSigned))
            Test().multiplication( b1234, ~5 as T, F(T([~05, ~12, ~18, ~24,  05] as [UX], repeating: 0), error: !T.isSigned))
            Test().multiplication(~b1234,  5 as T, F(T([~09, ~10, ~15, ~20,  04] as [UX], repeating: 0)))
            Test().multiplication(~b1234, ~5 as T, F(T([ 12,  12,  18,  24, ~05] as [UX], repeating: 1), error: !T.isSigned))
            
            Test().multiplication( b5678,  5 as T, F(T([ 25,  30,  35,  40, ~04] as [UX], repeating: 1), error: !T.isSigned))
            Test().multiplication( b5678, ~5 as T, F(T([~29, ~36, ~42, ~48,  05] as [UX], repeating: 0), error: !T.isSigned))
            Test().multiplication(~b5678,  5 as T, F(T([~29, ~30, ~35, ~40,  04] as [UX], repeating: 0)))
            Test().multiplication(~b5678, ~5 as T, F(T([ 36,  36,  42,  48, ~05] as [UX], repeating: 1), error: !T.isSigned))
            //=----------------------------------=
            for number in [a1234, ~a1234, b1234, ~b1234, a5678, ~a5678, b5678, ~b5678] {
                Test().multiplication(number, ~0 as T, F(number.complement(), error: !T.isSigned))
                Test().multiplication(number,  0 as T, F(0 as T))
                Test().multiplication(number,  1 as T, F(number))
            }
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testMultiplicationOfLargeByLarge() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            typealias F = Fallible<T>
            //=----------------------------------=
            let a1234 = T([1, 2, 3, 4] as [UX], repeating: 0)
            let a5678 = T([5, 6, 7, 8] as [UX], repeating: 0)
            //=----------------------------------=
            Test().multiplication( a1234,  a1234, F(T([ 001,  004,  010,  020,  025,  024,  016,  000] as [UX], repeating: 0)))
            Test().multiplication( a1234, ~a1234, F(T([~001, ~006, ~013, ~024, ~025, ~024, ~016, ~000] as [UX], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a1234, ~a1234, F(T([ 004,  008,  016,  028,  025,  024,  016,  000] as [UX], repeating: 0), error: !T.isSigned))
            
            Test().multiplication( a1234,  a5678, F(T([ 005,  016,  034,  060,  061,  052,  032,  000] as [UX], repeating: 0)))
            Test().multiplication( a1234, ~a5678, F(T([~005, ~018, ~037, ~064, ~061, ~052, ~032, ~000] as [UX], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a1234,  a5678, F(T([~009, ~022, ~041, ~068, ~061, ~052, ~032, ~000] as [UX], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a1234, ~a5678, F(T([ 012,  024,  044,  072,  061,  052,  032,  000] as [UX], repeating: 0), error: !T.isSigned))
            
            Test().multiplication( a5678,  a5678, F(T([ 025,  060,  106,  164,  145,  112,  064,  000] as [UX], repeating: 0)))
            Test().multiplication( a5678, ~a5678, F(T([~029, ~066, ~113, ~172, ~145, ~112, ~064, ~000] as [UX], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a5678, ~a5678, F(T([ 036,  072,  120,  180,  145,  112,  064,  000] as [UX], repeating: 0), error: !T.isSigned))
            //=----------------------------------=
            let b1234 = T([1, 2, 3, 4] as [UX], repeating: 1)
            let b5678 = T([5, 6, 7, 8] as [UX], repeating: 1)
            //=----------------------------------=
            Test().multiplication( b1234,  b1234, F(T([ 001,  004,  010,  020,  023,  020,  010, ~007] as [UX], repeating: 0), error: !T.isSigned))
            Test().multiplication( b1234, ~b1234, F(T([~001, ~006, ~013, ~024, ~022, ~020, ~010,  007] as [UX], repeating: 1), error: !T.isSigned))
            Test().multiplication(~b1234, ~b1234, F(T([ 004,  008,  016,  028,  021,  020,  010, ~007] as [UX], repeating: 0)))
            
            Test().multiplication( b1234,  b5678, F(T([ 005,  016,  034,  060,  055,  044,  022, ~011] as [UX], repeating: 0), error: !T.isSigned))
            Test().multiplication( b1234, ~b5678, F(T([~005, ~018, ~037, ~064, ~054, ~044, ~022,  011] as [UX], repeating: 1), error: !T.isSigned))
            Test().multiplication(~b1234,  b5678, F(T([~009, ~022, ~041, ~068, ~054, ~044, ~022,  011] as [UX], repeating: 1), error: !T.isSigned))
            Test().multiplication(~b1234, ~b5678, F(T([ 012,  024,  044,  072,  053,  044,  022, ~011] as [UX], repeating: 0)))
            
            Test().multiplication( b5678,  b5678, F(T([ 025,  060,  106,  164,  135,  100,  050, ~015] as [UX], repeating: 0), error: !T.isSigned))
            Test().multiplication( b5678, ~b5678, F(T([~029, ~066, ~113, ~172, ~134, ~100, ~050,  015] as [UX], repeating: 1), error: !T.isSigned))
            Test().multiplication(~b5678, ~b5678, F(T([ 036,  072,  120,  180,  133,  100,  050, ~015] as [UX], repeating: 0)))
            //=----------------------------------=
            let x0000 = T([~0, ~0, ~0, ~0] as [UX], repeating: 0)
            //=----------------------------------=
            Test().multiplication( x0000,  x0000, F(T([ 001,  000,  000,  000, ~001, ~000, ~000, ~000] as [UX] + [ 0] as [UX], repeating: 0)))
            Test().multiplication( x0000, ~x0000, F(T([ 000,  000,  000,  000,  001,  000,  000,  000] as [UX] + [~0] as [UX], repeating: 1), error: !T.isSigned))
            Test().multiplication(~x0000, ~x0000, F(T([ 000,  000,  000,  000,  000,  000,  000,  000] as [UX] + [ 1] as [UX], repeating: 0), error: !T.isSigned))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Code Coverage
//=----------------------------------------------------------------------------=

extension InfiniIntTests {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    ///  https://www.wolframalpha.com/input?i=y%3Dx%5E144%2C+x%3Dproduct+prime%28i%29%2C+i%3D1..54
    func testMultiplicationByBytePrimeComposite() throws {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            let small: T = primes54.lazy.map(T.init).reduce(1, *)
            let large: T = Array.init(repeating: small, count: 143).reduce(small, &*)
            Test().same(small,  Array(repeating: small, count: 143).reduce(large, /))
            Test().same(large,  Array(repeating: small.complement(), count: 144).reduce(1, &*))
        }
        
        #if DEBUG
        throw XCTSkip("req. release mode")
        #else
        whereIs(InfiniInt<IX>.self)
        whereIs(InfiniInt<UX>.self)
        #endif
    }
    
    func testMultiplicationLikeBigShift() {
        func whereIs<T, S>(_ type: T.Type, _ source: S.Type) where T: ArbitraryInteger, S: SystemsInteger & UnsignedInteger {
            //=----------------------------------=
            var lhs: T, rhs: T, pro: T
            //=----------------------------------=
            lhs = T((0 as S ..< 16).map({ $0 }))
            rhs = T([S](repeating: S.min, count: 16) + [1] as [S])
            pro = lhs << (16 * IX(size: S.self))
            
            Test().same(lhs.times(rhs), Fallible(pro))
            Test().same(rhs.times(lhs), Fallible(pro))
            #if !DEBUG
            Test().multiplication(lhs, rhs, Fallible(pro))
            #endif
        }
        
        for type in Self.types {
            for source in coreSystemsIntegersWhereIsUnsigned {
                whereIs(type, source)
            }
        }
    }
    
    func testMultiplicationLikeBigSystemsInteger() {
        func whereIs<T, S>(_ type: T.Type, _ source: S.Type) where T: ArbitraryInteger, S: SystemsInteger & UnsignedInteger {
            //=----------------------------------=
            var lhs: T, rhs: T, pro: T, array = [S]()
            //=----------------------------------=
            // imagine: (U16.max - 0) * (U16.max - 0)
            //=----------------------------------=
            lhs = T([S](repeating: S.max, count: 16))
            rhs = T([S](repeating: S.max, count: 16))
            pro = T([ 1] as [S] + [S](repeating:  0, count: 15) + [~1] as [S] + [S](repeating: ~0, count: 15))
            
            Test().same(lhs.times(rhs), Fallible(pro))
            Test().same(lhs.squared( ), Fallible(pro))
            #if !DEBUG
            Test().multiplication(lhs, rhs, Fallible(pro))
            #endif
            //=----------------------------------=
            // imagine: (U16.max - 0) * (U16.max - 1)
            //=----------------------------------=
            lhs = T([S](repeating: S.max, count: 16))
            rhs = T([~1] as [S] + [S](repeating: ~0, count: 15))
            pro = T([ 2] as [S] + [S](repeating:  0, count: 15) + [~2] as [S] + [S](repeating: ~0, count: 15))
            
            Test().same(lhs.times(rhs), Fallible(pro))
            Test().same(rhs.times(lhs), Fallible(pro))
            #if !DEBUG
            Test().multiplication(lhs, rhs, Fallible(pro))
            #endif
            //=----------------------------------=
            // imagine: (U16.max - 1) * (U16.max - 1)
            //=----------------------------------=
            array += [ 4] as [S]
            array += Array(repeating:  0, count: 15)
            array += [~3] as [S]
            array += Array(repeating: ~0, count: 15)

            lhs = T([~1] as [S] + [S](repeating: ~0, count: 15))
            rhs = T([~1] as [S] + [S](repeating: ~0, count: 15))
            pro = T(array)
            array.removeAll()
            
            Test().same(lhs.times(rhs), Fallible(pro))
            Test().same(lhs.squared( ), Fallible(pro))
            #if !DEBUG
            Test().multiplication(lhs, rhs, Fallible(pro))
            #endif
            //=----------------------------------=
            // imagine: (U16.max - 0) * (U8 .max - 0)
            //=----------------------------------=
            array += [ 1] as [S]
            array += Array(repeating:  0, count: 07)
            array += Array(repeating: ~0, count: 08)
            array += [~1] as [S]
            array += Array(repeating: ~0, count: 07)
            
            lhs = T([S](repeating: S.max, count: 16))
            rhs = T([S](repeating: S.max, count: 08))
            pro = T(array)
            array.removeAll()
            
            Test().same(lhs.times(rhs), Fallible(pro))
            Test().same(rhs.times(lhs), Fallible(pro))
            #if !DEBUG
            Test().multiplication(lhs, rhs, Fallible(pro))
            #endif
        }
        
        for type in Self.types {
            for source in coreSystemsIntegersWhereIsUnsigned {
                whereIs(type, source)
            }
        }
    }
    
    /// This checks all combinations for inputs in `I12.min...12.max`.
    ///
    /// - Note: Each product is compared against the result of addition.
    ///
    /// - Note: It uses 8-bit elements so some inputs use large storage.
    ///
    func testMultiplicationForEachSmallEntropyInRunnableRangeWhereElementIsByte() throws {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var success: (value: IX, error: IX)
            
            success.value = IX.zero
            success.error = IX.zero
            
            var major: (lhs: T, rhs: T, pro: T)
            var minor: (lhs: T, rhs: T, pro: T)
            
            major.lhs = T(load: I16.min >> 4)
            major.rhs = T(load: I16.min >> 4)
            major.pro = T(1) << 22
            
            let one = T(1)
            let r12 = (I16.min >> 4) ... (I16.max >> 4)
            
            for i in  r12 {
                minor.lhs = major.lhs
                minor.rhs = major.rhs
                minor.pro = major.pro
                
                for j in r12 {
                    let a = (i < 0) && (j != 0 && j != 1)
                    let b = (j < 0) && (i != 0 && i != 1)
                    
                    let product = minor.lhs.times(minor.rhs)
                    if  product.value == minor.pro {
                        success.value += 1
                    }
                    
                    if  product.error == (!T.isSigned && (a || b)) {
                        success.error += 1
                    }
                    
                    minor.rhs &+= one
                    minor.pro &+= minor.lhs
                }
                
                major.lhs &+= one
                major.pro &+= major.rhs
            }
            
            Test().same(success.value, 1 << 24)
            Test().same(success.error, 1 << 24)
        }
        
        #if DEBUG
        throw XCTSkip("req. release mode")
        #else
        whereIs(InfiniInt<I8>.self)
        whereIs(InfiniInt<U8>.self)
        
        whereIs(I64.self) // cf. InfiniInt<I8>.self
        whereIs(U64.self) // cf. InfiniInt<U8>.self
        #endif
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Edge Cases
//=----------------------------------------------------------------------------=

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// - 2024-05-22: Checks the small-storage multiplication path.
    func testMultiplicationBySmallStorageWhereBodyIsZerosAndAppendixIsOne() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger, T.Element.BitPattern == U8.BitPattern {
            compact: do {
                Test().multiplication(~T(I8.max),  000, Fallible( 00000))
                Test().multiplication(~T(I8.max),  100, Fallible(~12799, error: !T.isSigned))
                Test().multiplication(~T(I8.max), ~100, Fallible( 12928, error: !T.isSigned))
                Test().multiplication(~T(I8.max),  127, Fallible(~16255, error: !T.isSigned))
                Test().multiplication(~T(I8.max), ~127, Fallible( 16384, error: !T.isSigned))
            }
            
            extended: do {
                Test().multiplication(~T(U8.max),  000, Fallible( 00000)) // OK
                Test().multiplication(~T(U8.max),  100, Fallible(~25599, error: !T.isSigned)) // :(
                Test().multiplication(~T(U8.max), ~100, Fallible( 25856, error: !T.isSigned)) // :(
                Test().multiplication(~T(U8.max),  256, Fallible(~65535, error: !T.isSigned)) // :(
                Test().multiplication(~T(U8.max), ~256, Fallible( 65792, error: !T.isSigned)) // :(
            }
        }
        
        whereIs(InfiniInt<I8>.self)
        whereIs(InfiniInt<U8>.self)
    }
    
    /// - 2024-05-31: Checks the large-storage multiplication path.
    func testMultiplicationByLargeStorageWhereBodyIsZerosAndAppendixIsOne() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger, T.Element.BitPattern == U8.BitPattern {
            compact: do {
                let x16 = T(repeating: 1)  << 15
                Test().multiplication(x16, x16 - 1, Fallible((1 << 30) &- x16, error: !T.isSigned))
                Test().multiplication(x16, x16,     Fallible((1 << 30),        error: !T.isSigned))
                Test().multiplication(x16, x16 + 1, Fallible((1 << 30) &+ x16, error: !T.isSigned))
            }
            
            extended: do {
                let x16 = T(repeating: 1)  << 16
                Test().multiplication(x16, x16 - 1, Fallible((1 << 32) &- x16, error: !T.isSigned)) // OK
                Test().multiplication(x16, x16,     Fallible((1 << 32),        error: !T.isSigned)) // :(
                Test().multiplication(x16, x16 + 1, Fallible((1 << 32) &+ x16, error: !T.isSigned)) // OK
            }
        }
        
        whereIs(InfiniInt<I8>.self)
        whereIs(InfiniInt<U8>.self)
    }
    
    /// - Note: The algorithms may special-case ascending zeros like an upshift.
    func testMultiplicationByAscendingZeros() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            typealias F = Fallible<T>
            //=----------------------------------=
            let zeros: [[UX]] = (0 ..< 3).map({
                Array(repeating: UX.zero, count: $0)
            })
            
            for a: [UX] in zeros {
                
                let a0 = a + [ 1] as [UX]
                let a1 = a + [ 0] as [UX]
                let a2 = a + [~0] as [UX]
                let a3 = a + [~1] as [UX]
                
                for b: [UX] in zeros {
                    
                    let b0 = b + [ 1] as [UX]
                    let b1 = b + [ 0] as [UX]
                    let b2 = b + [~0] as [UX]
                    let b3 = b + [~1] as [UX]
                    
                    let c: [UX] = a + b
                    
                    Test().multiplication(T(a0, repeating: 0), T(b0, repeating: 0), F(T(c + [ 1        ] as [UX], repeating: 0)))
                    Test().multiplication(T(a1, repeating: 0), T(b1, repeating: 0), F(T(c + [ 0        ] as [UX], repeating: 0)))
                    Test().multiplication(T(a2, repeating: 0), T(b2, repeating: 0), F(T(c + [ 1, ~1    ] as [UX], repeating: 0)))
                    Test().multiplication(T(a3, repeating: 0), T(b3, repeating: 0), F(T(c + [ 4, ~3    ] as [UX], repeating: 0)))
                    
                    Test().multiplication(T(a0, repeating: 0), T(b0, repeating: 1), F(T(c + [ 1        ] as [UX], repeating: 1), error: !T.isSigned && a.count > 0))
                    Test().multiplication(T(a1, repeating: 0), T(b1, repeating: 1), F(T(c + [ 0        ] as [UX], repeating: 0)))
                    Test().multiplication(T(a2, repeating: 0), T(b2, repeating: 1), F(T(c + [ 1        ] as [UX], repeating: 1), error: !T.isSigned))
                    Test().multiplication(T(a3, repeating: 0), T(b3, repeating: 1), F(T(c + [ 4, ~1,   ] as [UX], repeating: 1), error: !T.isSigned))
                    
                    Test().multiplication(T(a0, repeating: 1), T(b0, repeating: 1), F(T(c + [ 1, ~1    ] as [UX], repeating: 0), error: !T.isSigned))
                    Test().multiplication(T(a1, repeating: 1), T(b1, repeating: 1), F(T(c + [ 0,  0,  1] as [UX], repeating: 0), error: !T.isSigned))
                    Test().multiplication(T(a2, repeating: 1), T(b2, repeating: 1), F(T(c + [ 1        ] as [UX], repeating: 0), error: !T.isSigned))
                    Test().multiplication(T(a3, repeating: 1), T(b3, repeating: 1), F(T(c + [ 4        ] as [UX], repeating: 0), error: !T.isSigned))
                }
            }
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Documentation
//=----------------------------------------------------------------------------=

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testReadmeMultiplicationDocumentationExamples() {
        Test().multiplication(U32.max, U32.max, Fallible(Doublet(low: 1, high: ~1), error: true))
        Test().multiplication(UXL.max, UXL.max, Fallible(Doublet(low: 1, high: ~1), error: true))
    }
}
