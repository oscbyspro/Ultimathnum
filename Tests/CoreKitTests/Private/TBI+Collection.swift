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
// MARK: * Tuple Binary Integer x Collection
//*============================================================================*

extension TupleBinaryIntegerTests {
    
    private typealias TS = Namespace.TupleBinaryInteger<I64>
    private typealias TU = Namespace.TupleBinaryInteger<U64>
    
    private typealias S1 = TS.X1
    private typealias S2 = TS.X2
    
    private typealias U1 = TU.X1
    private typealias U2 = TU.X2

    //=------------------------------------------------------------------------=
    // MARK: Tests x Prefix
    //=------------------------------------------------------------------------=
    
    func testPrefix1() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias X2 = Doublet<Base>
            typealias X3 = Triplet<Base>
            
            XCTAssert(TBI.prefix1([~0    ] as [Base.Magnitude]) == ~0 as Base)
            XCTAssert(TBI.prefix1([~0, ~1] as [Base.Magnitude]) == ~0 as Base)
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
    
    func testPrefix2() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias X2 = Doublet<Base>
            typealias X3 = Triplet<Base>
            
            XCTAssert(TBI.prefix2([~0, ~1    ] as [Base.Magnitude]) == X2(low: ~0, high: ~1))
            XCTAssert(TBI.prefix2([~0, ~1, ~2] as [Base.Magnitude]) == X2(low: ~0, high: ~1))
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Suffix
    //=------------------------------------------------------------------------=

    func testSuffix1() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias X2 = Doublet<Base>
            typealias X3 = Triplet<Base>
            
            XCTAssert(TBI.suffix1([~0    ] as [Base.Magnitude]) == ~0 as Base)
            XCTAssert(TBI.suffix1([~0, ~1] as [Base.Magnitude]) == ~1 as Base)
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
    
    func testSuffix2() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias X2 = Doublet<Base>
            typealias X3 = Triplet<Base>
            
            XCTAssert(TBI.suffix2([~0, ~1    ] as [Base.Magnitude]) == X2(low: ~0, high: ~1))
            XCTAssert(TBI.suffix2([~0, ~1, ~2] as [Base.Magnitude]) == X2(low: ~1, high: ~2))
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
}
