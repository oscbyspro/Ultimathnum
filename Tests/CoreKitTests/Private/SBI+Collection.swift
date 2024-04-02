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
// MARK: * Strict Binary Integer x Collection
//*============================================================================*

final class StrictBinaryIntegerTestsOnCollection {
    
    private typealias S1 = I64
    private typealias S2 = Doublet<I64>
    
    private typealias U1 = U64
    private typealias U2 = Doublet<U64>

    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    static let bases: [any SystemsInteger.Type] = {
        basesWhereIsSigned +
        basesWhereIsUnsigned
    }()
    
    static let basesWhereIsSigned: [any (SystemsInteger & SignedInteger).Type] = [
        IX.self, I8.self, I16.self, I32.self, I64.self,
    ]
    
    static let basesWhereIsUnsigned: [any (SystemsInteger & UnsignedInteger).Type] = [
        UX.self, U8.self, U16.self, U32.self, U64.self,
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Prefix
    //=------------------------------------------------------------------------=
    
    func testPrefix1() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias X2 = Doublet<Base>
            typealias X3 = Triplet<Base>
            
            XCTAssert(SBI.prefix1([~0    ] as [Base.Magnitude]) == ~0 as Base)
            XCTAssert(SBI.prefix1([~0, ~1] as [Base.Magnitude]) == ~0 as Base)
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
    
    func testPrefix2() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias X2 = Doublet<Base>
            typealias X3 = Triplet<Base>
            
            XCTAssert(SBI.prefix2([~0, ~1    ] as [Base.Magnitude]) == X2(low: ~0, high: ~1))
            XCTAssert(SBI.prefix2([~0, ~1, ~2] as [Base.Magnitude]) == X2(low: ~0, high: ~1))
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
            
            XCTAssert(SBI.suffix1([~0    ] as [Base.Magnitude]) == ~0 as Base)
            XCTAssert(SBI.suffix1([~0, ~1] as [Base.Magnitude]) == ~1 as Base)
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
    
    func testSuffix2() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias X2 = Doublet<Base>
            typealias X3 = Triplet<Base>
            
            XCTAssert(SBI.suffix2([~0, ~1    ] as [Base.Magnitude]) == X2(low: ~0, high: ~1))
            XCTAssert(SBI.suffix2([~0, ~1, ~2] as [Base.Magnitude]) == X2(low: ~1, high: ~2))
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
}
