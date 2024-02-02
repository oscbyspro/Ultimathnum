//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import TestKit

//*============================================================================*
// MARK: * Double Int x Division
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivision11() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            
            Test.division( 0 as T,  1 as T,  0 as T,  0 as T)
            Test.division( 0 as T,  2 as T,  0 as T,  0 as T)
            Test.division( 7 as T,  1 as T,  7 as T,  0 as T)
            Test.division( 7 as T,  2 as T,  3 as T,  1 as T)
            
            guard T.isSigned else { return }
                    
            Test.division( 7 as T,  3 as T,  2 as T,  1 as T)
            Test.division( 7 as T, -3 as T, -2 as T,  1 as T)
            Test.division(-7 as T,  3 as T, -2 as T, -1 as T)
            Test.division(-7 as T, -3 as T,  2 as T, -1 as T)
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    } 
    
    func testDivision21() {
        func whereTheBaseTypeIsSigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
                        
            Test.division( T(low:  7, high:  8),  4 as T,  T(low:  1, high:  2),  3 as T)
            Test.division( T(low:  7, high:  8), -4 as T, -T(low:  1, high:  2),  3 as T)
            Test.division(-T(low:  7, high:  8),  4 as T, -T(low:  1, high:  2), -3 as T)
            Test.division(-T(low:  7, high:  8), -4 as T,  T(low:  1, high:  2), -3 as T)
        }
        
        func whereTheBaseTypeIsUnsigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            
            Test.division( T(low: ~2, high:  5),  2 as T,  T(low: ~1, high:  2),  1 as T)
            Test.division( T(low: ~3, high:  8),  3 as T,  T(low: ~1, high:  2),  2 as T)
            Test.division( T(low: ~4, high: 11),  4 as T,  T(low: ~1, high:  2),  3 as T)
            Test.division( T(low: ~5, high: 14),  5 as T,  T(low: ~1, high:  2),  4 as T)
        }
        
        for base in Self.bases {
            base.isSigned ? whereTheBaseTypeIsSigned(base) : whereTheBaseTypeIsUnsigned(base)
        }
    }
    
    func testDivision22() {
        func whereTheBaseTypeIsSigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
                        
            Test.division( T(low: ~2, high:  5),  T(low: ~1, high:  2),  2 as T,  1 as T)
            Test.division( T(low: ~3, high:  8), -T(low: ~1, high:  2), -3 as T,  2 as T)
            Test.division(-T(low: ~4, high: 11),  T(low: ~1, high:  2), -4 as T, -3 as T)
            Test.division(-T(low: ~5, high: 14), -T(low: ~1, high:  2),  5 as T, -4 as T)
            
            Test.division( T(low:  1, high:  2 &+ Base.msb),  T(low: 1, high: 2 &+ Base.msb),  1 as T, -T(low: 0, high: 0))
            Test.division( T(low:  1, high:  2 &+ Base.msb), -T(low: 2, high: 3 &+ Base.msb), -1 as T, -T(low: 1, high: 1))
            Test.division(-T(low:  1, high:  2 &+ Base.msb),  T(low: 3, high: 4 &+ Base.msb), -1 as T,  T(low: 2, high: 2))
            Test.division(-T(low:  1, high:  2 &+ Base.msb), -T(low: 4, high: 5 &+ Base.msb),  1 as T,  T(low: 3, high: 3))
        }
        
        func whereTheBaseTypeIsUnsigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            
            Test.division( T(low: ~2, high:  5),  T(low: ~1, high:  2),  2 as T,  1 as T)
            Test.division( T(low: ~3, high:  8),  T(low: ~1, high:  2),  3 as T,  2 as T)
            Test.division( T(low: ~4, high: 11),  T(low: ~1, high:  2),  4 as T,  3 as T)
            Test.division( T(low: ~5, high: 14),  T(low: ~1, high:  2),  5 as T,  4 as T)
        }
        
        for base in Self.bases {
            base.isSigned ? whereTheBaseTypeIsSigned(base) : whereTheBaseTypeIsUnsigned(base)
        }
    }
    
    func testDivision22Overflow() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            
            Test.division(~1 as T,  0 as T, ~1 as T, ~1 as T, true)
            Test.division(~0 as T,  0 as T, ~0 as T, ~0 as T, true)
            Test.division( 0 as T,  0 as T,  0 as T,  0 as T, true)
            Test.division( 1 as T,  0 as T,  1 as T,  1 as T, true)
            Test.division( 2 as T,  0 as T,  2 as T,  2 as T, true)
            
            guard T.isSigned else { return }
            
            Test.division( T .min, -1 as T,  T .min,  0 as T, true)
            Test.division( T .max, -1 as T, -T .max,  0 as T)
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    /// ### Development
    ///
    /// - TODO: Overflow should be nil.
    ///
    func testDivision42Overflow() {
        func whereTheBaseTypeIsSigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
                        
            Test.division(Doublet(low:  7 as M, high:  0 as T),  0 as T,  7 as T,  7 as T, true)
            Test.division(Doublet(low:  7 as M, high: ~0 as T),  0 as T,  7 as T,  7 as T, true)
            Test.division(Doublet(low: ~0 as M, high: -1 as T),  2 as T,  0 as T, -1 as T)
            Test.division(Doublet(low:  1 as M, high:  0 as T), -2 as T,  0 as T,  1 as T)
            Test.division(Doublet(low: ~M .msb, high:  0 as T), -1 as T, -T .max,  0 as T)
            Test.division(Doublet(low:  M .msb, high: -1 as T), -1 as T,  T .min,  0 as T, true)
            
            Test.division(Doublet(low:  M .max >> 1 + 0, high:  T.max >> 1 + 0), T.max,  T.max,  T .max - 1)
            Test.division(Doublet(low:  M .max >> 1 + 1, high:  T.max >> 1 + 0), T.max,  T.min,  0 as T - 0, true)
            Test.division(Doublet(low:  M .max >> 1 + 0, high:  T.max >> 1 + 1), T.min,  T.min,  T .max - 0)
            Test.division(Doublet(low:  M .max >> 1 + 1, high:  T.max >> 1 + 1), T.min,  T.max,  0 as T - 0, true)
        }
        
        func whereTheBaseTypeIsUnsigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            
            Test.division(Doublet(low:  7 as M, high:  0 as T),  0 as T,  7 as T,  7 as T, true)
            Test.division(Doublet(low:  7 as M, high: ~0 as T),  0 as T,  7 as T,  7 as T, true)
            Test.division(Doublet(low: ~0 as M, high: ~1 as T), ~0 as T, ~0 as T, ~1 as T)
            Test.division(Doublet(low:  0 as M, high: ~0 as T), ~0 as T,  0 as T,  0 as T, true)
        }
        
        for base in Self.bases {
            base.isSigned ? whereTheBaseTypeIsSigned(base) : whereTheBaseTypeIsUnsigned(base)
        }
    }
}

//*============================================================================*
// MARK: * Double Int x Division x Open Source Issues
//*============================================================================*

final class DoubleIntTestsOnDivisionOpenSourceIssues: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// https://github.com/oscbyspro/Numberick/issues/101
    ///
    /// - Note: Checks whether the 3212-path knows when the quotient fits.
    ///
    func testGitHubOscbysproNumberickIssues101() {
        Test.division(
        U256("000000000000000000003360506852691063560493141264855294697309369118818719524903")!,
        U256("000000000000000000000000000000000000000038792928317726192474768301090870907748")!,
        U256("000000000000000000000000000000000000000000000000000000000086626789943967710436")!,
        U256("000000000000000000000000000000000000000016136758413064865246015978698186666775")!)
    }
    
    /// https://github.com/apple/swift-numerics/issues/272
    ///
    /// - Note: Said to crash and/or return incorrect results.
    ///
    func testGitHubAppleSwiftNumericsIssues272() {
        Test.division(
        U128(3) << 96,
        U128(2) << 96,
        U128(1) << 00,
        U128(1) << 96)
        
        Test.division(
        U128("311758830729407788314878278112166161571")!,
        U128("259735543268722398904715765931073125012")!,
        U128("000000000000000000000000000000000000001")!,
        U128("052023287460685389410162512181093036559")!)
        
        Test.division(
        U128("213714108890282186096522258117935109183")!,
        U128("205716886996038887182342392781884393270")!,
        U128("000000000000000000000000000000000000001")!,
        U128("007997221894243298914179865336050715913")!)
        
        Test.division(
        U256("000000000000000000002369676578372158364766242369061213561181961479062237766620")!,
        U256("000000000000000000000000000000000000000102797312405202436815976773795958969482")!,
        U256("000000000000000000000000000000000000000000000000000000000023051931251193218442")!,
        U256("000000000000000000000000000000000000000001953953567802622125048779101000179576")!)
        
        Test.division(
        U256("096467201117289166187766181030232879447148862859323917044548749804018359008044")!,
        U256("000000000000000000004646260627574879223760172113656436161581617773435991717024")!,
        U256("000000000000000000000000000000000000000000000000000000000020762331011904583253")!,
        U256("000000000000000000002933245778855346947389808606934720764144871598087733608972")!)
    }
}