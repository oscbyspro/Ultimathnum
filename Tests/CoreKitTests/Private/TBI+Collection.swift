//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import MainIntKit
import TestKit

//*============================================================================*
// MARK: * Tuple Binary Integer x Collection
//*============================================================================*

final class TupleBinaryIntegerTestsOnCollection: XCTestCase {
    
    typealias TS = Namespace.TupleBinaryInteger<I64>
    typealias TU = Namespace.TupleBinaryInteger<U64>
    
    typealias S1 = TS.X1
    typealias S2 = TS.X2
    
    typealias U1 = TU.X1
    typealias U2 = TU.X2

    //=------------------------------------------------------------------------=
    // MARK: Tests x Prefix
    //=------------------------------------------------------------------------=
    
    func testPrefix1() {
        XCTAssert(TS.prefix1([~0    ] as [U64]) == ~0 as TS.X1)
        XCTAssert(TS.prefix1([~0, ~1] as [U64]) == ~0 as TS.X1)
        XCTAssert(TU.prefix1([~0    ] as [U64]) == ~0 as TU.X1)
        XCTAssert(TU.prefix1([~0, ~1] as [U64]) == ~0 as TU.X1)
    }
    
    func testPrefix2() {
        XCTAssert(TS.prefix2([~0, ~1    ] as [U64]) == TS.X2(low: ~0, high: ~1))
        XCTAssert(TS.prefix2([~0, ~1, ~2] as [U64]) == TS.X2(low: ~0, high: ~1))
        XCTAssert(TU.prefix2([~0, ~1    ] as [U64]) == TU.X2(low: ~0, high: ~1))
        XCTAssert(TU.prefix2([~0, ~1, ~2] as [U64]) == TU.X2(low: ~0, high: ~1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Suffix
    //=------------------------------------------------------------------------=

    func testSuffix1() {
        XCTAssert(TS.suffix1([~0    ] as [U64]) == ~0 as S1)
        XCTAssert(TS.suffix1([~0, ~1] as [U64]) == ~1 as S1)
        XCTAssert(TU.suffix1([~0    ] as [U64]) == ~0 as U1)
        XCTAssert(TU.suffix1([~0, ~1] as [U64]) == ~1 as U1)
    }
    
    func testSuffix2() {
        XCTAssert(TS.suffix2([~0, ~1    ] as [U64]) == TS.X2(low: ~0, high: ~1))
        XCTAssert(TS.suffix2([~0, ~1, ~2] as [U64]) == TS.X2(low: ~1, high: ~2))
        XCTAssert(TU.suffix2([~0, ~1    ] as [U64]) == TU.X2(low: ~0, high: ~1))
        XCTAssert(TU.suffix2([~0, ~1, ~2] as [U64]) == TU.X2(low: ~1, high: ~2))
    }
}
