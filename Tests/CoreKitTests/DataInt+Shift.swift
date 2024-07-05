//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Data Int x Subtraction
//*============================================================================*

extension DataIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Ascending
    //=------------------------------------------------------------------------=
    
    func testUpshiftByMinor() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            let size = IX(size: T.self)
            let base = [01, 02, 03, 04] as [T]
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                C(base).upshift(0, environment: x, is: [(x >> (size - 0)) | 1,  2,  3,  4] as [T])
                C(base).upshift(1, environment: x, is: [(x >> (size - 1)) | 2,  4,  6,  8] as [T])
                C(base).upshift(2, environment: x, is: [(x >> (size - 2)) | 4,  8, 12, 16] as [T])
                C(base).upshift(3, environment: x, is: [(x >> (size - 3)) | 8, 16, 24, 32] as [T])
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }

    func testUpshiftByMajor() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            let size = IX(size: T.self)
            let base = [01, 02, 03, 04] as [T]
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                C(base).upshift(0 * size, environment: x, is: [ 1,  2,  3,  4] as [T])
                C(base).upshift(1 * size, environment: x, is: [ x,  1,  2,  3] as [T])
                C(base).upshift(2 * size, environment: x, is: [ x,  x,  1,  2] as [T])
                C(base).upshift(3 * size, environment: x, is: [ x,  x,  x,  1] as [T])
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }

    func testUpshiftByMajorMinor() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            let size = IX(size: T.self)
            let base = [01, 02, 03, 04] as [T]
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                
                let y = (x &<<  3) | (x &>> ~2)
                let z = (00000008) | (x &>> ~2)
                
                C(base).upshift(0 * size + 3, environment: x, is: [ z, 16, 24, 32] as [T])
                C(base).upshift(1 * size + 3, environment: x, is: [ y,  z, 16, 24] as [T])
                C(base).upshift(2 * size + 3, environment: x, is: [ y,  y,  z, 16] as [T])
                C(base).upshift(3 * size + 3, environment: x, is: [ y,  y,  y,  z] as [T])
            }
        }
                
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }

    func testUpshiftSuchThatElementsSplit() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            let size = IX(size: T.self)
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                
                let a: T = (x &<< 1) | (x &>> ~0)
                let b: T = (x  >> (size - 1))
                
                C([~0,  0,  0,  0] as [T]).upshift(0 * size + 1, environment: x, is: [b | ~1,  1,  0,  0] as [T])
                C([ 0, ~0,  0,  0] as [T]).upshift(0 * size + 1, environment: x, is: [b |  0, ~1,  1,  0] as [T])
                C([ 0,  0, ~0,  0] as [T]).upshift(0 * size + 1, environment: x, is: [b |  0,  0, ~1,  1] as [T])
                C([ 0,  0,  0, ~0] as [T]).upshift(0 * size + 1, environment: x, is: [b |  0,  0,  0, ~1] as [T])
                
                C([~0,  0,  0,  0] as [T]).upshift(1 * size + 1, environment: x, is: [a,  b | ~1,  1,  0] as [T])
                C([ 0, ~0,  0,  0] as [T]).upshift(1 * size + 1, environment: x, is: [a,  b |  0, ~1,  1] as [T])
                C([ 0,  0, ~0,  0] as [T]).upshift(1 * size + 1, environment: x, is: [a,  b |  0,  0, ~1] as [T])
                C([ 0,  0,  0, ~0] as [T]).upshift(1 * size + 1, environment: x, is: [a,  b |  0,  0,  0] as [T])
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Descending
    //=------------------------------------------------------------------------=
    
    func testDownshiftByMinor() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            let size = IX(size: T.self)
            let base = [08, 16, 24, 32] as [T]
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                C(base).downshift(0, environment: x, is: [ 8, 16, 24, 32 | (x << (size - 0))] as [T])
                C(base).downshift(1, environment: x, is: [ 4,  8, 12, 16 | (x << (size - 1))] as [T])
                C(base).downshift(2, environment: x, is: [ 2,  4,  6,  8 | (x << (size - 2))] as [T])
                C(base).downshift(3, environment: x, is: [ 1,  2,  3,  4 | (x << (size - 3))] as [T])
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }

    func testDownshiftByMajor() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            let size = IX(size: T.self)
            let base = [08, 16, 24, 32] as [T]
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                C(base).downshift(0 * size, environment: x, is: [ 8, 16, 24, 32] as [T])
                C(base).downshift(1 * size, environment: x, is: [16, 24, 32,  x] as [T])
                C(base).downshift(2 * size, environment: x, is: [24, 32,  x,  x] as [T])
                C(base).downshift(3 * size, environment: x, is: [32,  x,  x,  x] as [T])
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }

    func testDownshiftByMajorMinor() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            let size = IX(size: T.self)
            let base = [08, 16, 24, 32] as [T]
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                
                let a = (x &>>  3) | (x &<< ~2)
                let b = (00000004) | (x &<< ~2)
                
                C(base).downshift(0 * size + 3, environment: x, is: [ 1,  2,  3,  b] as [T])
                C(base).downshift(1 * size + 3, environment: x, is: [ 2,  3,  b,  a] as [T])
                C(base).downshift(2 * size + 3, environment: x, is: [ 3,  b,  a,  a] as [T])
                C(base).downshift(3 * size + 3, environment: x, is: [ b,  a,  a,  a] as [T])
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }

    func testDownshiftSuchThatElementsSplit() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            let size = IX(size: T.self)
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                
                let a: T = (x &>> 1) | (x &<< ~0)
                let b: T = (x  << (size - 1))
                let c: T = (1  << (size - 1))
                
                C([0,  0,  0,  7] as [T]).downshift(0 * size + 1, environment: x, is: [ 0, 0, c, 3 | b] as [T])
                C([0,  0,  7,  0] as [T]).downshift(0 * size + 1, environment: x, is: [ 0, c, 3, 0 | b] as [T])
                C([0,  7,  0,  0] as [T]).downshift(0 * size + 1, environment: x, is: [ c, 3, 0, 0 | b] as [T])
                C([7,  0,  0,  0] as [T]).downshift(0 * size + 1, environment: x, is: [ 3, 0, 0, 0 | b] as [T])
                
                C([0,  0,  0,  7] as [T]).downshift(1 * size + 1, environment: x, is: [ 0, c, 3 | b, a] as [T])
                C([0,  0,  7,  0] as [T]).downshift(1 * size + 1, environment: x, is: [ c, 3, 0 | b, a] as [T])
                C([0,  7,  0,  0] as [T]).downshift(1 * size + 1, environment: x, is: [ 3, 0, 0 | b, a] as [T])
                C([7,  0,  0,  0] as [T]).downshift(1 * size + 1, environment: x, is: [ 0, 0, 0 | b, a] as [T])
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testBitshiftAlternatingPattern() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            for count: Swift.Int in 0 ..< 4 {
                //=------------------------------=
                let a = Array(repeating: T(load: 0xAAAAAAAAAAAAAAAA as U64), count: count)
                let b = Array(repeating: T(load: 0x5555555555555555 as U64), count: count)
                //=------------------------------=
                for distance in 0 ..< IX(size: T.self) * IX(count) {
                    let even = !Bool(distance.lsb)
                    C(a).upshift  (distance, environment: a.first!, is: even ? a : b)
                    C(a).downshift(distance, environment: a.first!, is: even ? a : b)
                    C(b).upshift  (distance, environment: b.first!, is: even ? b : a)
                    C(b).downshift(distance, environment: b.first!, is: even ? b : a)
                }
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Shift x Assertions
//*============================================================================*

extension DataIntTests.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func upshift(_ distance: IX, environment: Element, is expectation: [Element]) {
        //=------------------------------------------=
        let (major, minor) = distance.division(Divisor(IX(size: Element.self))).unwrap().components()
        //=------------------------------------------=
        always: do {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.upshift(major: major, minor: minor, environment: environment)
            }
            
            test.same(value, expectation)
        }
        
        if  environment.isZero {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.upshift(major: major, minor: minor)
            }
            
            test.same(value, expectation)
        }
        
        if  major >= 1, minor == 0 {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.upshift(majorAtLeastOne: major, minor: (( )), environment: environment)
            }
            
            test.same(value, expectation)
        }
        
        if  major >= 1, minor == 0, environment.isZero {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.upshift(majorAtLeastOne: major, minor: (( )))
            }
            
            test.same(value, expectation)
        }
        
        if  major >= 0, minor >= 1 {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.upshift(major: major, minorAtLeastOne: minor, environment: environment)
            }
            
            test.same(value, expectation)
        }
        
        if  major >= 0, minor >= 1, environment.isZero {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.upshift(major: major, minorAtLeastOne: minor)
            }
            
            test.same(value, expectation)
        }
    }

    func downshift(_ distance: IX, environment: Element, is expectation: [Element]) {
        //=------------------------------------------=
        let (major, minor) = distance.division(Divisor(IX(size: Element.self))).unwrap().components()
        //=------------------------------------------=
        always: do {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.downshift(major: major, minor: minor, environment: environment)
            }
            
            test.same(value, expectation)
        }
        
        if  environment.isZero {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.downshift(major: major, minor: minor)
            }
            
            test.same(value, expectation)
        }
        
        if  major >= 1, minor == 0 {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.downshift(majorAtLeastOne: major, minor: (( )), environment: environment)
            }
            
            test.same(value, expectation)
        }
        
        if  major >= 1, minor == 0, environment.isZero {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.downshift(majorAtLeastOne: major, minor: (( )))
            }
            
            test.same(value, expectation)
        }
        
        if  major >= 0, minor >= 1 {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.downshift(major: major, minorAtLeastOne: minor, environment: environment)
            }
            
            test.same(value, expectation)
        }
        
        if  major >= 0, minor >= 1, environment.isZero {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.downshift(major: major, minorAtLeastOne: minor)
            }
            
            test.same(value, expectation)
        }
    }
}
