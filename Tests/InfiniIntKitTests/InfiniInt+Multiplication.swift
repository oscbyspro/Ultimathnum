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
        
    func testMultiplication() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            IntegerInvariants(T.self).multiplicationOfMsbEsque()
            IntegerInvariants(T.self).multiplicationOfRepeatingBit(BinaryIntegerID())
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testMultiplicationOfSmallBySmall() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias E = B.Element
            typealias L = E.Magnitude
            typealias T = InfiniInt<E>
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
        
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
    
    func testMultiplicationOfLargeBySmall() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias E = B.Element
            typealias L = E.Magnitude
            typealias T = InfiniInt<E>
            typealias F = Fallible<T>
            //=----------------------------------=
            let a1234 = T([1, 2, 3, 4] as [L], repeating: 0)
            let a5678 = T([5, 6, 7, 8] as [L], repeating: 0)
            //=----------------------------------=
            Test().multiplication( a1234,  5 as T, F(T([ 05,  10,  15,  20,  00] as [L], repeating: 0)))
            Test().multiplication( a1234, ~5 as T, F(T([~05, ~12, ~18, ~24, ~00] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a1234,  5 as T, F(T([~09, ~10, ~15, ~20, ~00] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a1234, ~5 as T, F(T([ 12,  12,  18,  24,  00] as [L], repeating: 0), error: !T.isSigned))
            
            Test().multiplication( a5678,  5 as T, F(T([ 25,  30,  35,  40,  00] as [L], repeating: 0)))
            Test().multiplication( a5678, ~5 as T, F(T([~29, ~36, ~42, ~48, ~00] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a5678,  5 as T, F(T([~29, ~30, ~35, ~40, ~00] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a5678, ~5 as T, F(T([ 36,  36,  42,  48,  00] as [L], repeating: 0), error: !T.isSigned))
            //=----------------------------------=
            let b1234 = T([1, 2, 3, 4] as [L], repeating: 1)
            let b5678 = T([5, 6, 7, 8] as [L], repeating: 1)
            //=----------------------------------=
            Test().multiplication( b1234,  5 as T, F(T([ 05,  10,  15,  20, ~04] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication( b1234, ~5 as T, F(T([~05, ~12, ~18, ~24,  05] as [L], repeating: 0), error: !T.isSigned))
            Test().multiplication(~b1234,  5 as T, F(T([~09, ~10, ~15, ~20,  04] as [L], repeating: 0)))
            Test().multiplication(~b1234, ~5 as T, F(T([ 12,  12,  18,  24, ~05] as [L], repeating: 1), error: !T.isSigned))
            
            Test().multiplication( b5678,  5 as T, F(T([ 25,  30,  35,  40, ~04] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication( b5678, ~5 as T, F(T([~29, ~36, ~42, ~48,  05] as [L], repeating: 0), error: !T.isSigned))
            Test().multiplication(~b5678,  5 as T, F(T([~29, ~30, ~35, ~40,  04] as [L], repeating: 0)))
            Test().multiplication(~b5678, ~5 as T, F(T([ 36,  36,  42,  48, ~05] as [L], repeating: 1), error: !T.isSigned))
            //=----------------------------------=
            for number in [a1234, ~a1234, b1234, ~b1234, a5678, ~a5678, b5678, ~b5678] {
                Test().multiplication(number, ~0 as T, F(number.complement(), error: !T.isSigned))
                Test().multiplication(number,  0 as T, F(0 as T))
                Test().multiplication(number,  1 as T, F(number))
            }
        }
                
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
    
    func testMultiplicationOfLargeByLarge() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias E = B.Element
            typealias L = E.Magnitude
            typealias T = InfiniInt<E>
            typealias F = Fallible<T>
            //=----------------------------------=
            let a1234 = T([1, 2, 3, 4] as [L], repeating: 0)
            let a5678 = T([5, 6, 7, 8] as [L], repeating: 0)
            //=----------------------------------=
            Test().multiplication( a1234,  a1234, F(T([ 001,  004,  010,  020,  025,  024,  016,  000] as [L], repeating: 0)))
            Test().multiplication( a1234, ~a1234, F(T([~001, ~006, ~013, ~024, ~025, ~024, ~016, ~000] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a1234,  a1234, F(T([~001, ~006, ~013, ~024, ~025, ~024, ~016, ~000] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a1234, ~a1234, F(T([ 004,  008,  016,  028,  025,  024,  016,  000] as [L], repeating: 0), error: !T.isSigned))
            
            Test().multiplication( a1234,  a5678, F(T([ 005,  016,  034,  060,  061,  052,  032,  000] as [L], repeating: 0)))
            Test().multiplication( a1234, ~a5678, F(T([~005, ~018, ~037, ~064, ~061, ~052, ~032, ~000] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a1234,  a5678, F(T([~009, ~022, ~041, ~068, ~061, ~052, ~032, ~000] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a1234, ~a5678, F(T([ 012,  024,  044,  072,  061,  052,  032,  000] as [L], repeating: 0), error: !T.isSigned))
            
            Test().multiplication( a5678,  a1234, F(T([ 005,  016,  034,  060,  061,  052,  032,  000] as [L], repeating: 0)))
            Test().multiplication( a5678, ~a1234, F(T([~009, ~022, ~041, ~068, ~061, ~052, ~032, ~000] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a5678,  a1234, F(T([~005, ~018, ~037, ~064, ~061, ~052, ~032, ~000] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a5678, ~a1234, F(T([ 012,  024,  044,  072,  061,  052,  032,  000] as [L], repeating: 0), error: !T.isSigned))
            
            Test().multiplication( a5678,  a5678, F(T([ 025,  060,  106,  164,  145,  112,  064,  000] as [L], repeating: 0)))
            Test().multiplication( a5678, ~a5678, F(T([~029, ~066, ~113, ~172, ~145, ~112, ~064, ~000] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a5678,  a5678, F(T([~029, ~066, ~113, ~172, ~145, ~112, ~064, ~000] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~a5678, ~a5678, F(T([ 036,  072,  120,  180,  145,  112,  064,  000] as [L], repeating: 0), error: !T.isSigned))
            //=----------------------------------=
            let b1234 = T([1, 2, 3, 4] as [L], repeating: 1)
            let b5678 = T([5, 6, 7, 8] as [L], repeating: 1)
            //=----------------------------------=
            Test().multiplication( b1234,  b1234, F(T([ 001,  004,  010,  020,  023,  020,  010, ~007] as [L], repeating: 0), error: !T.isSigned))
            Test().multiplication( b1234, ~b1234, F(T([~001, ~006, ~013, ~024, ~022, ~020, ~010,  007] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~b1234,  b1234, F(T([~001, ~006, ~013, ~024, ~022, ~020, ~010,  007] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~b1234, ~b1234, F(T([ 004,  008,  016,  028,  021,  020,  010, ~007] as [L], repeating: 0)))
            
            Test().multiplication( b1234,  b5678, F(T([ 005,  016,  034,  060,  055,  044,  022, ~011] as [L], repeating: 0), error: !T.isSigned))
            Test().multiplication( b1234, ~b5678, F(T([~005, ~018, ~037, ~064, ~054, ~044, ~022,  011] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~b1234,  b5678, F(T([~009, ~022, ~041, ~068, ~054, ~044, ~022,  011] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~b1234, ~b5678, F(T([ 012,  024,  044,  072,  053,  044,  022, ~011] as [L], repeating: 0)))
            
            Test().multiplication( b5678,  b1234, F(T([ 005,  016,  034,  060,  055,  044,  022, ~011] as [L], repeating: 0), error: !T.isSigned))
            Test().multiplication( b5678, ~b1234, F(T([~009, ~022, ~041, ~068, ~054, ~044, ~022,  011] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~b5678,  b1234, F(T([~005, ~018, ~037, ~064, ~054, ~044, ~022,  011] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~b5678, ~b1234, F(T([ 012,  024,  044,  072,  053,  044,  022, ~011] as [L], repeating: 0)))
            
            Test().multiplication( b5678,  b5678, F(T([ 025,  060,  106,  164,  135,  100,  050, ~015] as [L], repeating: 0), error: !T.isSigned))
            Test().multiplication( b5678, ~b5678, F(T([~029, ~066, ~113, ~172, ~134, ~100, ~050,  015] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~b5678,  b5678, F(T([~029, ~066, ~113, ~172, ~134, ~100, ~050,  015] as [L], repeating: 1), error: !T.isSigned))
            Test().multiplication(~b5678, ~b5678, F(T([ 036,  072,  120,  180,  133,  100,  050, ~015] as [L], repeating: 0)))
        }
                
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Code Coverage
    //=------------------------------------------------------------------------=
    
    func testMultiplicationLikeBigShift() {
        func whereIs<T, S>(_ type: T.Type, _ source: S.Type) where T: BinaryInteger, S: SystemsInteger & UnsignedInteger {
            //=----------------------------------=
            func make(_ source: [S]) -> T {
                source.withUnsafeBufferPointer({ T(DataInt($0)!, mode: .unsigned) })
            }
            //=----------------------------------=
            var lhs: T, rhs: T, pro: T, array = [S]()
            //=----------------------------------=
            for index: S in 0 ..< 16 {
                array.append(index)
            }
            
            lhs = make(array)
            array.removeAll()
            rhs = make([S](repeating: S.min, count: 16) + [1] as [S])
            pro = lhs << T(S.size * 16)
            
            Test().same(lhs.times(rhs), Fallible(pro))
            Test().same(rhs.times(lhs), Fallible(pro))
        }
        
        for type in Self.types {
            for source in coreSystemsIntegersWhereIsUnsigned {
                whereIs(type, source)
            }
        }
    }
    
    func testMultiplicationLikeBigSystemsInteger() {
        func whereIs<T, S>(_ type: T.Type, _ source: S.Type) where T: BinaryInteger, S: SystemsInteger & UnsignedInteger {
            //=----------------------------------=
            func make(_ source: [S]) -> T {
                source.withUnsafeBufferPointer({ T(DataInt($0)!, mode: .unsigned) })
            }
            //=----------------------------------=
            var lhs: T, rhs: T, pro: T, array = [S]()
            //=----------------------------------=
            // imagine: (U16.max - 0) * (U16.max - 0)
            //=----------------------------------=
            lhs = make([S](repeating: S.max, count: 16))
            rhs = make([S](repeating: S.max, count: 16))
            pro = make([1] as [S] + [S](repeating: S.min, count: 15) + [~1] as [S] + [S](repeating: S.max, count: 15))
            
            Test().same(lhs.times(rhs), Fallible(pro))
            Test().same(lhs.squared( ), Fallible(pro))
            //=----------------------------------=
            // imagine: (U16.max - 0) * (U16.max - 1)
            //=----------------------------------=
            lhs = make([S](repeating: S.max, count: 16))
            rhs = make([~1] as [S] + [S](repeating: S.max, count: 15))
            pro = make([ 2] as [S] + [S](repeating: S.min, count: 15) + [~2] as [S] + [S](repeating: S.max, count: 15))
            
            Test().same(lhs.times(rhs), Fallible(pro))
            Test().same(rhs.times(lhs), Fallible(pro))
            //=----------------------------------=
            // imagine: (U16.max - 1) * (U16.max - 1)
            //=----------------------------------=
            array += [ 4] as [S]
            array += Array(repeating: S.min, count: 15)
            array += [~3] as [S]
            array += Array(repeating: S.max, count: 15)

            lhs = make([~1] as [S] + [S](repeating: S.max, count: 15))
            rhs = make([~1] as [S] + [S](repeating: S.max, count: 15))
            pro = make(array)
            array.removeAll()
            
            Test().same(lhs.times(rhs), Fallible(pro))
            Test().same(lhs.squared( ), Fallible(pro))
            //=----------------------------------=
            // imagine: (U16.max - 0) * (U8 .max - 0)
            //=----------------------------------=
            array += [ 1] as [S]
            array += Array(repeating: S.min, count: 07)
            array += Array(repeating: S.max, count: 08)
            array += [~1] as [S]
            array += Array(repeating: S.max, count: 07)
            
            lhs = make([S](repeating: S.max, count: 16))
            rhs = make([S](repeating: S.max, count: 08))
            pro = make(array)
            array.removeAll()
            
            Test().same(lhs.times(rhs), Fallible(pro))
            Test().same(rhs.times(lhs), Fallible(pro))
        }
        
        for type in Self.types {
            for source in coreSystemsIntegersWhereIsUnsigned {
                whereIs(type, source)
            }
        }
    }
}
