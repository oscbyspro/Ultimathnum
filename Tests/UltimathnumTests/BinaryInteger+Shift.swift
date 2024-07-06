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
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Shift
//*============================================================================*

final class BinaryIntegerTestsOnShifts: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Repeating Bit
    //=------------------------------------------------------------------------=
    
    func testUpshiftRepeatingBitByGenericDistancesAsArbitrayInteger() {
        func whereIs<A, B>(value: A.Type, distance: B.Type) where A: BinaryInteger, B: BinaryInteger {
            //=----------------------------------=
            let a0 = A(repeating: 0)
            let a1 = A(repeating: 1)
            //=----------------------------------=
            for distance: B in (-4 as IX ..< 4).lazy.map(B.init(load:))  {
                Test().upshift(a0, distance, a0)
            }
            
            always: do {
                Test().upshift(a1,  0 as B, a1 &* 1)
                Test().upshift(a1,  1 as B, a1 &* 2)
                Test().upshift(a1,  2 as B, a1 &* 4)
                Test().upshift(a1,  3 as B, a1 &* 8)
            }
            
            if  B.isSigned {
                Test().upshift(a1, ~0 as B, Bool(a1.appendix) ? a1 : a1 /  2)
                Test().upshift(a1, ~1 as B, Bool(a1.appendix) ? a1 : a1 /  4)
                Test().upshift(a1, ~2 as B, Bool(a1.appendix) ? a1 : a1 /  8)
                Test().upshift(a1, ~3 as B, Bool(a1.appendix) ? a1 : a1 / 16)
            }
            
            if !B.isSigned, A.size <= Swift.max(B.size, Count(255 - 3)) {
                Test().upshift(a1, ~0 as B, a0) // distance >= U8.max - 0
                Test().upshift(a1, ~1 as B, a0) // distance >= U8.max - 1
                Test().upshift(a1, ~2 as B, a0) // distance >= U8.max - 2
                Test().upshift(a1, ~3 as B, a0) // distance >= U8.max - 3
            }
            
            if  let size = IX(size: A.self), let flush = B.exactly(size).optional() {
                for increment in B.zero ..< 4 {
                    let distance = flush + increment
                    Test().upshift(a0, distance, a0)
                    Test().upshift(a1, distance, a0)
                }
            }
        }
        
        for value in arbitraryIntegers {
            for distance in binaryIntegers {
                whereIs(value: value, distance: distance)
            }
        }
    }
    
    /// - Note: The systems integer constraint adds masking shift tests.
    func testUpshiftRepeatingBitByGenericDistancesAsSystemsInteger() {
        func whereIs<A, B>(value: A.Type, distance: B.Type) where A: SystemsInteger, B: BinaryInteger {
            //=----------------------------------=
            let a0 = A(repeating: 0)
            let a1 = A(repeating: 1)
            //=----------------------------------=
            for distance: B in (-4 as IX ..< 4).lazy.map(B.init(load:))  {
                Test().upshift(a0, distance, a0)
            }
            
            always: do {
                Test().upshift(a1,  0 as B, a1 &* 1)
                Test().upshift(a1,  1 as B, a1 &* 2)
                Test().upshift(a1,  2 as B, a1 &* 4)
                Test().upshift(a1,  3 as B, a1 &* 8)
            }
            
            if  B.isSigned {
                Test().upshift(a1, ~0 as B, Bool(a1.appendix) ? a1 : a1 /  2)
                Test().upshift(a1, ~1 as B, Bool(a1.appendix) ? a1 : a1 /  4)
                Test().upshift(a1, ~2 as B, Bool(a1.appendix) ? a1 : a1 /  8)
                Test().upshift(a1, ~3 as B, Bool(a1.appendix) ? a1 : a1 / 16)
            }
            
            if !B.isSigned, A.size <= Swift.max(B.size, Count(255 - 3)) {
                Test().upshift(a1, ~0 as B, a0) // distance >= U8.max - 0
                Test().upshift(a1, ~1 as B, a0) // distance >= U8.max - 1
                Test().upshift(a1, ~2 as B, a0) // distance >= U8.max - 2
                Test().upshift(a1, ~3 as B, a0) // distance >= U8.max - 3
            }
            
            if  let size = IX(size: A.self), let flush = B.exactly(size).optional() {
                for increment in B.zero ..< 4 {
                    let distance = flush + increment
                    Test().upshift(a0, distance, a0)
                    Test().upshift(a1, distance, a0)
                }
            }
        }
        
        for value in systemsIntegers {
            for distance in binaryIntegers {
                whereIs(value: value, distance: distance)
            }
        }
    }
    
    func testDownshiftRepeatingBitByGenericDistancesAsArbitraryInteger() {
        func whereIs<A, B>(value: A.Type, distance: B.Type) where A: BinaryInteger, B: BinaryInteger {
            //=----------------------------------=
            let a0 = A(repeating: 0)
            let a1 = A(repeating: 1)
            //=----------------------------------=
            for distance: B in (-4 as IX ..< 4).lazy.map(B.init(load:))  {
                Test().downshift(a0, distance, a0)
            }
            
            always: do {
                Test().downshift(a1,  0 as B, Bool(a1.appendix) ? a1 : a1 / 1)
                Test().downshift(a1,  1 as B, Bool(a1.appendix) ? a1 : a1 / 2)
                Test().downshift(a1,  2 as B, Bool(a1.appendix) ? a1 : a1 / 4)
                Test().downshift(a1,  3 as B, Bool(a1.appendix) ? a1 : a1 / 8)
            }
                
            if  B.isSigned {
                Test().downshift(a1, ~0 as B, a1 &*  2)
                Test().downshift(a1, ~1 as B, a1 &*  4)
                Test().downshift(a1, ~2 as B, a1 &*  8)
                Test().downshift(a1, ~3 as B, a1 &* 16)
            }
            
            if !B.isSigned, A.size <= Swift.max(B.size, Count(255 - 3)) {
                Test().downshift(a1, ~0 as B, A(repeating: a1.appendix)) // distance >= U8.max - 0
                Test().downshift(a1, ~1 as B, A(repeating: a1.appendix)) // distance >= U8.max - 1
                Test().downshift(a1, ~2 as B, A(repeating: a1.appendix)) // distance >= U8.max - 2
                Test().downshift(a1, ~3 as B, A(repeating: a1.appendix)) // distance >= U8.max - 3
            }
            
            if  let size = IX(size: A.self), let flush = B.exactly(size).optional() {
                for increment in B.zero ..< 4 {
                    let distance = flush + increment
                    Test().downshift(a0, distance, A(repeating: a0.appendix))
                    Test().downshift(a1, distance, A(repeating: a1.appendix))
                }
            }
        }
        
        for value in arbitraryIntegers {
            for distance in binaryIntegers {
                whereIs(value: value, distance: distance)
            }
        }
    }
    
    /// - Note: The systems integer constraint adds masking shift tests.
    func testDownshiftRepeatingBitByGenericDistancesAsSystemsInteger() {
        func whereIs<A, B>(value: A.Type, distance: B.Type) where A: SystemsInteger, B: BinaryInteger {
            //=----------------------------------=
            let a0 = A(repeating: 0)
            let a1 = A(repeating: 1)
            //=----------------------------------=
            for distance: B in (-4 as IX ..< 4).lazy.map(B.init(load:))  {
                Test().downshift(a0, distance, a0)
            }
            
            always: do {
                Test().downshift(a1,  0 as B, Bool(a1.appendix) ? a1 : a1 / 1)
                Test().downshift(a1,  1 as B, Bool(a1.appendix) ? a1 : a1 / 2)
                Test().downshift(a1,  2 as B, Bool(a1.appendix) ? a1 : a1 / 4)
                Test().downshift(a1,  3 as B, Bool(a1.appendix) ? a1 : a1 / 8)
            }
                
            if  B.isSigned {
                Test().downshift(a1, ~0 as B, a1 &*  2)
                Test().downshift(a1, ~1 as B, a1 &*  4)
                Test().downshift(a1, ~2 as B, a1 &*  8)
                Test().downshift(a1, ~3 as B, a1 &* 16)
            }
            
            if !B.isSigned, A.size <= Swift.max(B.size, Count(255 - 3)) {
                Test().downshift(a1, ~0 as B, A(repeating: a1.appendix)) // distance >= U8.max - 0
                Test().downshift(a1, ~1 as B, A(repeating: a1.appendix)) // distance >= U8.max - 1
                Test().downshift(a1, ~2 as B, A(repeating: a1.appendix)) // distance >= U8.max - 2
                Test().downshift(a1, ~3 as B, A(repeating: a1.appendix)) // distance >= U8.max - 3
            }
            
            if  let size = IX(size: A.self), let flush = B.exactly(size).optional() {
                for increment in B.zero ..< 4 {
                    let distance = flush + increment
                    Test().downshift(a0, distance, A(repeating: a0.appendix))
                    Test().downshift(a1, distance, A(repeating: a1.appendix))
                }
            }
        }
        
        for value in systemsIntegers {
            for distance in binaryIntegers {
                whereIs(value: value, distance: distance)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSmartShiftByMoreThanSizeIsFlush() {
        func whereIs<A, B>(value: A.Type, distance: B.Type) where A: SystemsInteger, B: BinaryInteger {
            for base: A in (-4 as IX ..< 4).lazy.map(A.init(load:)) {
                for increment: B in 1 ..< 4 {
                    let distance = B(IX(size: A.self)) + increment
                    
                    always: do {
                        Test()  .upshift(base, distance, A(repeating: 0))
                        Test().downshift(base, distance, A(repeating: base.appendix))
                    }
                    
                    if  let distance = distance.negated().optional() {
                        Test()  .upshift(base, distance, A(repeating: base.appendix))
                        Test().downshift(base, distance, A(repeating: 0))
                    }
                }
            }
        }
        
        for value in systemsIntegers {
            for distance in arbitraryIntegers {
                whereIs(value: value, distance: distance)
            }
        }
    }
    
    func testSmartShiftByMoreThanMaxSignedWordIsFlush() {
        func whereIs<A, B>(value: A.Type, distance: B.Type) where A: BinaryInteger, B: BinaryInteger {
            for base: A in (-4 as IX ..< 4).lazy.map(A.init(load:)) {
                for increment: B in 1 ..< 4 {
                    let distance = B(IX.max) + increment
                    
                    always: do {
                        Test()  .upshift(base, distance, A(repeating: 0))
                        Test().downshift(base, distance, A(repeating: base.appendix))
                    }
                    
                    if  let distance = distance.negated().optional() {
                        Test()  .upshift(base, distance, A(repeating: base.appendix))
                        Test().downshift(base, distance, A(repeating: 0))
                    }
                }
            }
        }
        
        for value in binaryIntegers {
            for distance in arbitraryIntegers {
                whereIs(value: value, distance: distance)
            }
        }
    }
    
    func testSmartShiftIsLikeWrappingProductOrQuotientAsSystemsInteger() {
        func whereIs<T>(value: T.Type) where T: SystemsInteger {
            var instance = T.lsb

            shift: while !instance.isZero {
                var multiplier = Fallible(T.lsb)
                
                for distance in IX.zero ..< IX(size: T.self) {
                    let product  = instance &* multiplier.value
                    var quotient = distance.isZero ? instance : instance / multiplier.value
                    
                    if  multiplier.error {
                        Test().yay (T.isSigned)
                        Test().same(multiplier.value, T.msb)
                        quotient = quotient.negated().unwrap()
                    }
                    
                    Test()  .upshift(instance, distance, product)
                    Test().downshift(instance, distance, quotient)
                    multiplier = multiplier.times(2)
                }
                
                instance = instance.times(2).value // << 1
            }
        }
        
        for value in coreSystemsIntegers {
            whereIs(value: value)
        }
        
        whereIs(value: DoubleInt<I8>.self)
        whereIs(value: DoubleInt<U8>.self)
    }
}
