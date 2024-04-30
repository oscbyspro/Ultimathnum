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
            typealias C = DataIntTests.Canvas<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            let base = [01, 02, 03, 04] as [T]
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                C(base).upshift(by: 0, with: x, is:[(x >> (T.size - 0)) | 1,  2,  3,  4] as [T])
                C(base).upshift(by: 1, with: x, is:[(x >> (T.size - 1)) | 2,  4,  6,  8] as [T])
                C(base).upshift(by: 2, with: x, is:[(x >> (T.size - 2)) | 4,  8, 12, 16] as [T])
                C(base).upshift(by: 3, with: x, is:[(x >> (T.size - 3)) | 8, 16, 24, 32] as [T])
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }

    func testUpshiftByMajor() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Canvas<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            let size = IX(size: T.self)
            let base = [01, 02, 03, 04] as [T]
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                C(base).upshift(by: 0 * size, with: x, is:[ 1,  2,  3,  4] as [T])
                C(base).upshift(by: 1 * size, with: x, is:[ x,  1,  2,  3] as [T])
                C(base).upshift(by: 2 * size, with: x, is:[ x,  x,  1,  2] as [T])
                C(base).upshift(by: 3 * size, with: x, is:[ x,  x,  x,  1] as [T])
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }

    func testUpshiftByMajorMinor() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Canvas<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            let size = IX(size: T.self)
            let base = [01, 02, 03, 04] as [T]
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                let y = (x &<<  3) | (x &>> ~2)
                let z = (00000008) | (x &>> ~2)
                C(base).upshift(by: 0 * size + 3, with: x, is:[ z, 16, 24, 32] as [T])
                C(base).upshift(by: 1 * size + 3, with: x, is:[ y,  z, 16, 24] as [T])
                C(base).upshift(by: 2 * size + 3, with: x, is:[ y,  y,  z, 16] as [T])
                C(base).upshift(by: 3 * size + 3, with: x, is:[ y,  y,  y,  z] as [T])
            }
        }
                
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }

    func testUpshiftSuchThatElementsSplit() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Canvas<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                C([~0,  0,  0,  0] as [T]).upshift(by: 1, with: x, is:[(x >> (T.size - 1)) | ~1,  1,  0,  0] as [T])
                C([ 0, ~0,  0,  0] as [T]).upshift(by: 1, with: x, is:[(x >> (T.size - 1)) |  0, ~1,  1,  0] as [T])
                C([ 0,  0, ~0,  0] as [T]).upshift(by: 1, with: x, is:[(x >> (T.size - 1)) |  0,  0, ~1,  1] as [T])
                C([ 0,  0,  0, ~0] as [T]).upshift(by: 1, with: x, is:[(x >> (T.size - 1)) |  0,  0,  0, ~1] as [T])
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
            typealias C = DataIntTests.Canvas<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            let base = [08, 16, 24, 32] as [T]
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                C(base).downshift(by: 0, with: x, is:[ 8, 16, 24, 32 | (x << (T.size - 0))] as [T])
                C(base).downshift(by: 1, with: x, is:[ 4,  8, 12, 16 | (x << (T.size - 1))] as [T])
                C(base).downshift(by: 2, with: x, is:[ 2,  4,  6,  8 | (x << (T.size - 2))] as [T])
                C(base).downshift(by: 3, with: x, is:[ 1,  2,  3,  4 | (x << (T.size - 3))] as [T])
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }

    func testDownshiftByMajor() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Canvas<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            let size = IX(size: T.self)
            let base = [08, 16, 24, 32] as [T]
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                C(base).downshift(by: 0 * size, with: x, is:[ 8, 16, 24, 32] as [T])
                C(base).downshift(by: 1 * size, with: x, is:[16, 24, 32,  x] as [T])
                C(base).downshift(by: 2 * size, with: x, is:[24, 32,  x,  x] as [T])
                C(base).downshift(by: 3 * size, with: x, is:[32,  x,  x,  x] as [T])
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }

    func testDownshiftByMajorMinor() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Canvas<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            let size = IX(size: T.self)
            let base = [08, 16, 24, 32] as [T]
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                let y = (x &>>  3) | (x &<< ~2)
                let z = (00000004) | (x &<< ~2)
                C(base).downshift(by: 0 * size + 3, with: x, is:[ 1,  2,  3,  z] as [T])
                C(base).downshift(by: 1 * size + 3, with: x, is:[ 2,  3,  z,  y] as [T])
                C(base).downshift(by: 2 * size + 3, with: x, is:[ 3,  z,  y,  y] as [T])
                C(base).downshift(by: 3 * size + 3, with: x, is:[ z,  y,  y,  y] as [T])
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }

    func testDownshiftSuchThatElementsSplit() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Canvas<T>
            typealias F = Fallible<[T]>
            //=----------------------------------=
            for x: T in [0, 1, ~1, ~0] {
                C([0,  0,  0,  7] as [T]).downshift(by: 1, with: x, is:[ 0, 0, 1 << (T.size - 1), 3 | (x << (T.size - 1))] as [T])
                C([0,  0,  7,  0] as [T]).downshift(by: 1, with: x, is:[ 0, 1 << (T.size - 1), 3, 0 | (x << (T.size - 1))] as [T])
                C([0,  7,  0,  0] as [T]).downshift(by: 1, with: x, is:[ 1 << (T.size - 1), 3, 0, 0 | (x << (T.size - 1))] as [T])
                C([7,  0,  0,  0] as [T]).downshift(by: 1, with: x, is:[                 3, 0, 0, 0 | (x << (T.size - 1))] as [T])
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

extension DataIntTests.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func upshift(by distance: IX, with environment: Element, is expectation: [Element]) {
        //=------------------------------------------=
        let (major, minor) = distance.division(Divisor(IX(size: Element.self))!).unwrap().components()
        //=------------------------------------------=
        always: do {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.upshift(environment: environment, major: major, minor: minor)
            }
            
            test.same(value, expectation)
        }
        
        if  major >= 1, minor == 0 {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.upshift(environment: environment, majorAtLeastOne: major, minor: Void())
            }
            
            test.same(value, expectation)
        }
        
        if  major >= 0, minor >= 1 {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.upshift(environment: environment, major: major, minorAtLeastOne: minor)
            }
            
            test.same(value, expectation)
        }
    }

    func downshift(by distance: IX, with environment: Element, is expectation: [Element]) {
        //=------------------------------------------=
        let (major, minor) = distance.division(Divisor(IX(size: Element.self))!).unwrap().components()
        //=------------------------------------------=
        always: do {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.downshift(environment: environment, major: major, minor: minor)
            }
            
            test.same(value, expectation)
        }
        
        if  major >= 1, minor == 0 {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.downshift(environment: environment, majorAtLeastOne: major, minor: Void())
            }
            
            test.same(value, expectation)
        }
        
        if  major >= 0, minor >= 1 {
            var value = self.body
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                value.downshift(environment: environment, major: major, minorAtLeastOne: minor)
            }
            
            test.same(value, expectation)
        }
    }
}
