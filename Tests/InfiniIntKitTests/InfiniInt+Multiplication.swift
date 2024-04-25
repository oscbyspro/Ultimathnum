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
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias E = Base.Element
            typealias L = Base.Element.Magnitude
            typealias T = InfiniInt<E>
            typealias F = Fallible<InfiniInt<E>>
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
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias E = Base.Element
            typealias L = Base.Element.Magnitude
            typealias T = InfiniInt<E>
            typealias F = Fallible<InfiniInt<E>>
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
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias E = Base.Element
            typealias L = Base.Element.Magnitude
            typealias T = InfiniInt<E>
            typealias F = Fallible<InfiniInt<E>>
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
}
