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
    
    func testMultiplicationByElement() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias Canvas = DataIntTests.Canvas<T>
            
            Canvas([ 0,  0,  0,  0] as [T]).times( 0, plus:  0, low:[ 0,  0,  0,  0] as [T], high:  0)
            Canvas([ 0,  0,  0,  0] as [T]).times( 0, plus: ~0, low:[~0,  0,  0,  0] as [T], high:  0)
            Canvas([ 0,  0,  0,  0] as [T]).times(~0, plus:  0, low:[ 0,  0,  0,  0] as [T], high:  0)
            Canvas([ 0,  0,  0,  0] as [T]).times(~0, plus: ~0, low:[~0,  0,  0,  0] as [T], high:  0)
            Canvas([~0, ~0, ~0, ~0] as [T]).times( 0, plus:  0, low:[ 0,  0,  0,  0] as [T], high:  0)
            Canvas([~0, ~0, ~0, ~0] as [T]).times( 0, plus: ~0, low:[~0,  0,  0,  0] as [T], high:  0)
            Canvas([~0, ~0, ~0, ~0] as [T]).times(~0, plus:  0, low:[ 1, ~0, ~0, ~0] as [T], high: ~1)
            Canvas([~0, ~0, ~0, ~0] as [T]).times(~0, plus: ~0, low:[ 0,  0,  0,  0] as [T], high: ~0)
            
            Canvas([ 0,  0,  0,  0] as [T]).times( 1, plus:  0, low:[ 0,  0,  0,  0] as [T], high:  0)
            Canvas([ 0,  0,  0,  0] as [T]).times( 1, plus: ~0, low:[~0,  0,  0,  0] as [T], high:  0)
            Canvas([ 0,  0,  0,  0] as [T]).times(~1, plus:  0, low:[ 0,  0,  0,  0] as [T], high:  0)
            Canvas([ 0,  0,  0,  0] as [T]).times(~1, plus: ~0, low:[~0,  0,  0,  0] as [T], high:  0)
            Canvas([~0, ~0, ~0, ~0] as [T]).times( 1, plus:  0, low:[~0, ~0, ~0, ~0] as [T], high:  0)
            Canvas([~0, ~0, ~0, ~0] as [T]).times( 1, plus: ~0, low:[~1,  0,  0,  0] as [T], high:  1)
            Canvas([~0, ~0, ~0, ~0] as [T]).times(~1, plus:  0, low:[ 2, ~0, ~0, ~0] as [T], high: ~2)
            Canvas([~0, ~0, ~0, ~0] as [T]).times(~1, plus: ~0, low:[ 1,  0,  0,  0] as [T], high: ~1)
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
    
    func times(_ multiplier: Element, plus increment: Element, low: [Element], high: Element) {
        //=--------------------------------------=
        // multiplication: 0001 + some
        //=--------------------------------------=
        if  multiplier == 1 {
            // TODO: addition
        }
        //=--------------------------------------=
        // multiplication: some + some
        //=--------------------------------------=
        brr: do {
            var result: (low: [Element], high: Element)
            
            result.low  = self.body
            result.high = result.low.withUnsafeMutableBufferPointer {
                DataInt.Canvas($0)!.multiply(by: multiplier, add: increment)
            }
            
            test.same(result.low,  low)
            test.same(result.high, high)
        }
    }
}
