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
// MARK: * Data Int x Addition
//*============================================================================*

extension DataIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAdditionLargeByLarge() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Canvas<T>
            typealias F = Fallible<[T]>
            
            C([ 0,  0,  0,  0] as [T]).plus([ 0,  0,  0,  0] as [T], plus: false, is: F([ 0,  0,  0,  0] as [T]))
            C([ 0,  0,  0,  0] as [T]).plus([ 0,  0,  0,  0] as [T], plus: true,  is: F([ 1,  0,  0,  0] as [T]))
            C([ 0,  0,  0,  0] as [T]).plus([ 1,  0,  0,  0] as [T], plus: false, is: F([ 1,  0,  0,  0] as [T]))
            C([ 0,  0,  0,  0] as [T]).plus([ 1,  0,  0,  0] as [T], plus: true,  is: F([ 2,  0,  0,  0] as [T]))
            
            C([~0, ~0, ~0, ~0] as [T]).plus([ 0,  0,  0,  0] as [T], plus: false, is: F([~0, ~0, ~0, ~0] as [T]))
            C([~0, ~0, ~0, ~0] as [T]).plus([ 0,  0,  0,  0] as [T], plus: true,  is: F([ 0,  0,  0,  0] as [T], error: true))
            C([~0, ~0, ~0, ~0] as [T]).plus([ 1,  0,  0,  0] as [T], plus: false, is: F([ 0,  0,  0,  0] as [T], error: true))
            C([~0, ~0, ~0, ~0] as [T]).plus([ 1,  0,  0,  0] as [T], plus: true,  is: F([ 1,  0,  0,  0] as [T], error: true))
            
            C([ 0,  1,  2,  3] as [T]).plus([ 4,  0,  0,  0] as [T], plus: false, is: F([ 4,  1,  2,  3] as [T]))
            C([ 0,  1,  2,  3] as [T]).plus([ 0,  4,  0,  0] as [T], plus: false, is: F([ 0,  5,  2,  3] as [T]))
            C([ 0,  1,  2,  3] as [T]).plus([ 0,  0,  4,  0] as [T], plus: false, is: F([ 0,  1,  6,  3] as [T]))
            C([ 0,  1,  2,  3] as [T]).plus([ 0,  0,  0,  4] as [T], plus: false, is: F([ 0,  1,  2,  7] as [T]))
            
            C([ 0,  1,  2,  3] as [T]).plus([ 4,  0,  0,  0] as [T], plus: true,  is: F([ 5,  1,  2,  3] as [T]))
            C([ 0,  1,  2,  3] as [T]).plus([ 0,  4,  0,  0] as [T], plus: true,  is: F([ 1,  5,  2,  3] as [T]))
            C([ 0,  1,  2,  3] as [T]).plus([ 0,  0,  4,  0] as [T], plus: true,  is: F([ 1,  1,  6,  3] as [T]))
            C([ 0,  1,  2,  3] as [T]).plus([ 0,  0,  0,  4] as [T], plus: true,  is: F([ 1,  1,  2,  7] as [T]))
            
            C([ 0,  1,  2,  3] as [T]).plus([~4, ~0, ~0, ~0] as [T], plus: false, is: F([~4,  0,  2,  3] as [T], error: true))
            C([ 0,  1,  2,  3] as [T]).plus([~0, ~4, ~0, ~0] as [T], plus: false, is: F([~0, ~3,  1,  3] as [T], error: true))
            C([ 0,  1,  2,  3] as [T]).plus([~0, ~0, ~4, ~0] as [T], plus: false, is: F([~0,  0, ~1,  2] as [T], error: true))
            C([ 0,  1,  2,  3] as [T]).plus([~0, ~0, ~0, ~4] as [T], plus: false, is: F([~0,  0,  2, ~0] as [T]))

            C([ 0,  1,  2,  3] as [T]).plus([~4, ~0, ~0, ~0] as [T], plus: true,  is: F([~3,  0,  2,  3] as [T], error: true))
            C([ 0,  1,  2,  3] as [T]).plus([~0, ~4, ~0, ~0] as [T], plus: true,  is: F([ 0, ~2,  1,  3] as [T], error: true))
            C([ 0,  1,  2,  3] as [T]).plus([~0, ~0, ~4, ~0] as [T], plus: true,  is: F([ 0,  1, ~1,  2] as [T], error: true))
            C([ 0,  1,  2,  3] as [T]).plus([~0, ~0, ~0, ~4] as [T], plus: true,  is: F([ 0,  1,  2, ~0] as [T]))
            
            C([~0, ~1, ~2, ~3] as [T]).plus([ 4,  0,  0,  0] as [T], plus: false, is: F([ 3, ~0, ~2, ~3] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).plus([ 0,  4,  0,  0] as [T], plus: false, is: F([~0,  2, ~1, ~3] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).plus([ 0,  0,  4,  0] as [T], plus: false, is: F([~0, ~1,  1, ~2] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).plus([ 0,  0,  0,  4] as [T], plus: false, is: F([~0, ~1, ~2,  0] as [T], error: true))

            C([~0, ~1, ~2, ~3] as [T]).plus([ 4,  0,  0,  0] as [T], plus: true,  is: F([ 4, ~0, ~2, ~3] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).plus([ 0,  4,  0,  0] as [T], plus: true,  is: F([ 0,  3, ~1, ~3] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).plus([ 0,  0,  4,  0] as [T], plus: true,  is: F([ 0, ~0,  1, ~2] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).plus([ 0,  0,  0,  4] as [T], plus: true,  is: F([ 0, ~0, ~2,  0] as [T], error: true))
            
            C([~0, ~1, ~2, ~3] as [T]).plus([~4, ~0, ~0, ~0] as [T], plus: false, is: F([~5, ~1, ~2, ~3] as [T], error: true))
            C([~0, ~1, ~2, ~3] as [T]).plus([~0, ~4, ~0, ~0] as [T], plus: false, is: F([~1, ~5, ~2, ~3] as [T], error: true))
            C([~0, ~1, ~2, ~3] as [T]).plus([~0, ~0, ~4, ~0] as [T], plus: false, is: F([~1, ~1, ~6, ~3] as [T], error: true))
            C([~0, ~1, ~2, ~3] as [T]).plus([~0, ~0, ~0, ~4] as [T], plus: false, is: F([~1, ~1, ~2, ~7] as [T], error: true))

            C([~0, ~1, ~2, ~3] as [T]).plus([~4, ~0, ~0, ~0] as [T], plus: true,  is: F([~4, ~1, ~2, ~3] as [T], error: true))
            C([~0, ~1, ~2, ~3] as [T]).plus([~0, ~4, ~0, ~0] as [T], plus: true,  is: F([~0, ~5, ~2, ~3] as [T], error: true))
            C([~0, ~1, ~2, ~3] as [T]).plus([~0, ~0, ~4, ~0] as [T], plus: true,  is: F([~0, ~1, ~6, ~3] as [T], error: true))
            C([~0, ~1, ~2, ~3] as [T]).plus([~0, ~0, ~0, ~4] as [T], plus: true,  is: F([~0, ~1, ~2, ~7] as [T], error: true))
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testAdditionLargeBySmall() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Canvas<T>
            typealias F = Fallible<[T]>
            
            C([ 0,  0,  0,  0] as [T]).plus([T.min], plus: false, is: F([ 0,  0,  0,  0] as [T]))
            C([~0,  0,  0,  0] as [T]).plus([T.min], plus: false, is: F([~0,  0,  0,  0] as [T]))
            C([~0, ~0,  0,  0] as [T]).plus([T.min], plus: false, is: F([~0, ~0,  0,  0] as [T]))
            C([~0, ~0, ~0,  0] as [T]).plus([T.min], plus: false, is: F([~0, ~0, ~0,  0] as [T]))
            C([~0, ~0, ~0, ~0] as [T]).plus([T.min], plus: false, is: F([~0, ~0, ~0, ~0] as [T]))

            C([ 0,  0,  0,  0] as [T]).plus([T.min], plus: true,  is: F([ 1,  0,  0,  0] as [T]))
            C([~0,  0,  0,  0] as [T]).plus([T.min], plus: true,  is: F([ 0,  1,  0,  0] as [T]))
            C([~0, ~0,  0,  0] as [T]).plus([T.min], plus: true,  is: F([ 0,  0,  1,  0] as [T]))
            C([~0, ~0, ~0,  0] as [T]).plus([T.min], plus: true,  is: F([ 0,  0,  0,  1] as [T]))
            C([~0, ~0, ~0, ~0] as [T]).plus([T.min], plus: true,  is: F([ 0,  0,  0,  0] as [T], error: true))

            C([ 0,  0,  0,  0] as [T]).plus([T.max], plus: false, is: F([~0,  0,  0,  0] as [T]))
            C([~0,  0,  0,  0] as [T]).plus([T.max], plus: false, is: F([~1,  1,  0,  0] as [T]))
            C([~0, ~0,  0,  0] as [T]).plus([T.max], plus: false, is: F([~1,  0,  1,  0] as [T]))
            C([~0, ~0, ~0,  0] as [T]).plus([T.max], plus: false, is: F([~1,  0,  0,  1] as [T]))
            C([~0, ~0, ~0, ~0] as [T]).plus([T.max], plus: false, is: F([~1,  0,  0,  0] as [T], error: true))

            C([ 0,  0,  0,  0] as [T]).plus([T.max], plus: true,  is: F([ 0,  1,  0,  0] as [T]))
            C([~0,  0,  0,  0] as [T]).plus([T.max], plus: true,  is: F([~0,  1,  0,  0] as [T]))
            C([~0, ~0,  0,  0] as [T]).plus([T.max], plus: true,  is: F([~0,  0,  1,  0] as [T]))
            C([~0, ~0, ~0,  0] as [T]).plus([T.max], plus: true,  is: F([~0,  0,  0,  1] as [T]))
            C([~0, ~0, ~0, ~0] as [T]).plus([T.max], plus: true,  is: F([~0,  0,  0,  0] as [T], error: true))
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Product
    //=------------------------------------------------------------------------=
    
    func testAdditionLargeBySmallProduct() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Canvas<T>
            typealias F = Fallible<[T]>
            
            C([ 0    ] as [T]).plus([ ] as [T], times: T( ), plus: T(0), is: F([ 0    ] as [T]))
            C([ 0    ] as [T]).plus([ ] as [T], times: T( ), plus: T(1), is: F([ 1    ] as [T]))
            C([~0    ] as [T]).plus([ ] as [T], times: T( ), plus: T(0), is: F([~0    ] as [T]))
            C([~0    ] as [T]).plus([ ] as [T], times: T( ), plus: T(1), is: F([ 0    ] as [T], error: true))

            C([ 0,  0] as [T]).plus([0] as [T], times: T( ), plus: T(0), is: F([ 0,  0] as [T]))
            C([ 0,  0] as [T]).plus([0] as [T], times: T( ), plus: T(1), is: F([ 1,  0] as [T]))
            C([~0, ~0] as [T]).plus([0] as [T], times: T( ), plus: T(0), is: F([~0, ~0] as [T]))
            C([~0, ~0] as [T]).plus([0] as [T], times: T( ), plus: T(1), is: F([ 0,  0] as [T], error: true))

            C([ 0,  0] as [T]).plus([2] as [T], times: T(0), plus: T(0), is: F([ 0,  0] as [T]))
            C([ 0,  0] as [T]).plus([2] as [T], times: T(0), plus: T(1), is: F([ 1,  0] as [T]))
            C([~0, ~0] as [T]).plus([2] as [T], times: T(0), plus: T(0), is: F([~0, ~0] as [T]))
            C([~0, ~0] as [T]).plus([2] as [T], times: T(0), plus: T(1), is: F([ 0,  0] as [T], error: true))

            C([ 0,  0] as [T]).plus([0] as [T], times: T(3), plus: T(0), is: F([ 0,  0] as [T]))
            C([ 0,  0] as [T]).plus([0] as [T], times: T(3), plus: T(1), is: F([ 1,  0] as [T]))
            C([~0, ~0] as [T]).plus([0] as [T], times: T(3), plus: T(0), is: F([~0, ~0] as [T]))
            C([~0, ~0] as [T]).plus([0] as [T], times: T(3), plus: T(1), is: F([ 0,  0] as [T], error: true))

            C([ 0,  0] as [T]).plus([2] as [T], times: T(3), plus: T(0), is: F([ 6,  0] as [T]))
            C([ 0,  0] as [T]).plus([2] as [T], times: T(3), plus: T(1), is: F([ 7,  0] as [T]))
            C([~0, ~0] as [T]).plus([2] as [T], times: T(3), plus: T(0), is: F([ 5,  0] as [T], error: true))
            C([~0, ~0] as [T]).plus([2] as [T], times: T(3), plus: T(1), is: F([ 6,  0] as [T], error: true))
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }

    func testAdditionLargeByLargeProduct() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Canvas<T>
            typealias F = Fallible<[T]>
            
            let a: [T] = [ 0,  0,  0,  0,  0,  0,  0,  0]
            let b: [T] = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0]
            
            let x: [T] = [ 1,  2,  3,  4]
            let y: [T] = [~1, ~2, ~3, ~4]
            
            C(a).plus(x, times: 2, plus: T(  ), is: F([ 2,  4,  6,  8,  0,  0,  0,  0] as [T]))
            C(a).plus(x, times: 2, plus: T.max, is: F([ 1,  5,  6,  8,  0,  0,  0,  0] as [T]))
            C(a).plus(y, times: 2, plus: T(  ), is: F([~3, ~4, ~6, ~8,  1,  0,  0,  0] as [T]))
            C(a).plus(y, times: 2, plus: T.max, is: F([~4, ~3, ~6, ~8,  1,  0,  0,  0] as [T]))            
            C(b).plus(x, times: 2, plus: T(  ), is: F([ 1,  4,  6,  8,  0,  0,  0,  0] as [T], error: true))
            C(b).plus(x, times: 2, plus: T.max, is: F([ 0,  5,  6,  8,  0,  0,  0,  0] as [T], error: true))
            C(b).plus(y, times: 2, plus: T(  ), is: F([~4, ~4, ~6, ~8,  1,  0,  0,  0] as [T], error: true))
            C(b).plus(y, times: 2, plus: T.max, is: F([~5, ~3, ~6, ~8,  1,  0,  0,  0] as [T], error: true))
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Addition x Assertions
//*============================================================================*

extension DataIntTests.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    func plus(_ elements: [Element], plus bit: Bool, is expectation: Fallible<[Element]>) {
        //=--------------------------------------=
        var normal = elements[...]; while normal.last == 0 { normal.removeLast() }
        //=--------------------------------------=
        // increment: none + bit
        //=--------------------------------------=
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
    }

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
}
