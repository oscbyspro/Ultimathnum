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
import TestKit2
import XCTest

//*============================================================================*
// MARK: * Randomness
//*============================================================================*

final class RandomnessBenchmarks: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFillAsU008() {
        typealias T    = U8
        var payload: T = blackHoleIdentity(T.zero)
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))

        for _ in 0 ..< 10_000_000 {
            blackHole(payload)
            Swift.withUnsafeMutableBytes(of: &payload) {
                randomness.fill($0)
            }
        }
    }
    
    func testFillAsU016() {
        typealias T    = U16
        var payload: T = blackHoleIdentity(T.zero)
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))

        for _ in 0 ..< 10_000_000 {
            blackHole(payload)
            Swift.withUnsafeMutableBytes(of: &payload) {
                randomness.fill($0)
            }
        }
    }
    
    func testFillAsU032() {
        typealias T    = U32
        var payload: T = blackHoleIdentity(T.zero)
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))

        for _ in 0 ..< 10_000_000 {
            blackHole(payload)
            Swift.withUnsafeMutableBytes(of: &payload) {
                randomness.fill($0)
            }
        }
    }
    
    func testFillAsU064() {
        typealias T    = U64
        var payload: T = blackHoleIdentity(T.zero)
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))

        for _ in 0 ..< 10_000_000 {
            blackHole(payload)
            Swift.withUnsafeMutableBytes(of: &payload) {
                randomness.fill($0)
            }
        }
    }
    
    func testFillAsU128() {
        typealias T    = U128
        var payload: T = blackHoleIdentity(T.zero)
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))

        for _ in 0 ..< 10_000_000 {
            blackHole(payload)
            Swift.withUnsafeMutableBytes(of: &payload) {
                randomness.fill($0)
            }
        }
    }
    
    func testFillAsU256() {
        typealias T    = U256
        var payload: T = blackHoleIdentity(T.zero)
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))

        for _ in 0 ..< 10_000_000 {
            blackHole(payload)
            Swift.withUnsafeMutableBytes(of: &payload) {
                randomness.fill($0)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNextAsU008() {
        typealias T    = U8
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))
        
        for _ in 0 ..< 10_000_000 {
            let random = randomness.next(as: T.self)
            blackHole(random)
        }
    }
    
    func testNextAsU016() {
        typealias T    = U16
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))

        for _ in 0 ..< 10_000_000 {
            let random = randomness.next(as: T.self)
            blackHole(random)
        }
    }
    
    func testNextAsU032() {
        typealias T    = U32
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))

        for _ in 0 ..< 10_000_000 {
            let random = randomness.next(as: T.self)
            blackHole(random)
        }
    }
    
    func testNextAsU064() {
        typealias T    = U64
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))
        
        for _ in 0 ..< 10_000_000 {
            let random = randomness.next(as: T.self)
            blackHole(random)
        }
    }
    
    func testNextAsU128() {
        typealias T    = U128
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))

        for _ in 0 ..< 10_000_000 {
            let random = randomness.next(as: T.self)
            blackHole(random)
        }
    }
    
    /// ###### 2024-10-30 (MacBook Pro, 13-inch, M1, 2020):
    ///
    /// - `0.09 seconds`
    /// - `0.03 seconds` with `MutableDataInt.Body`
    ///
    func testNextAsU256() {
        typealias T    = U256
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))
        
        for _ in 0 ..< 10_000_000 {
            let random = randomness.next(as: T.self)
            blackHole(random)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNextThroughBitIndexAsU008() {
        typealias T    = U8
        let indices    = blackHoleIdentity(Shift<T>.all)
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))
        
        for index in indices {
            for _ in 0 ..< 10_000_000 / indices.count {
                let random = T.random(through: index, using: &randomness)
                blackHole(random)
            }
        }
    }
    
    func testNextThroughBitIndexAsU016() {
        typealias T    = U16
        let indices    = blackHoleIdentity(Shift<T>.all)
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))
        
        for index in indices {
            for _ in 0 ..< 10_000_000 / indices.count {
                let random = T.random(through: index, using: &randomness)
                blackHole(random)
            }
        }
    }
    
    func testNextThroughBitIndexAsU032() {
        typealias T    = U32
        let indices    = blackHoleIdentity(Shift<T>.all)
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))
        
        for index in indices {
            for _ in 0 ..< 10_000_000 / indices.count {
                let random = T.random(through: index, using: &randomness)
                blackHole(random)
            }
        }
    }
    
    
    func testNextThroughBitIndexAsU064() {
        typealias T    = U64
        let indices    = blackHoleIdentity(Shift<T>.all)
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))
        
        for index in indices {
            for _ in 0 ..< 10_000_000 / indices.count {
                let random = T.random(through: index, using: &randomness)
                blackHole(random)
            }
        }
    }
    
    func testNextThroughBitIndexAsU128() {
        typealias T    = U128
        let indices    = blackHoleIdentity(Shift<T>.all)
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))
        
        for index in indices {
            for _ in 0 ..< 10_000_000 / indices.count {
                let random = T.random(through: index, using: &randomness)
                blackHole(random)
            }
        }
    }
    
    /// ###### 2024-10-30 (MacBook Pro, 13-inch, M1, 2020):
    ///
    /// - `0.10 seconds`
    /// - `0.04 seconds` with `MutableDataInt.Body`
    ///
    func testNextThroughBitIndexAsU256() {
        typealias T    = U256
        let indices    = blackHoleIdentity(Shift<T>.all)
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))
        
        for index in indices {
            for _ in 0 ..< 10_000_000 / indices.count {
                let random = T.random(through: index, using: &randomness)
                blackHole(random)
            }
        }
    }
    
    func testNextThroughBitIndexOneMillionTimesAsInfiniIntU8() {
        typealias T    = InfiniInt<U8>
        let indices    = blackHoleIdentity(IX.zero ..< 256)
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))

        for index in indices {
            for _ in 0 ..< 1_000_000 / indices.count {
                let count  = Count(Natural(unchecked:index))
                let index  = Shift<T>.init(unchecked: count)
                let random = T.random(through: index, using: &randomness)
                blackHole(random)
            }
        }
    }
    
    func testNextThroughBitIndexOneMillionTimesAsInfiniIntUX() {
        typealias T    = InfiniInt<UX>
        let indices    = blackHoleIdentity(IX.zero ..< 256)
        var randomness = blackHoleIdentity(FuzzerInt(seed: 1234567890))

        for index in indices {
            for _ in 0 ..< 1_000_000 / indices.count {
                let count  = Count(Natural(unchecked:index))
                let index  = Shift<T>.init(unchecked: count)
                let random = T.random(through: index, using: &randomness)
                blackHole(random)
            }
        }
    }
}
