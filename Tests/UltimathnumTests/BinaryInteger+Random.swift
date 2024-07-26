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
    
    //=----------------------------------------------------------------------------=
    // MARK: Tests
    //=----------------------------------------------------------------------------=
    
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
    
    func testRandomThroughBitIndex() {
        func whereIs<T>(_ type: T.Type, randomness: consuming FuzzerInt) where T: BinaryInteger {
            for index in 0 ..< (T.isArbitrary ? 128 : IX(size: T.self)!) {
                let index = Shift<T.Magnitude>(Count(index))
                let limit = IX(raw: index.value) + (T.isSigned ? 1 : 2)
                
                for _ in 0 ..< 4 {
                    let r0 = T.random(through: index)
                    let r1 = T.random(through: index, using: &randomness)
                    
                    for random in [r0, r1] {
                        Test().yay(random.entropy() >= Count(00001))
                        Test().yay(random.entropy() <= Count(limit))
                        Test().nay(random.isInfinite)
                    }
                }
            }
        }
        
        for type in binaryIntegers {
            whereIs(type, randomness: fuzzer)
        }
    }
}
