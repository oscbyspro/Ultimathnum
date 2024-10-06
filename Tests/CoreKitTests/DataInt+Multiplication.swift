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
// MARK: * Data Int x Multiplication
//*============================================================================*

extension DataIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// - Note: The increment must be zero if the combined input size is zero.
    func testMultiplication00() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            
            C([] as [T]).times([] as [T], plus: 0, is:[] as [T])
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testMultiplication10() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            
            for value: T in [~2, ~1, ~0, 0, 1, 2] {
                for increment: T in [~2, ~1, ~0, 0, 1, 2] {
                    C([value] as [T]).times([     ] as [T], plus: increment, is:[increment] as [T])
                    C([     ] as [T]).times([value] as [T], plus: increment, is:[increment] as [T])
                }
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testMultiplication11() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            
            for increment: (T) in [0, 1, ~1, ~0] {
                C([ 0] as [T]).times([ 0] as [T], plus: increment, is:[increment, 0] as [T])
                C([ 1] as [T]).times([ 0] as [T], plus: increment, is:[increment, 0] as [T])
                C([~1] as [T]).times([ 0] as [T], plus: increment, is:[increment, 0] as [T])
                C([~0] as [T]).times([ 0] as [T], plus: increment, is:[increment, 0] as [T])
            }
            
            C([ 1] as [T]).times([ 2] as [T], plus:  0, is:[ 2,  0] as [T])
            C([ 1] as [T]).times([ 2] as [T], plus:  1, is:[ 3,  0] as [T])
            C([ 1] as [T]).times([ 2] as [T], plus: ~1, is:[ 0,  1] as [T])
            C([ 1] as [T]).times([ 2] as [T], plus: ~0, is:[ 1,  1] as [T])
            
            C([~1] as [T]).times([~2] as [T], plus:  0, is:[ 6, ~4] as [T])
            C([~1] as [T]).times([~2] as [T], plus:  1, is:[ 7, ~4] as [T])
            C([~1] as [T]).times([~2] as [T], plus: ~1, is:[ 4, ~3] as [T])
            C([~1] as [T]).times([~2] as [T], plus: ~0, is:[ 5, ~3] as [T])
            
            C([~0] as [T]).times([~0] as [T], plus:  0, is:[ 1, ~1] as [T])
            C([~0] as [T]).times([~0] as [T], plus:  1, is:[ 2, ~1] as [T])
            C([~0] as [T]).times([~0] as [T], plus: ~1, is:[~0, ~1] as [T])
            C([~0] as [T]).times([~0] as [T], plus: ~0, is:[ 0, ~0] as [T])
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testMultiplication21() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            
            C([ 0,  0] as [T]).times([ 0] as [T], plus:  0, is:[ 0,  0,  0] as [T])
            C([ 0,  0] as [T]).times([ 0] as [T], plus:  1, is:[ 1,  0,  0] as [T])
            C([ 0,  0] as [T]).times([ 0] as [T], plus: ~1, is:[~1,  0,  0] as [T])
            C([ 0,  0] as [T]).times([ 0] as [T], plus: ~0, is:[~0,  0,  0] as [T])
            
            C([ 0,  1] as [T]).times([ 2] as [T], plus:  0, is:[ 0,  2,  0] as [T])
            C([ 0,  1] as [T]).times([ 2] as [T], plus:  1, is:[ 1,  2,  0] as [T])
            C([ 0,  1] as [T]).times([ 2] as [T], plus: ~1, is:[~1,  2,  0] as [T])
            C([ 0,  1] as [T]).times([ 2] as [T], plus: ~0, is:[~0,  2,  0] as [T])

            C([~0, ~1] as [T]).times([~2] as [T], plus:  0, is:[ 3,  2, ~3] as [T])
            C([~0, ~1] as [T]).times([~2] as [T], plus:  1, is:[ 4,  2, ~3] as [T])
            C([~0, ~1] as [T]).times([~2] as [T], plus: ~1, is:[ 1,  3, ~3] as [T])
            C([~0, ~1] as [T]).times([~2] as [T], plus: ~0, is:[ 2,  3, ~3] as [T])
            
            C([~0, ~0] as [T]).times([~0] as [T], plus:  0, is:[ 1, ~0, ~1] as [T])
            C([~0, ~0] as [T]).times([~0] as [T], plus:  1, is:[ 2, ~0, ~1] as [T])
            C([~0, ~0] as [T]).times([~0] as [T], plus: ~1, is:[~0, ~0, ~1] as [T])
            C([~0, ~0] as [T]).times([~0] as [T], plus: ~0, is:[ 0,  0, ~0] as [T])
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testMultiplication22() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            
            C([ 0,  0] as [T]).times([ 0,  0] as [T], plus:  0, is:[ 0,  0,  0,  0] as [T])
            C([ 0,  0] as [T]).times([ 0,  0] as [T], plus:  1, is:[ 1,  0,  0,  0] as [T])
            C([ 0,  0] as [T]).times([ 0,  0] as [T], plus: ~1, is:[~1,  0,  0,  0] as [T])
            C([ 0,  0] as [T]).times([ 0,  0] as [T], plus: ~0, is:[~0,  0,  0,  0] as [T])
            
            C([ 0,  1] as [T]).times([ 2,  3] as [T], plus:  0, is:[ 0,  2,  3,  0] as [T])
            C([ 0,  1] as [T]).times([ 2,  3] as [T], plus:  1, is:[ 1,  2,  3,  0] as [T])
            C([ 0,  1] as [T]).times([ 2,  3] as [T], plus: ~1, is:[~1,  2,  3,  0] as [T])
            C([ 0,  1] as [T]).times([ 2,  3] as [T], plus: ~0, is:[~0,  2,  3,  0] as [T])

            C([~0, ~1] as [T]).times([~2, ~3] as [T], plus:  0, is:[ 3,  6, ~0, ~4] as [T])
            C([~0, ~1] as [T]).times([~2, ~3] as [T], plus:  1, is:[ 4,  6, ~0, ~4] as [T])
            C([~0, ~1] as [T]).times([~2, ~3] as [T], plus: ~1, is:[ 1,  7, ~0, ~4] as [T])
            C([~0, ~1] as [T]).times([~2, ~3] as [T], plus: ~0, is:[ 2,  7, ~0, ~4] as [T])

            C([~0, ~0] as [T]).times([~0, ~0] as [T], plus:  0, is:[ 1,  0, ~1, ~0] as [T])
            C([~0, ~0] as [T]).times([~0, ~0] as [T], plus:  1, is:[ 2,  0, ~1, ~0] as [T])
            C([~0, ~0] as [T]).times([~0, ~0] as [T], plus: ~1, is:[~0,  0, ~1, ~0] as [T])
            C([~0, ~0] as [T]).times([~0, ~0] as [T], plus: ~0, is:[ 0,  1, ~1, ~0] as [T])
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplication41() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            
            C([ 0,  0,  0,  0] as [T]).times([ 0] as [T], plus:  0, is:[ 0,  0,  0,  0,  0] as [T])
            C([ 0,  0,  0,  0] as [T]).times([ 0] as [T], plus: ~0, is:[~0,  0,  0,  0,  0] as [T])
            C([ 0,  0,  0,  0] as [T]).times([~0] as [T], plus:  0, is:[ 0,  0,  0,  0,  0] as [T])
            C([ 0,  0,  0,  0] as [T]).times([~0] as [T], plus: ~0, is:[~0,  0,  0,  0,  0] as [T])
            C([~0, ~0, ~0, ~0] as [T]).times([ 0] as [T], plus:  0, is:[ 0,  0,  0,  0,  0] as [T])
            C([~0, ~0, ~0, ~0] as [T]).times([ 0] as [T], plus: ~0, is:[~0,  0,  0,  0,  0] as [T])
            C([~0, ~0, ~0, ~0] as [T]).times([~0] as [T], plus:  0, is:[ 1, ~0, ~0, ~0, ~1] as [T])
            C([~0, ~0, ~0, ~0] as [T]).times([~0] as [T], plus: ~0, is:[ 0,  0,  0,  0, ~0] as [T])
            
            C([ 0,  0,  0,  0] as [T]).times([ 1] as [T], plus:  0, is:[ 0,  0,  0,  0,  0] as [T])
            C([ 0,  0,  0,  0] as [T]).times([ 1] as [T], plus: ~0, is:[~0,  0,  0,  0,  0] as [T])
            C([ 0,  0,  0,  0] as [T]).times([~1] as [T], plus:  0, is:[ 0,  0,  0,  0,  0] as [T])
            C([ 0,  0,  0,  0] as [T]).times([~1] as [T], plus: ~0, is:[~0,  0,  0,  0,  0] as [T])
            C([~0, ~0, ~0, ~0] as [T]).times([ 1] as [T], plus:  0, is:[~0, ~0, ~0, ~0,  0] as [T])
            C([~0, ~0, ~0, ~0] as [T]).times([ 1] as [T], plus: ~0, is:[~1,  0,  0,  0,  1] as [T])
            C([~0, ~0, ~0, ~0] as [T]).times([~1] as [T], plus:  0, is:[ 2, ~0, ~0, ~0, ~2] as [T])
            C([~0, ~0, ~0, ~0] as [T]).times([~1] as [T], plus: ~0, is:[ 1,  0,  0,  0, ~1] as [T])
                        
            C([ 1,  2,  3,  4] as [T]).times([ 0] as [T], plus:  0, is:[ 0,  0,  0,  0,  0] as [T])
            C([ 1,  2,  3,  4] as [T]).times([ 1] as [T], plus:  0, is:[ 1,  2,  3,  4,  0] as [T])
            C([ 1,  2,  3,  4] as [T]).times([ 2] as [T], plus:  0, is:[ 2,  4,  6,  8,  0] as [T])
            C([ 1,  2,  3,  4] as [T]).times([~0] as [T], plus:  0, is:[~0, ~1, ~1, ~1,  3] as [T])
            C([ 1,  2,  3,  4] as [T]).times([~1] as [T], plus:  0, is:[~1, ~3, ~4, ~5,  3] as [T])
            C([ 1,  2,  3,  4] as [T]).times([~2] as [T], plus:  0, is:[~2, ~5, ~7, ~9,  3] as [T])
            
            C([ 1,  2,  3,  4] as [T]).times([ 0] as [T], plus:  5, is:[ 5,  0,  0,  0,  0] as [T])
            C([ 1,  2,  3,  4] as [T]).times([ 1] as [T], plus:  5, is:[ 6,  2,  3,  4,  0] as [T])
            C([ 1,  2,  3,  4] as [T]).times([ 2] as [T], plus:  5, is:[ 7,  4,  6,  8,  0] as [T])
            C([ 1,  2,  3,  4] as [T]).times([~0] as [T], plus:  5, is:[ 4, ~0, ~1, ~1,  3] as [T])
            C([ 1,  2,  3,  4] as [T]).times([~1] as [T], plus:  5, is:[ 3, ~2, ~4, ~5,  3] as [T])
            C([ 1,  2,  3,  4] as [T]).times([~2] as [T], plus:  5, is:[ 2, ~4, ~7, ~9,  3] as [T])
            
            C([~0, ~0, ~0, ~0] as [T]).times([ 0] as [T], plus:  0, is:[ 0,  0,  0,  0,  0] as [T])
            C([~0, ~0, ~0, ~0] as [T]).times([ 0] as [T], plus: ~0, is:[~0,  0,  0,  0,  0] as [T])
            C([~0, ~0, ~0, ~0] as [T]).times([~0] as [T], plus:  0, is:[ 1, ~0, ~0, ~0, ~1] as [T])
            C([~0, ~0, ~0, ~0] as [T]).times([~0] as [T], plus: ~0, is:[ 0,  0,  0,  0, ~0] as [T])
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testMultiplication44() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            
            C([ 0,  0,  0,  0] as [T]).times([ 0,  0,  0,  0] as [T], plus:  0, is:[ 0,  0,  0,  0,  0,  0,  0,  0] as [T])
            C([ 0,  0,  0,  0] as [T]).times([ 0,  0,  0,  0] as [T], plus:  1, is:[ 1,  0,  0,  0,  0,  0,  0,  0] as [T])
            C([ 0,  0,  0,  0] as [T]).times([ 0,  0,  0,  0] as [T], plus: ~1, is:[~1,  0,  0,  0,  0,  0,  0,  0] as [T])
            C([ 0,  0,  0,  0] as [T]).times([ 0,  0,  0,  0] as [T], plus: ~0, is:[~0,  0,  0,  0,  0,  0,  0,  0] as [T])
            
            C([~0, ~0, ~0, ~0] as [T]).times([~0, ~0, ~0, ~0] as [T], plus:  0, is:[ 1,  0,  0,  0, ~1, ~0, ~0, ~0] as [T])
            C([~0, ~0, ~0, ~0] as [T]).times([~0, ~0, ~0, ~0] as [T], plus:  1, is:[ 2,  0,  0,  0, ~1, ~0, ~0, ~0] as [T])
            C([~0, ~0, ~0, ~0] as [T]).times([~0, ~0, ~0, ~0] as [T], plus: ~1, is:[~0,  0,  0,  0, ~1, ~0, ~0, ~0] as [T])
            C([~0, ~0, ~0, ~0] as [T]).times([~0, ~0, ~0, ~0] as [T], plus: ~0, is:[ 0,  1,  0,  0, ~1, ~0, ~0, ~0] as [T])
            
            C([~0, ~0, ~0,  0] as [T]).times([~0, ~0, ~0,  0] as [T], plus:  0, is:[ 1,  0,  0, ~1, ~0, ~0,  0,  0] as [T])
            C([~0, ~0, ~0,  0] as [T]).times([~0, ~0, ~0,  0] as [T], plus:  1, is:[ 2,  0,  0, ~1, ~0, ~0,  0,  0] as [T])
            C([~0, ~0, ~0,  0] as [T]).times([~0, ~0, ~0,  0] as [T], plus: ~1, is:[~0,  0,  0, ~1, ~0, ~0,  0,  0] as [T])
            C([~0, ~0, ~0,  0] as [T]).times([~0, ~0, ~0,  0] as [T], plus: ~0, is:[ 0,  1,  0, ~1, ~0, ~0,  0,  0] as [T])
            
            C([ 0, ~0, ~0, ~0] as [T]).times([ 0, ~0, ~0, ~0] as [T], plus:  0, is:[ 0,  0,  1,  0,  0, ~1, ~0, ~0] as [T])
            C([ 0, ~0, ~0, ~0] as [T]).times([ 0, ~0, ~0, ~0] as [T], plus:  1, is:[ 1,  0,  1,  0,  0, ~1, ~0, ~0] as [T])
            C([ 0, ~0, ~0, ~0] as [T]).times([ 0, ~0, ~0, ~0] as [T], plus: ~1, is:[~1,  0,  1,  0,  0, ~1, ~0, ~0] as [T])
            C([ 0, ~0, ~0, ~0] as [T]).times([ 0, ~0, ~0, ~0] as [T], plus: ~0, is:[~0,  0,  1,  0,  0, ~1, ~0, ~0] as [T])
            
            C([ 1,  2,  3,  4] as [T]).times([ 2,  0,  0,  0] as [T], plus:  0, is:[ 2,  4,  6,  8,  0,  0,  0,  0] as [T])
            C([ 1,  2,  3,  4] as [T]).times([ 0,  2,  0,  0] as [T], plus:  0, is:[ 0,  2,  4,  6,  8,  0,  0,  0] as [T])
            C([ 1,  2,  3,  4] as [T]).times([ 0,  0,  2,  0] as [T], plus:  0, is:[ 0,  0,  2,  4,  6,  8,  0,  0] as [T])
            C([ 1,  2,  3,  4] as [T]).times([ 0,  0,  0,  2] as [T], plus:  0, is:[ 0,  0,  0,  2,  4,  6,  8,  0] as [T])
            
            C([ 1,  2,  3,  4] as [T]).times([ 2,  0,  0,  0] as [T], plus:  5, is:[ 7,  4,  6,  8,  0,  0,  0,  0] as [T])
            C([ 1,  2,  3,  4] as [T]).times([ 0,  2,  0,  0] as [T], plus:  5, is:[ 5,  2,  4,  6,  8,  0,  0,  0] as [T])
            C([ 1,  2,  3,  4] as [T]).times([ 0,  0,  2,  0] as [T], plus:  5, is:[ 5,  0,  2,  4,  6,  8,  0,  0] as [T])
            C([ 1,  2,  3,  4] as [T]).times([ 0,  0,  0,  2] as [T], plus:  5, is:[ 5,  0,  0,  2,  4,  6,  8,  0] as [T])
            
            C([~1, ~2, ~3, ~4] as [T]).times([ 2,  0,  0,  0] as [T], plus:  0, is:[~3, ~4, ~6, ~8,  1,  0,  0,  0] as [T])
            C([~1, ~2, ~3, ~4] as [T]).times([ 0,  2,  0,  0] as [T], plus:  0, is:[ 0, ~3, ~4, ~6, ~8,  1,  0,  0] as [T])
            C([~1, ~2, ~3, ~4] as [T]).times([ 0,  0,  2,  0] as [T], plus:  0, is:[ 0,  0, ~3, ~4, ~6, ~8,  1,  0] as [T])
            C([~1, ~2, ~3, ~4] as [T]).times([ 0,  0,  0,  2] as [T], plus:  0, is:[ 0,  0,  0, ~3, ~4, ~6, ~8,  1] as [T])
            
            C([~1, ~2, ~3, ~4] as [T]).times([ 2,  0,  0,  0] as [T], plus: ~5, is:[~9, ~3, ~6, ~8,  1,  0,  0,  0] as [T])
            C([~1, ~2, ~3, ~4] as [T]).times([ 0,  2,  0,  0] as [T], plus: ~5, is:[~5, ~3, ~4, ~6, ~8,  1,  0,  0] as [T])
            C([~1, ~2, ~3, ~4] as [T]).times([ 0,  0,  2,  0] as [T], plus: ~5, is:[~5,  0, ~3, ~4, ~6, ~8,  1,  0] as [T])
            C([~1, ~2, ~3, ~4] as [T]).times([ 0,  0,  0,  2] as [T], plus: ~5, is:[~5,  0,  0, ~3, ~4, ~6, ~8,  1] as [T])
            
            C([ 0,  0,  0,  0] as [T]).times([ 0,  0,  0,  0] as [T], plus:  0, is:[ 0,  0,  0,  0,  0,  0,  0,  0] as [T])
            C([ 1,  2,  3,  4] as [T]).times([ 1,  2,  3,  4] as [T], plus:  5, is:[ 6,  4, 10, 20, 25, 24, 16,  0] as [T])
            C([~1, ~2, ~3, ~4] as [T]).times([~1, ~2, ~3, ~4] as [T], plus: ~5, is:[~1,  8, 16, 28, 21, 20, 10, ~7] as [T])
            C([~0, ~0, ~0, ~0] as [T]).times([~0, ~0, ~0, ~0] as [T], plus: ~0, is:[ 0,  1,  0,  0, ~1, ~0, ~0, ~0] as [T])
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Multiplication x Assertions
//*============================================================================*

extension DataIntTests.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func times(_ multiplier: [Element], plus increment: Element, is expectation: [Element]) {
        always: do {
            self.timesOneWayOnly(multiplier, plus: increment, is: expectation)
        }
        
        if  self.body == multiplier {
            self.squareOneWayOnly(plus: increment, is: expectation)
        }   else {
            Self(multiplier, test: self.test).timesOneWayOnly(self.body, plus: increment, is: expectation)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func timesOneWayOnly(_ multiplier: [Element], plus increment: Element, is expectation: [Element]) {
        //=--------------------------------------=
        let count = self.body.count + multiplier.count
        //=--------------------------------------=
        // multiplication: expectation <= U64.max
        //=--------------------------------------=
        if  IX(expectation.count) * IX(size: Element.self) <= 64 {
            let a = self.body  .withUnsafeBufferPointer({ U64(load: DataInt($0)!) })
            let b = multiplier .withUnsafeBufferPointer({ U64(load: DataInt($0)!) })
            let c = expectation.withUnsafeBufferPointer({ U64(load: DataInt($0)!) })
            test.same(a * b + U64(increment), c, "U64")
        }
        //=--------------------------------------=
        // multiplication: many + some
        //=--------------------------------------=
        if !self.body.isEmpty, multiplier.count == 1, multiplier.first == 1 {
            var value = Array(expectation)
            let error = value.removeLast() != 0
            self.plus([increment], plus: false, is: Fallible(value, error: error))
        }
        //=--------------------------------------=
        // multiplication: many × some + some
        //=--------------------------------------=
        if  multiplier.count == 1 {
            var value = self.body
            let last  = value.withUnsafeMutableBufferPointer {
                MutableDataInt.Body($0)!.multiply(by: multiplier.first!, add: increment)
            }
            
            value.append(last)
            test.same(value, expectation)
        }
        //=--------------------------------------=
        // multiplication: many × many
        //=--------------------------------------=
        long: if increment == 0 {
            var value = [Element](repeating: 144, count: count)

            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                self.body.withUnsafeBufferPointer {
                    let body = DataInt.Body($0)!
                    multiplier.withUnsafeBufferPointer {
                        let multiplier = DataInt.Body($0)!
                        value.initializeByLongAlgorithm(to: body, times: multiplier)
                    }
                }
            }
            
            test.same(value, expectation)
        }
        
        karatsuba: if increment == 0 {
            var value = [Element](repeating: 144, count: count)

            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                self.body.withUnsafeBufferPointer {
                    let body = DataInt.Body($0)!
                    multiplier.withUnsafeBufferPointer {
                        let multiplier = DataInt.Body($0)!
                        value.initializeByKaratsubaAlgorithm(to: body, times: multiplier)
                    }
                }
            }
            
            test.same(value, expectation)
        }
        //=--------------------------------------=
        // multiplication: many × many + some
        //=--------------------------------------=
        long: do {
            var value = [Element](repeating: 144, count: count)

            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                self.body.withUnsafeBufferPointer {
                    let body = DataInt.Body($0)!
                    multiplier.withUnsafeBufferPointer {
                        let multiplier = DataInt.Body($0)!
                        value.initializeByLongAlgorithm(to: body, times: multiplier, plus: increment)
                    }
                }
            }
            
            test.same(value, expectation)
        }
    }
    
    func squareOneWayOnly(plus increment: Element, is expectation: [Element]) {
        //=--------------------------------------=
        let count = self.body.count * 2
        //=--------------------------------------=
        // multiplication: many × many
        //=--------------------------------------=
        long: if increment == 0 {
            var value = [Element](repeating: 144, count: count)
            
            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                self.body.withUnsafeBufferPointer {
                    let body = DataInt.Body($0)!
                    value.initializeByLongAlgorithm(toSquareProductOf: body)
                }
            }
            
            test.same(value, expectation)
        }
        
        karatsuba: if increment == 0 {
            var value = [Element](repeating: 144, count: count)

            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                self.body.withUnsafeBufferPointer {
                    let body = DataInt.Body($0)!
                    value.initializeByKaratsubaAlgorithm(toSquareProductOf: body)
                }
            }
            
            test.same(value, expectation)
        }
        //=--------------------------------------=
        // multiplication: many × many + some
        //=--------------------------------------=
        long: do {
            var value = [Element](repeating: 144, count: count)

            value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                self.body.withUnsafeBufferPointer {
                    let body = DataInt.Body($0)!
                    value.initializeByLongAlgorithm(toSquareProductOf: body, plus: increment)
                }
            }
            
            test.same(value, expectation)
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Addition x Assertions
//*============================================================================*
//=----------------------------------------------------------------------------=
// TODO: These are still used by our yet-to-be-replaced multiplication tests...
//=----------------------------------------------------------------------------=

extension DataIntTests.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    func plus(_ elements: [Element], plus bit: Bool, is expectation: Fallible<[Element]>) {
        //=--------------------------------------=
        var normal = elements[...]; while normal.last == 0 { normal.removeLast() }
        //=--------------------------------------=
        // increment: none + bit
        //=--------------------------------------=
        if  normal.count == 0, bit {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return value.increment().error
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        
        if  normal.count == 0 {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return value.increment(by: bit).error
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        //=--------------------------------------=
        // increment: some
        //=--------------------------------------=
        if  normal.count == 1, !bit {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return value.increment(by: normal.first!).error
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        //=--------------------------------------=
        // increment: some + bit
        //=--------------------------------------=
        if  normal.count == 1 {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return value.increment(by: normal.first!, plus: bit).error
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        //=--------------------------------------=
        // increment: many
        //=--------------------------------------=
        for many in [normal, elements[...]] where bit == false {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return (many).withUnsafeBufferPointer {
                    let many = DataInt.Body($0)!
                    return value.increment(by: many).error
                }
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        //=--------------------------------------=
        // increment: many + bit
        //=--------------------------------------=
        for many in [normal, elements[...]] {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return (many).withUnsafeBufferPointer {
                    let many = DataInt.Body($0)!
                    return value.increment(by: many, plus: bit).error
                }
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        
        for var many in [normal, elements[...]] where bit == false {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return (many).withUnsafeMutableBufferPointer {
                    let many = MutableDataInt.Body($0)!
                    many.toggle(carrying: bit).discard()
                    return value.increment(toggling: DataInt.Body(many), plus: bit).error
                }
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func plusSameSize(repeating pattern: Bool, plus bit: Bool, is expectation: Fallible<[Element]>) {
        //=--------------------------------------=
        if  pattern == bit {
            test.same(expectation, Fallible(self.body, error: bit))
        }
        //=--------------------------------------=
        // increment: none + bit
        //=--------------------------------------=
        if !pattern {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return value.increment(by: bit).error
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        //=--------------------------------------=
        // increment: many + bit
        //=--------------------------------------=
        if !bit {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return value.incrementSameSize(repeating: pattern).error
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        
        always: do {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return value.incrementSameSize(repeating: pattern, plus: bit).error
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        //=--------------------------------------=
        // increment: many + bit
        //=--------------------------------------=
        always: do {
            let element  = Element(repeating: Bit(pattern))
            let elements = Array(repeating: element, count: self.body.count)
            self.plus(elements, plus: bit, is: expectation)
        }
    }
    
    func minus(_ elements: [Element], plus bit: Bool, is expectation: Fallible<[Element]>) {
        //=--------------------------------------=
        var normal = elements[...]; while normal.last == 0 { normal.removeLast() }
        //=--------------------------------------=
        // decrement: none + bit
        //=--------------------------------------=
        if  normal.count == 0, bit {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return value.decrement().error
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        
        if  normal.count == 0 {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return value.decrement(by: bit).error
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        //=--------------------------------------=
        // decrement: some
        //=--------------------------------------=
        if  normal.count == 1, !bit {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return value.decrement(by: normal.first!).error
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        //=--------------------------------------=
        // decrement: some + bit
        //=--------------------------------------=
        if  normal.count == 1 {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return value.decrement(by: normal.first!, plus: bit).error
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        //=--------------------------------------=
        // decrement: many
        //=--------------------------------------=
        for many in [normal, elements[...]] where bit == false {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return (many).withUnsafeBufferPointer {
                    let many = DataInt.Body($0)!
                    return value.decrement(by: many).error
                }
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        //=--------------------------------------=
        // decrement: many + bit
        //=--------------------------------------=
        for many in [normal, elements[...]] {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return (many).withUnsafeBufferPointer {
                    let many = DataInt.Body($0)!
                    return value.decrement(by: many, plus: bit).error
                }
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        
        for var many in [normal, elements[...]] where bit == false {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return (many).withUnsafeMutableBufferPointer {
                    let many = MutableDataInt.Body($0)!
                    many.toggle(carrying: bit).discard()
                    return value.decrement(toggling: DataInt.Body(many), plus: bit).error
                }
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
    }
    
    func minusSameSize(repeating pattern: Bool, plus bit: Bool, is expectation: Fallible<[Element]>) {
        //=--------------------------------------=
        if  pattern == bit {
            test.same(expectation, Fallible(self.body, error: bit))
        }
        //=--------------------------------------=
        // increment: none + bit
        //=--------------------------------------=
        if !pattern {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return value.decrement(by: bit).error
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        //=--------------------------------------=
        // increment: reps + bit
        //=--------------------------------------=
        if !bit {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return value.decrementSameSize(repeating: pattern).error
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        
        always: do {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return value.decrementSameSize(repeating: pattern, plus: bit).error
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        //=--------------------------------------=
        // increment: many + bit
        //=--------------------------------------=
        always: do {
            let element  = Element(repeating: Bit(pattern))
            let elements = Array(repeating: element, count: self.body.count)
            self.minus(elements, plus: bit, is: expectation)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    func plus(_ elements: [Element], times multiplier: Element, plus increment: Element, is expectation: Fallible<[Element]>) {
        //=--------------------------------------=
        var normal = elements[...]; while normal.last == 0 { normal.removeLast() }
        //=--------------------------------------=
        // increment: some
        //=--------------------------------------=
        if  normal.count == 0 || multiplier == 0 {
            self.plus([increment], plus: false, is: expectation)
        }
        //=--------------------------------------=
        // increment: some
        //=--------------------------------------=
        if  multiplier == 1, increment <= 1 {
            self.plus(elements, plus: increment != 1, is: expectation)
        }
        //=--------------------------------------=
        // increment: many × some
        //=--------------------------------------=
        for many in [normal, elements[...]] where increment == 0 {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return (many).withUnsafeBufferPointer {
                    let many = DataInt.Body($0)!
                    return value.increment(by: many, times: multiplier).error
                }
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        //=--------------------------------------=
        // increment: many × some + some
        //=--------------------------------------=
        for many in [normal, elements[...]] {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return (many).withUnsafeBufferPointer {
                    let many = DataInt.Body($0)!
                    return value.increment(by: many, times: multiplier, plus: increment).error
                }
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
    }
    
    func minus(_ elements: [Element], times multiplier: Element, plus decrement: Element, is expectation: Fallible<[Element]>) {
        //=--------------------------------------=
        var normal = elements[...]; while normal.last == 0 { normal.removeLast() }
        //=--------------------------------------=
        // decrement: some
        //=--------------------------------------=
        if  normal.count == 0 || multiplier == 0 {
            self.minus([decrement], plus: false, is: expectation)
        }
        //=--------------------------------------=
        // decrement: some
        //=--------------------------------------=
        if  multiplier == 1, decrement <= 1 {
            self.minus(elements, plus: decrement != 1, is: expectation)
        }
        //=--------------------------------------=
        // decrement: many × some
        //=--------------------------------------=
        for many in [normal, elements[...]] where decrement == 0 {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return (many).withUnsafeBufferPointer {
                    let many = DataInt.Body($0)!
                    return value.decrement(by: many, times: multiplier).error
                }
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
        //=--------------------------------------=
        // decrement: many × some + some
        //=--------------------------------------=
        for many in [normal, elements[...]] {
            var value = self.body
            let error = value.withUnsafeMutableBufferPointer {
                let value = MutableDataInt.Body($0)!
                return (many).withUnsafeBufferPointer {
                    let many = DataInt.Body($0)!
                    return value.decrement(by: many, times: multiplier, plus: decrement).error
                }
            }
            
            test.same(Fallible(value, error: error), expectation)
        }
    }
}
