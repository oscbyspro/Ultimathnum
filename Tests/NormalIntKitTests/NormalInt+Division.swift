//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import NormalIntKit
import TestKit

//*============================================================================*
// MARK: * Normal Int x Division
//*============================================================================*

extension NormalIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivision() {
        //=--------------------------------------=
        Test.division(0 as T, 1 as T, 0 as T, 0 as T)
        Test.division(0 as T, 2 as T, 0 as T, 0 as T)
        Test.division(7 as T, 1 as T, 7 as T, 0 as T)
        Test.division(7 as T, 2 as T, 3 as T, 1 as T)
        
        Test.division(0 as T, 0 as T, 0 as T, 0 as T, true)
        Test.division(1 as T, 0 as T, 1 as T, 1 as T, true)
        Test.division(2 as T, 0 as T, 2 as T, 2 as T, true)
        //=--------------------------------------=
        Test.division(T(words:[~2,  ~4,  ~6,  9] as X), 2 as T, T(words:[~1, ~2, ~3,  4] as X), 1 as T)
        Test.division(T(words:[~3,  ~6,  ~9, 14] as X), 3 as T, T(words:[~1, ~2, ~3,  4] as X), 2 as T)
        Test.division(T(words:[~4,  ~8, ~12, 19] as X), 4 as T, T(words:[~1, ~2, ~3,  4] as X), 3 as T)
        Test.division(T(words:[~5, ~10, ~15, 24] as X), 5 as T, T(words:[~1, ~2, ~3,  4] as X), 4 as T)
        
        Test.division(T(words:[~2,  ~4,  ~6,  9] as X), T(words:[~1, ~2, ~3,  4] as X), 2 as T, 1 as T)
        Test.division(T(words:[~3,  ~6,  ~9, 14] as X), T(words:[~1, ~2, ~3,  4] as X), 3 as T, 2 as T)
        Test.division(T(words:[~4,  ~8, ~12, 19] as X), T(words:[~1, ~2, ~3,  4] as X), 4 as T, 3 as T)
        Test.division(T(words:[~5, ~10, ~15, 24] as X), T(words:[~1, ~2, ~3,  4] as X), 5 as T, 4 as T)
        //=--------------------------------------=
        Test.division(T(words:[1, 2, 3, 4 + 1 << 63] as X), T(words:[ 3,  4,  5,  6 &+ 1 << 63] as X), T(0), T(words:[1, 2, 3, 4 + 1 << 63] as X))
        Test.division(T(words:[1, 2, 3, 4 + 1 << 63] as X), T(words:[ 2,  3,  4,  5 &+ 1 << 63] as X), T(0), T(words:[1, 2, 3, 4 + 1 << 63] as X))
        
        Test.division(T(words:[1, 2, 3, 4 + 1 << 63] as X), T(words:[ 1,  2,  3,  4 &+ 1 << 63] as X), T(1), T(words:[0, 0, 0, 0] as X))
        Test.division(T(words:[1, 2, 3, 4 + 1 << 63] as X), T(words:[ 0,  1,  2,  3 &+ 1 << 63] as X), T(1), T(words:[1, 1, 1, 1] as X))
        Test.division(T(words:[1, 2, 3, 4 + 1 << 63] as X), T(words:[~0, ~0,  0,  2 &+ 1 << 63] as X), T(1), T(words:[2, 2, 2, 2] as X))
        Test.division(T(words:[1, 2, 3, 4 + 1 << 63] as X), T(words:[~1, ~1, ~0,  0 &+ 1 << 63] as X), T(1), T(words:[3, 3, 3, 3] as X))
        Test.division(T(words:[1, 2, 3, 4 + 1 << 63] as X), T(words:[~2, ~2, ~1, ~0 &+ 1 << 63] as X), T(1), T(words:[4, 4, 4, 4] as X))
        Test.division(T(words:[1, 2, 3, 4 + 1 << 63] as X), T(words:[~3, ~3, ~2, ~1 &+ 1 << 63] as X), T(1), T(words:[5, 5, 5, 5] as X))
        Test.division(T(words:[1, 2, 3, 4 + 1 << 63] as X), T(words:[~4, ~4, ~3, ~2 &+ 1 << 63] as X), T(1), T(words:[6, 6, 6, 6] as X))
        Test.division(T(words:[1, 2, 3, 4 + 1 << 63] as X), T(words:[~5, ~5, ~4, ~3 &+ 1 << 63] as X), T(1), T(words:[7, 7, 7, 7] as X))
        //=--------------------------------------=
        Test.division(T(words:[06, 17, 35, 61, 61, 52, 32, 00] as X), T(words:[1, 2, 3, 4] as X), T(words:[5, 6, 7, 8] as X), T(words:[ 1,  1,  1,  1] as X))
        Test.division(T(words:[06, 17, 35, 61, 61, 52, 32, 00] as X), T(words:[5, 6, 7, 8] as X), T(words:[1, 2, 3, 4] as X), T(words:[ 1,  1,  1,  1] as X))
        
        Test.division(T(words:[34, 54, 63, 62, 34, 16, 05, 00] as X), T(words:[4, 3, 2, 1] as X), T(words:[9, 7, 6, 5] as X), T(words:[~1, ~1, ~0,  0] as X))
        Test.division(T(words:[34, 54, 63, 62, 34, 16, 05, 00] as X), T(words:[8, 7, 6, 5] as X), T(words:[4, 3, 2, 1] as X), T(words:[ 2,  2,  2,  2] as X))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testDivisionLikeFullWidth3212MSB256Bit() {
        Test.division(
        T(words:[ 0,  0,  0,  0,  0, ~0, ~0, ~0] as X),
        T(words:[~0, ~0, ~0, ~0,  0,  0,  0,  0] as X),
        T(words:[ 0, ~0, ~0, ~0,  0,  0,  0,  0] as X),
        T(words:[ 0, ~0, ~0, ~0,  0,  0,  0,  0] as X))
        
        Test.division(
        T(words:[~0, ~0, ~0, ~0,  0, ~0, ~0, ~0] as X),
        T(words:[~0, ~0, ~0, ~0,  0,  0,  0,  0] as X),
        T(words:[ 1, ~0, ~0, ~0,  0,  0,  0,  0] as X),
        T(words:[ 0, ~0, ~0, ~0,  0,  0,  0,  0] as X))
    }
}

//*============================================================================*
// MARK: * Normal Int x Division x Code Coverage
//*============================================================================*

final class NormalIntTestsOnDivisionCodeCoverage: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivisionLikeFullWidth3212MSB() {
        typealias U256 = NormalInt<UX>
        
        Test.division(
        U256(x64:[ 0,  0,  0,  0,  0, ~0, ~0, ~0] as [U64]),
        U256(x64:[~0, ~0, ~0, ~0,  0,  0,  0,  0] as [U64]),
        U256(x64:[ 0, ~0, ~0, ~0,  0,  0,  0,  0] as [U64]),
        U256(x64:[ 0, ~0, ~0, ~0,  0,  0,  0,  0] as [U64]))
        
        Test.division(
        U256(x64:[~0, ~0, ~0, ~0,  0, ~0, ~0, ~0] as [U64]),
        U256(x64:[~0, ~0, ~0, ~0,  0,  0,  0,  0] as [U64]),
        U256(x64:[ 1, ~0, ~0, ~0,  0,  0,  0,  0] as [U64]),
        U256(x64:[ 0, ~0, ~0, ~0,  0,  0,  0,  0] as [U64]))
    }
}

//*============================================================================*
// MARK: * Normal Int x Division x Open Source Issues
//*============================================================================*

final class NormalIntTestsOnDivisionOpenSourceIssues: XCTestCase {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// https://github.com/oscbyspro/Numberick/issues/101
    ///
    /// - Note: This issue is w.r.t. the double width integer.
    ///
    /// - Note: Checks whether the 3212-path knows when the quotient fits.
    ///
    func testNumberickIssues101() {
        typealias T256 = NormalInt<UX>
        
        Test.division(
        T256(000000000000000000003360506852691063560493141264855294697309369118818719524903),
        T256(000000000000000000000000000000000000000038792928317726192474768301090870907748),
        T256(000000000000000000000000000000000000000000000000000000000086626789943967710436),
        T256(000000000000000000000000000000000000000016136758413064865246015978698186666775))
    }
    
    /// https://github.com/apple/swift-numerics/issues/272
    ///
    /// - Note: This issue is w.r.t. the double width integer.
    ///
    /// - Note: Said to crash and/or return incorrect results.
    ///
    func testSwiftNumericsIssues272() {
        typealias U128 = NormalInt<UX>
        typealias U256 = NormalInt<UX>

        Test.division(
        U128(x64:[0, 3 << 32] as [U64]),
        U128(x64:[0, 2 << 32] as [U64]),
        U128(x64:[1, 0 << 00] as [U64]),
        U128(x64:[0, 1 << 32] as [U64]))
        
        Test.division(
        U128(311758830729407788314878278112166161571),
        U128(259735543268722398904715765931073125012),
        U128(000000000000000000000000000000000000001),
        U128(052023287460685389410162512181093036559))
        
        Test.division(
        U128(213714108890282186096522258117935109183),
        U128(205716886996038887182342392781884393270),
        U128(000000000000000000000000000000000000001),
        U128(007997221894243298914179865336050715913))
        
        Test.division(
        U256(000000000000000000002369676578372158364766242369061213561181961479062237766620),
        U256(000000000000000000000000000000000000000102797312405202436815976773795958969482),
        U256(000000000000000000000000000000000000000000000000000000000023051931251193218442),
        U256(000000000000000000000000000000000000000001953953567802622125048779101000179576))
        
        Test.division(
        U256(096467201117289166187766181030232879447148862859323917044548749804018359008044),
        U256(000000000000000000004646260627574879223760172113656436161581617773435991717024),
        U256(000000000000000000000000000000000000000000000000000000000020762331011904583253),
        U256(000000000000000000002933245778855346947389808606934720764144871598087733608972))
    }
}
