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
    // MARK: Tests x Many + Bit
    //=------------------------------------------------------------------------=
    
    func testAddition41B() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
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
    
    func testSubtraction41B() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            
            C([~0, ~0, ~0, ~0] as [T]).minus([T.min], plus: false, is: F([~0, ~0, ~0, ~0] as [T]))
            C([ 0, ~0, ~0, ~0] as [T]).minus([T.min], plus: false, is: F([ 0, ~0, ~0, ~0] as [T]))
            C([ 0,  0, ~0, ~0] as [T]).minus([T.min], plus: false, is: F([ 0,  0, ~0, ~0] as [T]))
            C([ 0,  0,  0, ~0] as [T]).minus([T.min], plus: false, is: F([ 0,  0,  0, ~0] as [T]))
            C([ 0,  0,  0,  0] as [T]).minus([T.min], plus: false, is: F([ 0,  0,  0,  0] as [T]))
            
            C([~0, ~0, ~0, ~0] as [T]).minus([T.min], plus: true,  is: F([~1, ~0, ~0, ~0] as [T]))
            C([ 0, ~0, ~0, ~0] as [T]).minus([T.min], plus: true,  is: F([~0, ~1, ~0, ~0] as [T]))
            C([ 0,  0, ~0, ~0] as [T]).minus([T.min], plus: true,  is: F([~0, ~0, ~1, ~0] as [T]))
            C([ 0,  0,  0, ~0] as [T]).minus([T.min], plus: true,  is: F([~0, ~0, ~0, ~1] as [T]))
            C([ 0,  0,  0,  0] as [T]).minus([T.min], plus: true,  is: F([~0, ~0, ~0, ~0] as [T], error: true))
            
            C([~0, ~0, ~0, ~0] as [T]).minus([T.max], plus: false, is: F([ 0, ~0, ~0, ~0] as [T]))
            C([ 0, ~0, ~0, ~0] as [T]).minus([T.max], plus: false, is: F([ 1, ~1, ~0, ~0] as [T]))
            C([ 0,  0, ~0, ~0] as [T]).minus([T.max], plus: false, is: F([ 1, ~0, ~1, ~0] as [T]))
            C([ 0,  0,  0, ~0] as [T]).minus([T.max], plus: false, is: F([ 1, ~0, ~0, ~1] as [T]))
            C([ 0,  0,  0,  0] as [T]).minus([T.max], plus: false, is: F([ 1, ~0, ~0, ~0] as [T], error: true))
            
            C([~0, ~0, ~0, ~0] as [T]).minus([T.max], plus: true,  is: F([~0, ~1, ~0, ~0] as [T]))
            C([ 0, ~0, ~0, ~0] as [T]).minus([T.max], plus: true,  is: F([ 0, ~1, ~0, ~0] as [T]))
            C([ 0,  0, ~0, ~0] as [T]).minus([T.max], plus: true,  is: F([ 0, ~0, ~1, ~0] as [T]))
            C([ 0,  0,  0, ~0] as [T]).minus([T.max], plus: true,  is: F([ 0, ~0, ~0, ~1] as [T]))
            C([ 0,  0,  0,  0] as [T]).minus([T.max], plus: true,  is: F([ 0, ~0, ~0, ~0] as [T], error: true))
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testAddition44B() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
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
    
    func testSubtraction44B() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            
            C([ 0,  0,  0,  0] as [T]).minus([ 0,  0,  0,  0] as [T], plus: false, is: F([ 0,  0,  0,  0] as [T]))
            C([ 0,  0,  0,  0] as [T]).minus([ 0,  0,  0,  0] as [T], plus: true,  is: F([~0, ~0, ~0, ~0] as [T], error: true))
            C([ 0,  0,  0,  0] as [T]).minus([ 1,  0,  0,  0] as [T], plus: false, is: F([~0, ~0, ~0, ~0] as [T], error: true))
            C([ 0,  0,  0,  0] as [T]).minus([ 1,  0,  0,  0] as [T], plus: true,  is: F([~1, ~0, ~0, ~0] as [T], error: true))
            
            C([~0, ~0, ~0, ~0] as [T]).minus([ 0,  0,  0,  0] as [T], plus: false, is: F([~0, ~0, ~0, ~0] as [T]))
            C([~0, ~0, ~0, ~0] as [T]).minus([ 0,  0,  0,  0] as [T], plus: true,  is: F([~1, ~0, ~0, ~0] as [T]))
            C([~0, ~0, ~0, ~0] as [T]).minus([ 1,  0,  0,  0] as [T], plus: false, is: F([~1, ~0, ~0, ~0] as [T]))
            C([~0, ~0, ~0, ~0] as [T]).minus([ 1,  0,  0,  0] as [T], plus: true,  is: F([~2, ~0, ~0, ~0] as [T]))
            
            C([ 0,  1,  2,  3] as [T]).minus([ 4,  0,  0,  0] as [T], plus: false, is: F([~3,  0,  2,  3] as [T]))
            C([ 0,  1,  2,  3] as [T]).minus([ 0,  4,  0,  0] as [T], plus: false, is: F([ 0, ~2,  1,  3] as [T]))
            C([ 0,  1,  2,  3] as [T]).minus([ 0,  0,  4,  0] as [T], plus: false, is: F([ 0,  1, ~1,  2] as [T]))
            C([ 0,  1,  2,  3] as [T]).minus([ 0,  0,  0,  4] as [T], plus: false, is: F([ 0,  1,  2, ~0] as [T], error: true))
            
            C([ 0,  1,  2,  3] as [T]).minus([ 4,  0,  0,  0] as [T], plus: true,  is: F([~4,  0,  2,  3] as [T]))
            C([ 0,  1,  2,  3] as [T]).minus([ 0,  4,  0,  0] as [T], plus: true,  is: F([~0, ~3,  1,  3] as [T]))
            C([ 0,  1,  2,  3] as [T]).minus([ 0,  0,  4,  0] as [T], plus: true,  is: F([~0,  0, ~1,  2] as [T]))
            C([ 0,  1,  2,  3] as [T]).minus([ 0,  0,  0,  4] as [T], plus: true,  is: F([~0,  0,  2, ~0] as [T], error: true))
            
            C([ 0,  1,  2,  3] as [T]).minus([~4, ~0, ~0, ~0] as [T], plus: false, is: F([ 5,  1,  2,  3] as [T], error: true))
            C([ 0,  1,  2,  3] as [T]).minus([~0, ~4, ~0, ~0] as [T], plus: false, is: F([ 1,  5,  2,  3] as [T], error: true))
            C([ 0,  1,  2,  3] as [T]).minus([~0, ~0, ~4, ~0] as [T], plus: false, is: F([ 1,  1,  6,  3] as [T], error: true))
            C([ 0,  1,  2,  3] as [T]).minus([~0, ~0, ~0, ~4] as [T], plus: false, is: F([ 1,  1,  2,  7] as [T], error: true))
            
            C([ 0,  1,  2,  3] as [T]).minus([~4, ~0, ~0, ~0] as [T], plus: true,  is: F([ 4,  1,  2,  3] as [T], error: true))
            C([ 0,  1,  2,  3] as [T]).minus([~0, ~4, ~0, ~0] as [T], plus: true,  is: F([ 0,  5,  2,  3] as [T], error: true))
            C([ 0,  1,  2,  3] as [T]).minus([~0, ~0, ~4, ~0] as [T], plus: true,  is: F([ 0,  1,  6,  3] as [T], error: true))
            C([ 0,  1,  2,  3] as [T]).minus([~0, ~0, ~0, ~4] as [T], plus: true,  is: F([ 0,  1,  2,  7] as [T], error: true))
            
            C([~0, ~1, ~2, ~3] as [T]).minus([ 4,  0,  0,  0] as [T], plus: false, is: F([~4, ~1, ~2, ~3] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).minus([ 0,  4,  0,  0] as [T], plus: false, is: F([~0, ~5, ~2, ~3] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).minus([ 0,  0,  4,  0] as [T], plus: false, is: F([~0, ~1, ~6, ~3] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).minus([ 0,  0,  0,  4] as [T], plus: false, is: F([~0, ~1, ~2, ~7] as [T]))
            
            C([~0, ~1, ~2, ~3] as [T]).minus([ 4,  0,  0,  0] as [T], plus: true,  is: F([~5, ~1, ~2, ~3] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).minus([ 0,  4,  0,  0] as [T], plus: true,  is: F([~1, ~5, ~2, ~3] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).minus([ 0,  0,  4,  0] as [T], plus: true,  is: F([~1, ~1, ~6, ~3] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).minus([ 0,  0,  0,  4] as [T], plus: true,  is: F([~1, ~1, ~2, ~7] as [T]))
            
            C([~0, ~1, ~2, ~3] as [T]).minus([~4, ~0, ~0, ~0] as [T], plus: false, is: F([ 4, ~0, ~2, ~3] as [T], error: true))
            C([~0, ~1, ~2, ~3] as [T]).minus([~0, ~4, ~0, ~0] as [T], plus: false, is: F([ 0,  3, ~1, ~3] as [T], error: true))
            C([~0, ~1, ~2, ~3] as [T]).minus([~0, ~0, ~4, ~0] as [T], plus: false, is: F([ 0, ~0,  1, ~2] as [T], error: true))
            C([~0, ~1, ~2, ~3] as [T]).minus([~0, ~0, ~0, ~4] as [T], plus: false, is: F([ 0, ~0, ~2,  0] as [T]))
            
            C([~0, ~1, ~2, ~3] as [T]).minus([~4, ~0, ~0, ~0] as [T], plus: true,  is: F([ 3, ~0, ~2, ~3] as [T], error: true))
            C([~0, ~1, ~2, ~3] as [T]).minus([~0, ~4, ~0, ~0] as [T], plus: true,  is: F([~0,  2, ~1, ~3] as [T], error: true))
            C([~0, ~1, ~2, ~3] as [T]).minus([~0, ~0, ~4, ~0] as [T], plus: true,  is: F([~0, ~1,  1, ~2] as [T], error: true))
            C([~0, ~1, ~2, ~3] as [T]).minus([~0, ~0, ~0, ~4] as [T], plus: true,  is: F([~0, ~1, ~2,  0] as [T]))
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Many + Bit
    //=------------------------------------------------------------------------=

    func testAdditionLargeBySameSizePattern() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            
            C([              ] as [T]).plusSameSize(repeating: false, plus: false, is: F([              ] as [T]))
            C([              ] as [T]).plusSameSize(repeating: true,  plus: false, is: F([              ] as [T]))
            C([              ] as [T]).plusSameSize(repeating: false, plus: true,  is: F([              ] as [T], error: true))
            C([              ] as [T]).plusSameSize(repeating: true,  plus: true,  is: F([              ] as [T], error: true))
            
            C([ 0,  0,  0,  0] as [T]).plusSameSize(repeating: false, plus: false, is: F([ 0,  0,  0,  0] as [T]))
            C([ 0,  0,  0,  0] as [T]).plusSameSize(repeating: true,  plus: false, is: F([~0, ~0, ~0, ~0] as [T]))
            C([ 0,  0,  0,  0] as [T]).plusSameSize(repeating: false, plus: true,  is: F([ 1,  0,  0,  0] as [T]))
            C([ 0,  0,  0,  0] as [T]).plusSameSize(repeating: true,  plus: true,  is: F([ 0,  0,  0,  0] as [T], error: true))
            
            C([~0, ~0, ~0, ~0] as [T]).plusSameSize(repeating: false, plus: false, is: F([~0, ~0, ~0, ~0] as [T]))
            C([~0, ~0, ~0, ~0] as [T]).plusSameSize(repeating: true,  plus: false, is: F([~1, ~0, ~0, ~0] as [T], error: true))
            C([~0, ~0, ~0, ~0] as [T]).plusSameSize(repeating: false, plus: true,  is: F([ 0,  0,  0,  0] as [T], error: true))
            C([~0, ~0, ~0, ~0] as [T]).plusSameSize(repeating: true,  plus: true,  is: F([~0, ~0, ~0, ~0] as [T], error: true))
            
            C([ 0,  1,  2,  3] as [T]).plusSameSize(repeating: false, plus: false, is: F([ 0,  1,  2,  3] as [T]))
            C([ 0,  1,  2,  3] as [T]).plusSameSize(repeating: true,  plus: false, is: F([~0,  0,  2,  3] as [T], error: true))
            C([ 0,  1,  2,  3] as [T]).plusSameSize(repeating: false, plus: true,  is: F([ 1,  1,  2,  3] as [T]))
            C([ 0,  1,  2,  3] as [T]).plusSameSize(repeating: true,  plus: true,  is: F([ 0,  1,  2,  3] as [T], error: true))
            
            C([~0, ~1, ~2, ~3] as [T]).plusSameSize(repeating: false, plus: false, is: F([~0, ~1, ~2, ~3] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).plusSameSize(repeating: true,  plus: false, is: F([~1, ~1, ~2, ~3] as [T], error: true))
            C([~0, ~1, ~2, ~3] as [T]).plusSameSize(repeating: false, plus: true,  is: F([ 0, ~0, ~2, ~3] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).plusSameSize(repeating: true,  plus: true,  is: F([~0, ~1, ~2, ~3] as [T], error: true))
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testSubtractionLargeBySameSizePattern() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            
            C([              ] as [T]).minusSameSize(repeating: false, plus: false, is: F([              ] as [T]))
            C([              ] as [T]).minusSameSize(repeating: true,  plus: false, is: F([              ] as [T]))
            C([              ] as [T]).minusSameSize(repeating: false, plus: true,  is: F([              ] as [T], error: true))
            C([              ] as [T]).minusSameSize(repeating: true,  plus: true,  is: F([              ] as [T], error: true))
            
            C([ 0,  0,  0,  0] as [T]).minusSameSize(repeating: false, plus: false, is: F([ 0,  0,  0,  0] as [T]))
            C([ 0,  0,  0,  0] as [T]).minusSameSize(repeating: true,  plus: false, is: F([ 1,  0,  0,  0] as [T], error: true))
            C([ 0,  0,  0,  0] as [T]).minusSameSize(repeating: false, plus: true,  is: F([~0, ~0, ~0, ~0] as [T], error: true))
            C([ 0,  0,  0,  0] as [T]).minusSameSize(repeating: true,  plus: true,  is: F([ 0,  0,  0,  0] as [T], error: true))
            
            C([~0, ~0, ~0, ~0] as [T]).minusSameSize(repeating: false, plus: false, is: F([~0, ~0, ~0, ~0] as [T]))
            C([~0, ~0, ~0, ~0] as [T]).minusSameSize(repeating: true,  plus: false, is: F([ 0,  0,  0,  0] as [T]))
            C([~0, ~0, ~0, ~0] as [T]).minusSameSize(repeating: false, plus: true,  is: F([~1, ~0, ~0, ~0] as [T]))
            C([~0, ~0, ~0, ~0] as [T]).minusSameSize(repeating: true,  plus: true,  is: F([~0, ~0, ~0, ~0] as [T], error: true))
            
            C([ 0,  1,  2,  3] as [T]).minusSameSize(repeating: false, plus: false, is: F([ 0,  1,  2,  3] as [T]))
            C([ 0,  1,  2,  3] as [T]).minusSameSize(repeating: true,  plus: false, is: F([ 1,  1,  2,  3] as [T], error: true))
            C([ 0,  1,  2,  3] as [T]).minusSameSize(repeating: false, plus: true,  is: F([~0,  0,  2,  3] as [T]))
            C([ 0,  1,  2,  3] as [T]).minusSameSize(repeating: true,  plus: true,  is: F([ 0,  1,  2,  3] as [T], error: true))
            
            C([~0, ~1, ~2, ~3] as [T]).minusSameSize(repeating: false, plus: false, is: F([~0, ~1, ~2, ~3] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).minusSameSize(repeating: true,  plus: false, is: F([ 0, ~0, ~2, ~3] as [T], error: true))
            C([~0, ~1, ~2, ~3] as [T]).minusSameSize(repeating: false, plus: true,  is: F([~1, ~1, ~2, ~3] as [T]))
            C([~0, ~1, ~2, ~3] as [T]).minusSameSize(repeating: true,  plus: true,  is: F([~0, ~1, ~2, ~3] as [T], error: true))
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
            typealias C = DataIntTests.Body<T>
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
    
    func testSubtractionLargeBySmallProduct() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            
            C([ 0    ] as [T]).minus([ ] as [T], times: T( ), plus: T(0), is: F([ 0    ] as [T]))
            C([ 0    ] as [T]).minus([ ] as [T], times: T( ), plus: T(1), is: F([~0    ] as [T], error: true))
            C([~0    ] as [T]).minus([ ] as [T], times: T( ), plus: T(0), is: F([~0    ] as [T]))
            C([~0    ] as [T]).minus([ ] as [T], times: T( ), plus: T(1), is: F([~1    ] as [T]))
            
            C([ 0,  0] as [T]).minus([0] as [T], times: T( ), plus: T(0), is: F([ 0,  0] as [T]))
            C([ 0,  0] as [T]).minus([0] as [T], times: T( ), plus: T(1), is: F([~0, ~0] as [T], error: true))
            C([~0, ~0] as [T]).minus([0] as [T], times: T( ), plus: T(0), is: F([~0, ~0] as [T]))
            C([~0, ~0] as [T]).minus([0] as [T], times: T( ), plus: T(1), is: F([~1, ~0] as [T]))
            
            C([ 0,  0] as [T]).minus([2] as [T], times: T(0), plus: T(0), is: F([ 0,  0] as [T]))
            C([ 0,  0] as [T]).minus([2] as [T], times: T(0), plus: T(1), is: F([~0, ~0] as [T], error: true))
            C([~0, ~0] as [T]).minus([2] as [T], times: T(0), plus: T(0), is: F([~0, ~0] as [T]))
            C([~0, ~0] as [T]).minus([2] as [T], times: T(0), plus: T(1), is: F([~1, ~0] as [T]))
            
            C([ 0,  0] as [T]).minus([0] as [T], times: T(3), plus: T(0), is: F([ 0,  0] as [T]))
            C([ 0,  0] as [T]).minus([0] as [T], times: T(3), plus: T(1), is: F([~0, ~0] as [T], error: true))
            C([~0, ~0] as [T]).minus([0] as [T], times: T(3), plus: T(0), is: F([~0, ~0] as [T]))
            C([~0, ~0] as [T]).minus([0] as [T], times: T(3), plus: T(1), is: F([~1, ~0] as [T]))
            
            C([ 0,  0] as [T]).minus([2] as [T], times: T(3), plus: T(0), is: F([~5, ~0] as [T], error: true))
            C([ 0,  0] as [T]).minus([2] as [T], times: T(3), plus: T(1), is: F([~6, ~0] as [T], error: true))
            C([~0, ~0] as [T]).minus([2] as [T], times: T(3), plus: T(0), is: F([~6, ~0] as [T]))
            C([~0, ~0] as [T]).minus([2] as [T], times: T(3), plus: T(1), is: F([~7, ~0] as [T]))
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testAdditionLargeByLargeProduct() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
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
    
    func testSubtractionLargeByLargeProduct() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            
            let a: [T] = [ 0,  0,  0,  0,  0,  0,  0,  0]
            let b: [T] = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0]
            
            let x: [T] = [ 1,  2,  3,  4]
            let y: [T] = [~1, ~2, ~3, ~4]
            
            C(a).minus(x, times: 2, plus: T(  ), is: F([~1, ~4, ~6, ~8, ~0, ~0, ~0, ~0] as [T], error: true))
            C(a).minus(x, times: 2, plus: T.max, is: F([~0, ~5, ~6, ~8, ~0, ~0, ~0, ~0] as [T], error: true))
            C(a).minus(y, times: 2, plus: T(  ), is: F([ 4,  4,  6,  8, ~1, ~0, ~0, ~0] as [T], error: true))
            C(a).minus(y, times: 2, plus: T.max, is: F([ 5,  3,  6,  8, ~1, ~0, ~0, ~0] as [T], error: true))
            C(b).minus(x, times: 2, plus: T(  ), is: F([~2, ~4, ~6, ~8, ~0, ~0, ~0, ~0] as [T]))
            C(b).minus(x, times: 2, plus: T.max, is: F([~1, ~5, ~6, ~8, ~0, ~0, ~0, ~0] as [T]))
            C(b).minus(y, times: 2, plus: T(  ), is: F([ 3,  4,  6,  8, ~1, ~0, ~0, ~0] as [T]))
            C(b).minus(y, times: 2, plus: T.max, is: F([ 4,  3,  6,  8, ~1, ~0, ~0, ~0] as [T]))
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Addition x Assertions
//*============================================================================*

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
