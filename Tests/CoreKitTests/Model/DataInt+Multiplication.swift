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
    
    func testMultiplicationLargeBySmall() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias Canvas = DataIntTests.Canvas<T>
            
            Canvas([ 0,  0,  0,  0] as [T]).times([ 0] as [T], plus:  0, is:[ 0,  0,  0,  0,  0] as [T])
            Canvas([ 0,  0,  0,  0] as [T]).times([ 0] as [T], plus: ~0, is:[~0,  0,  0,  0,  0] as [T])
            Canvas([ 0,  0,  0,  0] as [T]).times([~0] as [T], plus:  0, is:[ 0,  0,  0,  0,  0] as [T])
            Canvas([ 0,  0,  0,  0] as [T]).times([~0] as [T], plus: ~0, is:[~0,  0,  0,  0,  0] as [T])
            Canvas([~0, ~0, ~0, ~0] as [T]).times([ 0] as [T], plus:  0, is:[ 0,  0,  0,  0,  0] as [T])
            Canvas([~0, ~0, ~0, ~0] as [T]).times([ 0] as [T], plus: ~0, is:[~0,  0,  0,  0,  0] as [T])
            Canvas([~0, ~0, ~0, ~0] as [T]).times([~0] as [T], plus:  0, is:[ 1, ~0, ~0, ~0, ~1] as [T])
            Canvas([~0, ~0, ~0, ~0] as [T]).times([~0] as [T], plus: ~0, is:[ 0,  0,  0,  0, ~0] as [T])
            
            Canvas([ 0,  0,  0,  0] as [T]).times([ 1] as [T], plus:  0, is:[ 0,  0,  0,  0,  0] as [T])
            Canvas([ 0,  0,  0,  0] as [T]).times([ 1] as [T], plus: ~0, is:[~0,  0,  0,  0,  0] as [T])
            Canvas([ 0,  0,  0,  0] as [T]).times([~1] as [T], plus:  0, is:[ 0,  0,  0,  0,  0] as [T])
            Canvas([ 0,  0,  0,  0] as [T]).times([~1] as [T], plus: ~0, is:[~0,  0,  0,  0,  0] as [T])
            Canvas([~0, ~0, ~0, ~0] as [T]).times([ 1] as [T], plus:  0, is:[~0, ~0, ~0, ~0,  0] as [T])
            Canvas([~0, ~0, ~0, ~0] as [T]).times([ 1] as [T], plus: ~0, is:[~1,  0,  0,  0,  1] as [T])
            Canvas([~0, ~0, ~0, ~0] as [T]).times([~1] as [T], plus:  0, is:[ 2, ~0, ~0, ~0, ~2] as [T])
            Canvas([~0, ~0, ~0, ~0] as [T]).times([~1] as [T], plus: ~0, is:[ 1,  0,  0,  0, ~1] as [T])
                        
            Canvas([ 1,  2,  3,  4] as [T]).times([ 0] as [T], plus:  0, is:[ 0,  0,  0,  0,  0] as [T])
            Canvas([ 1,  2,  3,  4] as [T]).times([ 1] as [T], plus:  0, is:[ 1,  2,  3,  4,  0] as [T])
            Canvas([ 1,  2,  3,  4] as [T]).times([ 2] as [T], plus:  0, is:[ 2,  4,  6,  8,  0] as [T])
            Canvas([ 1,  2,  3,  4] as [T]).times([~0] as [T], plus:  0, is:[~0, ~1, ~1, ~1,  3] as [T])
            Canvas([ 1,  2,  3,  4] as [T]).times([~1] as [T], plus:  0, is:[~1, ~3, ~4, ~5,  3] as [T])
            Canvas([ 1,  2,  3,  4] as [T]).times([~2] as [T], plus:  0, is:[~2, ~5, ~7, ~9,  3] as [T])
            
            Canvas([~0, ~0, ~0, ~0] as [T]).times([ 0] as [T], plus:  0, is:[ 0,  0,  0,  0,  0] as [T])
            Canvas([~0, ~0, ~0, ~0] as [T]).times([ 0] as [T], plus: ~0, is:[~0,  0,  0,  0,  0] as [T])
            Canvas([~0, ~0, ~0, ~0] as [T]).times([~0] as [T], plus:  0, is:[ 1, ~0, ~0, ~0, ~1] as [T])
            Canvas([~0, ~0, ~0, ~0] as [T]).times([~0] as [T], plus: ~0, is:[ 0,  0,  0,  0, ~0] as [T])
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplicationLargeByLarge() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias Canvas = DataIntTests.Canvas<T>
            
            Canvas([ 1,  2,  3,  4] as [T]).times([ 2,  0,  0,  0] as [T], plus:  5, is:[ 7,  4,  6,  8,  0,  0,  0,  0] as [T])
            Canvas([ 1,  2,  3,  4] as [T]).times([ 0,  2,  0,  0] as [T], plus:  5, is:[ 5,  2,  4,  6,  8,  0,  0,  0] as [T])
            Canvas([ 1,  2,  3,  4] as [T]).times([ 0,  0,  2,  0] as [T], plus:  5, is:[ 5,  0,  2,  4,  6,  8,  0,  0] as [T])
            Canvas([ 1,  2,  3,  4] as [T]).times([ 0,  0,  0,  2] as [T], plus:  5, is:[ 5,  0,  0,  2,  4,  6,  8,  0] as [T])
            
            Canvas([~1, ~2, ~3, ~4] as [T]).times([ 2,  0,  0,  0] as [T], plus: ~5, is:[~9, ~3, ~6, ~8,  1,  0,  0,  0] as [T])
            Canvas([~1, ~2, ~3, ~4] as [T]).times([ 0,  2,  0,  0] as [T], plus: ~5, is:[~5, ~3, ~4, ~6, ~8,  1,  0,  0] as [T])
            Canvas([~1, ~2, ~3, ~4] as [T]).times([ 0,  0,  2,  0] as [T], plus: ~5, is:[~5,  0, ~3, ~4, ~6, ~8,  1,  0] as [T])
            Canvas([~1, ~2, ~3, ~4] as [T]).times([ 0,  0,  0,  2] as [T], plus: ~5, is:[~5,  0,  0, ~3, ~4, ~6, ~8,  1] as [T])
            
            Canvas([ 0,  0,  0,  0] as [T]).times([ 0,  0,  0,  0] as [T], plus:  0, is:[ 0,  0,  0,  0,  0,  0,  0,  0] as [T])
            Canvas([ 1,  2,  3,  4] as [T]).times([ 1,  2,  3,  4] as [T], plus:  5, is:[ 6,  4, 10, 20, 25, 24, 16,  0] as [T])
            Canvas([~1, ~2, ~3, ~4] as [T]).times([~1, ~2, ~3, ~4] as [T], plus: ~5, is:[~1,  8, 16, 28, 21, 20, 10, ~7] as [T])
            Canvas([~0, ~0, ~0, ~0] as [T]).times([~0, ~0, ~0, ~0] as [T], plus: ~0, is:[ 0,  1,  0,  0, ~1, ~0, ~0, ~0] as [T])
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Multiplication x Assertions
//*============================================================================*

extension DataIntTests.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func times(_ multiplier: [Element], plus increment: Element, is expectation: [Element]) {
        //=--------------------------------------=
        // multiplication: many × 0001 + some
        //=--------------------------------------=
        if  multiplier.count == 1, multiplier.first == 1 {
            var value = Array(expectation)
            let error = value.removeLast() != 0
            self.plus([increment], plus: false, is: Fallible(value, error: error))
        }
        //=--------------------------------------=
        // multiplication: many × some + some
        //=--------------------------------------=
        if  multiplier.count == 1, let first = multiplier.first {
            var value = self.body
            let last  = value.withUnsafeMutableBufferPointer {
                DataInt.Canvas($0)!.multiply(by: first, add: increment)
            }
            
            value.append(last)
            test.same(value, expectation)
        }
        //=--------------------------------------=
        // multiplication: many × many
        //=--------------------------------------=
        normal: if increment == 0 {
            let count = self.body.count + multiplier.count
            var value = [Element](repeating: 144, count: count)

            value.withUnsafeMutableBufferPointer {
                let value = DataInt.Canvas($0)!
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
        //=--------------------------------------=
        // multiplication: many × many + some
        //=--------------------------------------=
        normal: do {
            let count = self.body.count + multiplier.count
            var value = [Element](repeating: 144, count: count)

            value.withUnsafeMutableBufferPointer {
                let value = DataInt.Canvas($0)!
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
        //=--------------------------------------=
        // multiplication: many × many (s)
        //=--------------------------------------=
        square: if self.body == multiplier, increment == 0 {
            let count = self.body.count + multiplier.count
            var value = [Element](repeating: 144, count: count)
            
            value.withUnsafeMutableBufferPointer {
                let value = DataInt.Canvas($0)!
                self.body.withUnsafeBufferPointer {
                    let body = DataInt.Body($0)!
                    value.initializeByLongAlgorithm(toSquareProductOf: body)
                }
            }
            
            test.same(value, expectation)
        }
        //=--------------------------------------=
        // multiplication: many × many + some (s)
        //=--------------------------------------=
        square: if self.body == multiplier {
            let count = self.body.count + multiplier.count
            var value = [Element](repeating: 144, count: count)
            
            value.withUnsafeMutableBufferPointer {
                let value = DataInt.Canvas($0)!
                self.body.withUnsafeBufferPointer {
                    let body = DataInt.Body($0)!
                    value.initializeByLongAlgorithm(toSquareProductOf: body, plus: increment)
                }
            }
            
            test.same(value, expectation)
        }
    }
}
