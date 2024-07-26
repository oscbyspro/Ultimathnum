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
// MARK: * Binary Integer x Random
//*============================================================================*

final class BinaryIntegerTestsOnRandom: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Range
    //=------------------------------------------------------------------------=
    
    /// - Note: The bounds may be infinite, but not their distance.
    func testRandomInRange() {
        func whereIs<T>(_ type: T.Type, randomness: consuming FuzzerInt) where T: BinaryInteger {
            let min = Esque<T>.min
            let max = Esque<T>.bot
            
            let eigth: T = T(1  + Esque<T.Magnitude>.bot / 8)
            let small: Range<T> = (T.isSigned ? -4..<3 : 0..<8)
            let large: Range<T> = (min + eigth)..<(max - eigth)
            
            func check(_ range: Range<T>) {
                let r0 = T.random(in: range)
                let r1 = T.random(in: range, using: &randomness)
                
                for random: Optional<T> in [r0, r1] {
                    Test().yay(random == nil ? range.isEmpty : range.contains(random!))
                }
            }
            
            for min: T in small {
                for max: T in (min) ..< (small).upperBound {
                    check((    min) ..< ( max))
                    check((   ~max) ..< (~min))
                }
            }
            
            for _ in IX.zero ..< 16 {
                check(( large.lowerBound) ..< ( large.upperBound))
                check((~large.upperBound) ..< (~large.lowerBound))
            }
        }
        
        for type in binaryIntegers {
            whereIs(type, randomness: fuzzer)
        }
    }
    
    func testRandomInRangeHasKnownBounds() {
        func whereIs<T>(_ type: T.Type, randomness: consuming FuzzerInt) where T: BinaryInteger {
            func check(_ expectation: Range<T>) {
                guard !expectation.isEmpty else { return }
                let last: T = expectation.upperBound - 1
                
                var min = false
                var max = false
                
                while !(min && max) {
                    let random = T.random(in: expectation, using: &randomness)!
                    guard expectation.contains(random) else {  break }
                    if random == expectation.lowerBound { min = true }
                    if random == (((((((((last))))))))) { max = true }
                }
                
                Test().yay(min && max)
            }
            
            for index: IX in 0 ... 7 {
                let min = T.random(through: Shift(Count(index)), using: &randomness)
                let max = T.random(through: Shift(Count(index)), using: &randomness)
                check(min <= max ? min..<max : max..<min)
            }
        }
        
        for type in binaryIntegers {
            whereIs(type, randomness: fuzzer)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Closed Range
    //=------------------------------------------------------------------------=
    
    /// - Note: The bounds may be infinite, but not their distance.
    func testRandomInClosedRange() {
        func whereIs<T>(_ type: T.Type, randomness: consuming FuzzerInt) where T: BinaryInteger {
            let min = Esque<T>.min
            let max = Esque<T>.bot
            
            let eigth: T = T(1  + Esque<T.Magnitude>.bot / 8)
            let small: ClosedRange<T> = (T.isSigned ? -4...3 : 0...8)
            let large: ClosedRange<T> = (min + eigth)...(max - eigth)
            
            func check(_ range: ClosedRange<T>) {
                let r0 = T.random(in: range)
                let r1 = T.random(in: range, using: &randomness)
                
                for random: T in [r0, r1] {
                    Test().yay(range.contains(random))
                }
            }
            
            for min: T in small {
                for max: T in (min) ... (small).upperBound {
                    check((    min) ... ( max))
                    check((   ~max) ... (~min))
                }
            }
            
            for _ in IX.zero ..< 16 {
                check(( large.lowerBound) ... ( large.upperBound))
                check((~large.upperBound) ... (~large.lowerBound))
            }
        }
        
        for type in binaryIntegers {
            whereIs(type, randomness: fuzzer)
        }
    }
    
    func testRandomInClosedRangeHasKnownBounds() {
        func whereIs<T>(_ type: T.Type, randomness: consuming FuzzerInt) where T: BinaryInteger {
            func check(_ expectation: ClosedRange<T>) {
                var min = false
                var max = false
                
                while !(min && max) {
                    let random = T.random(in: expectation, using: &randomness)
                    guard expectation.contains(random) else {  break }
                    if random == expectation.lowerBound { min = true }
                    if random == expectation.upperBound { max = true }
                }
                
                Test().yay(min && max)
            }
            
            for index: IX in 0 ... 7 {
                let min = T.random(through: Shift(Count(index)), using: &randomness)
                let max = T.random(through: Shift(Count(index)), using: &randomness)
                check(min <= max ? min...max : max...min)
            }
        }
        
        for type in binaryIntegers {
            whereIs(type, randomness: fuzzer)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bit Index
    //=------------------------------------------------------------------------=
    
    func testRandomThroughBitIndex() {
        func whereIs<T>(_ type: T.Type, randomness: consuming FuzzerInt) where T: BinaryInteger {
            for index in 0 ..< (T.isArbitrary ? 128 : IX(size: T.self)!) {
                let index = Shift<T.Magnitude>(Count(index))
                let limit = IX(raw: index.value) + (T.isSigned ? 1 : 2)
                
                while true {
                    let random  = T.random(through: index)
                    let entropy = random.entropy()
                    Test().yay(entropy >= Count(00001))
                    Test().yay(entropy <= Count(limit))
                    Test().nay(random.isInfinite)
                    guard entropy != Count(limit) else { break }
                }
                
                while true {
                    let random  = T.random(through: index, using: &randomness)
                    let entropy = random.entropy()
                    Test().yay(entropy >= Count(00001))
                    Test().yay(entropy <= Count(limit))
                    Test().nay(random.isInfinite)
                    guard entropy != Count(limit) else { break }
                }
            }
        }
        
        for type in binaryIntegers {
            whereIs(type, randomness: fuzzer)
        }
    }
    
    func testRandomThroughBitIndexHasKnownBounds() {
        func whereIs<T>(_ type: T.Type, randomness: consuming FuzzerInt) where T: BinaryInteger {
            func check(_ index: Shift<T.Magnitude>, _ expectation: ClosedRange<T>) {
                let middle = T.isSigned ? T.zero : ((expectation.upperBound / 2) + 1)
                
                var min = false
                var mid = false
                var max = false
                
                while !(min && mid && max) {
                    let random = T.random(through: index, using: &randomness)
                    guard expectation.contains(random) else {  break }
                    if random == expectation.lowerBound { min = true }
                    if random == ((((((((middle)))))))) { mid = true }
                    if random == expectation.upperBound { max = true }
                }
                
                Test().yay(min && mid && max)
            }
            
            check(Shift(Count(0)), T.isSigned ? -001 ... 000 : 000 ... 001)
            check(Shift(Count(1)), T.isSigned ? -002 ... 001 : 000 ... 003)
            check(Shift(Count(2)), T.isSigned ? -004 ... 003 : 000 ... 007)
            check(Shift(Count(3)), T.isSigned ? -008 ... 007 : 000 ... 015)
            check(Shift(Count(4)), T.isSigned ? -016 ... 015 : 000 ... 031)
            check(Shift(Count(5)), T.isSigned ? -032 ... 031 : 000 ... 063)
            check(Shift(Count(6)), T.isSigned ? -064 ... 063 : 000 ... 127)
            check(Shift(Count(7)), T.isSigned ? -128 ... 127 : 000 ... 255)
        }
        
        for type in binaryIntegers {
            whereIs(type, randomness: fuzzer)
        }
    }
}
