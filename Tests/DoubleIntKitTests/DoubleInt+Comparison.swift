//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import TestKit

//*============================================================================*
// MARK: * Double Int x Comparison
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    //  TODO: use Test.comparison when init(load:) has been implemented...
    func testComparisonAsIXx2() {
        typealias T = DoubleInt<IX>
        
        XCTAssertEqual(T(low:  1, high:  0).compared(to: T(low:  1, high:  1)), -1 as Signum)
        XCTAssertEqual(T(low:  2, high:  0).compared(to: T(low:  1, high:  1)), -1 as Signum)
        XCTAssertEqual(T(low:  0, high:  1).compared(to: T(low:  1, high:  1)), -1 as Signum)
        XCTAssertEqual(T(low:  1, high:  1).compared(to: T(low:  1, high:  1)),  0 as Signum)
        XCTAssertEqual(T(low:  2, high:  1).compared(to: T(low:  1, high:  1)),  1 as Signum)
        XCTAssertEqual(T(low:  0, high:  2).compared(to: T(low:  1, high:  1)),  1 as Signum)
        XCTAssertEqual(T(low:  1, high:  2).compared(to: T(low:  1, high:  1)),  1 as Signum)
        XCTAssertEqual(T(low:  2, high:  2).compared(to: T(low:  1, high:  1)),  1 as Signum)
        
        XCTAssertEqual(T(low: ~0, high: ~0).compared(to: T(low:  1, high:  1)), -1 as Signum)
        XCTAssertEqual(T(low: ~1, high: ~0).compared(to: T(low:  1, high:  1)), -1 as Signum)
        XCTAssertEqual(T(low: ~2, high: ~0).compared(to: T(low:  1, high:  1)), -1 as Signum)
        XCTAssertEqual(T(low: ~0, high: ~1).compared(to: T(low:  1, high:  1)), -1 as Signum)
        XCTAssertEqual(T(low: ~1, high: ~1).compared(to: T(low:  1, high:  1)), -1 as Signum)
        XCTAssertEqual(T(low: ~2, high: ~1).compared(to: T(low:  1, high:  1)), -1 as Signum)
        XCTAssertEqual(T(low: ~0, high: ~2).compared(to: T(low:  1, high:  1)), -1 as Signum)
        XCTAssertEqual(T(low: ~1, high: ~2).compared(to: T(low:  1, high:  1)), -1 as Signum)
        XCTAssertEqual(T(low: ~2, high: ~2).compared(to: T(low:  1, high:  1)), -1 as Signum)
        
        XCTAssertEqual(T(low:  0, high:  0).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low:  1, high:  0).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low:  2, high:  0).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low:  0, high:  1).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low:  1, high:  1).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low:  2, high:  1).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low:  0, high:  2).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low:  1, high:  2).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low:  2, high:  2).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        
        XCTAssertEqual(T(low: ~0, high: ~0).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low: ~1, high: ~0).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low: ~2, high: ~0).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low: ~0, high: ~1).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low: ~1, high: ~1).compared(to: T(low: ~1, high: ~1)),  0 as Signum)
        XCTAssertEqual(T(low: ~2, high: ~1).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
        XCTAssertEqual(T(low: ~0, high: ~2).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
        XCTAssertEqual(T(low: ~1, high: ~2).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
        XCTAssertEqual(T(low: ~2, high: ~2).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
    }
    
    //  TODO: use Test.comparison when init(load:) has been implemented...
    func testComparisonAsUXx2() {
        typealias T = DoubleInt<UX>
        
        XCTAssertEqual(T(low:  0, high:  0).compared(to: T(low:  1, high:  1)), -1 as Signum)
        XCTAssertEqual(T(low:  1, high:  0).compared(to: T(low:  1, high:  1)), -1 as Signum)
        XCTAssertEqual(T(low:  2, high:  0).compared(to: T(low:  1, high:  1)), -1 as Signum)
        XCTAssertEqual(T(low:  0, high:  1).compared(to: T(low:  1, high:  1)), -1 as Signum)
        XCTAssertEqual(T(low:  1, high:  1).compared(to: T(low:  1, high:  1)),  0 as Signum)
        XCTAssertEqual(T(low:  2, high:  1).compared(to: T(low:  1, high:  1)),  1 as Signum)
        XCTAssertEqual(T(low:  0, high:  2).compared(to: T(low:  1, high:  1)),  1 as Signum)
        XCTAssertEqual(T(low:  1, high:  2).compared(to: T(low:  1, high:  1)),  1 as Signum)
        XCTAssertEqual(T(low:  2, high:  2).compared(to: T(low:  1, high:  1)),  1 as Signum)
        
        XCTAssertEqual(T(low: ~0, high: ~0).compared(to: T(low:  1, high:  1)),  1 as Signum)
        XCTAssertEqual(T(low: ~1, high: ~0).compared(to: T(low:  1, high:  1)),  1 as Signum)
        XCTAssertEqual(T(low: ~2, high: ~0).compared(to: T(low:  1, high:  1)),  1 as Signum)
        XCTAssertEqual(T(low: ~0, high: ~1).compared(to: T(low:  1, high:  1)),  1 as Signum)
        XCTAssertEqual(T(low: ~1, high: ~1).compared(to: T(low:  1, high:  1)),  1 as Signum)
        XCTAssertEqual(T(low: ~2, high: ~1).compared(to: T(low:  1, high:  1)),  1 as Signum)
        XCTAssertEqual(T(low: ~0, high: ~2).compared(to: T(low:  1, high:  1)),  1 as Signum)
        XCTAssertEqual(T(low: ~1, high: ~2).compared(to: T(low:  1, high:  1)),  1 as Signum)
        XCTAssertEqual(T(low: ~2, high: ~2).compared(to: T(low:  1, high:  1)),  1 as Signum)
        
        XCTAssertEqual(T(low:  0, high:  0).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
        XCTAssertEqual(T(low:  1, high:  0).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
        XCTAssertEqual(T(low:  2, high:  0).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
        XCTAssertEqual(T(low:  0, high:  1).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
        XCTAssertEqual(T(low:  1, high:  1).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
        XCTAssertEqual(T(low:  2, high:  1).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
        XCTAssertEqual(T(low:  0, high:  2).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
        XCTAssertEqual(T(low:  1, high:  2).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
        XCTAssertEqual(T(low:  2, high:  2).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
        
        XCTAssertEqual(T(low: ~0, high: ~0).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low: ~1, high: ~0).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low: ~2, high: ~0).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low: ~0, high: ~1).compared(to: T(low: ~1, high: ~1)),  1 as Signum)
        XCTAssertEqual(T(low: ~1, high: ~1).compared(to: T(low: ~1, high: ~1)),  0 as Signum)
        XCTAssertEqual(T(low: ~2, high: ~1).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
        XCTAssertEqual(T(low: ~0, high: ~2).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
        XCTAssertEqual(T(low: ~1, high: ~2).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
        XCTAssertEqual(T(low: ~2, high: ~2).compared(to: T(low: ~1, high: ~1)), -1 as Signum)
    }
}
