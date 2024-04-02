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
// MARK: * Systems Integer x Collection
//*============================================================================*

extension SystemsIntegerTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Prefix
    //=------------------------------------------------------------------------=
    
    func testPrefix1() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X2 = Doublet<T>
            typealias X3 = Triplet<T>
            
            Test().same(T.prefix1([~0    ] as [T.Magnitude]), ~0 as T)
            Test().same(T.prefix1([~0, ~1] as [T.Magnitude]), ~0 as T)
        }
        
        for base in Self.types {
            whereIs(base)
        }
    }
    
    func testPrefix2() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X2 = Doublet<T>
            typealias X3 = Triplet<T>
            
            Test().same(T.prefix2([~0, ~1    ] as [T.Magnitude]), X2(low: ~0, high: ~1))
            Test().same(T.prefix2([~0, ~1, ~2] as [T.Magnitude]), X2(low: ~0, high: ~1))
        }
        
        for base in Self.types {
            whereIs(base)
        }
    }
    
    func testPrefix3() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X2 = Doublet<T>
            typealias X3 = Triplet<T>
            
            Test().same(T.prefix3([~0, ~1, ~2    ] as [T.Magnitude]), X3(low: ~0, mid: ~1, high: ~2))
            Test().same(T.prefix3([~0, ~1, ~2, ~3] as [T.Magnitude]), X3(low: ~0, mid: ~1, high: ~2))
        }
        
        for base in Self.types {
            whereIs(base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Suffix
    //=------------------------------------------------------------------------=

    func testSuffix1() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X2 = Doublet<T>
            typealias X3 = Triplet<T>
            
            Test().same(T.suffix1([~0    ] as [T.Magnitude]), ~0 as T)
            Test().same(T.suffix1([~0, ~1] as [T.Magnitude]), ~1 as T)
        }
        
        for base in Self.types {
            whereIs(base)
        }
    }
    
    func testSuffix2() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X2 = Doublet<T>
            typealias X3 = Triplet<T>
            
            Test().same(T.suffix2([~0, ~1    ] as [T.Magnitude]), X2(low: ~0, high: ~1))
            Test().same(T.suffix2([~0, ~1, ~2] as [T.Magnitude]), X2(low: ~1, high: ~2))
        }
        
        for base in Self.types {
            whereIs(base)
        }
    }
    
    func testSuffix3() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X2 = Doublet<T>
            typealias X3 = Triplet<T>
            
            Test().same(T.suffix3([~0, ~1, ~2    ] as [T.Magnitude]), X3(low: ~0, mid: ~1, high: ~2))
            Test().same(T.suffix3([~0, ~1, ~2, ~3] as [T.Magnitude]), X3(low: ~1, mid: ~2, high: ~3))
        }
        
        for base in Self.types {
            whereIs(base)
        }
    }
}
