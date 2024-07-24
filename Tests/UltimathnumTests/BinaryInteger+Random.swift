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
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
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
    
    //=----------------------------------------------------------------------------=
    // MARK: Tests x Systems Integer
    //=----------------------------------------------------------------------------=
    
    func testRandomSystemsInteger() {
        func whereIs<T>(_ type: T.Type, randomness: consuming FuzzerInt) where T: SystemsInteger {
            func collect(unique: Int, next: () -> T) {
                var elements = Set<T>()
                
                loop: while elements.count < unique {
                    elements.insert(next())
                }
                
                Test().same(elements.count, (unique))
            }
                        
            collect(unique: 256) {
                T.random()
            }
            
            collect(unique: 256) {
                T.random(using: &randomness)
            }
        }
        
        for type in systemsIntegers {
            whereIs(type, randomness: fuzzer)
        }
    }
    
    func testRandomSystemsIntegerInRange() {
        func whereIs<T>(_ type: T.Type, randomness: consuming FuzzerInt) where T: SystemsInteger {
            let eigth: T = T(T.Magnitude.max/8 + 1)
            let small: Range<T> = (T.isSigned ? -4 ..< 3 : 0 ..< 8)
            let large: Range<T> = (T.min + eigth)..<(T.max - eigth)
            
            func check(_ range: Range<T>) {
                let r0 = T.random(in: range)
                let r1 = T.random(in: range, using: &randomness)
                
                for random: Optional<T> in [r0, r1] {
                    Test().yay(random == nil ? range.isEmpty : range.contains(random!))
                }
            }
            
            for _ in IX.zero ..< 32 {
                check(large)
            }
            
            for min: T in small {
                for max: T in min ..< small.upperBound {
                    check(min ..< max)
                }
            }
        }
        
        for type in systemsIntegers {
            whereIs(type, randomness: fuzzer)
        }
    }
    
    func testRandomSystemsIntegerInClosedRange() {
        func whereIs<T>(_ type: T.Type, randomness: consuming FuzzerInt) where T: SystemsInteger {
            let eigth: T = T(T.Magnitude.max/8 + 1)
            let small: ClosedRange<T> = (T.isSigned ? -4 ... 3 : 0 ... 8)
            let large: ClosedRange<T> = (T.min + eigth)...(T.max - eigth)
            
            func check(_ range: ClosedRange<T>) {
                let r0 = T.random(in: range)
                let r1 = T.random(in: range, using: &randomness)
                
                for random: T in [r0, r1] {
                    Test().yay(range.contains(random))
                }
            }
            
            for _ in IX.zero ..< 32 {
                check(large)
            }
            
            for min: T in small {
                for max: T in min ... small.upperBound {
                    check(min ... max)
                }
            }
        }
        
        for type in systemsIntegers {
            whereIs(type, randomness: fuzzer)
        }
    }
}
