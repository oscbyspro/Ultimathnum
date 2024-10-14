//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import TestKit

//*============================================================================*
// MARK: * Triple Int
//*============================================================================*

final class TripleIntTests: XCTestCase {
    
    typealias X3<Base> = TripleInt<Base> where Base: SystemsInteger
    
    typealias I8x3 = TripleInt<I8>
    typealias U8x3 = TripleInt<U8>
    
    typealias IXx3 = TripleInt<IX>
    typealias UXx3 = TripleInt<UX>
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let bases: [any SystemsInteger.Type] = {
        basesWhereIsSigned +
        basesWhereIsUnsigned
    }()
    
    static let basesWhereIsSigned: [any (SystemsInteger & SignedInteger).Type] = {
        typesAsCoreIntegerAsSigned
    }()
    
    static let basesWhereIsUnsigned: [any (SystemsInteger & UnsignedInteger).Type] = {
        typesAsCoreIntegerAsUnsigned
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInvariants() {
        func whereTheBaseIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = TripleInt<B>
            typealias M = TripleInt<B>.Magnitude
            
            Test().same(T.mode, B.mode)
            Test().same(T.size, Count(3 * IX(size: B.self)))
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
    
    func testComponents() {
        func whereTheBaseIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = TripleInt<B>
            
            Test().same(T(                       ).low,  0 as B.Magnitude)
            Test().same(T(                       ).mid,  0 as B.Magnitude)
            Test().same(T(                       ).high, 0 as B)
            Test().same(T(                       ).low,  0 as B.Magnitude)
            Test().same(T(                       ).mid,  0 as B.Magnitude)
            Test().same(T(                       ).high, 0 as B)
            Test().same(T(low: 0                 ).low,  0 as B.Magnitude)
            Test().same(T(low: 0                 ).mid,  0 as B.Magnitude)
            Test().same(T(low: 0                 ).high, 0 as B)
            Test().same(T(low: 1                 ).low,  1 as B.Magnitude)
            Test().same(T(low: 1                 ).mid,  0 as B.Magnitude)
            Test().same(T(low: 1                 ).high, 0 as B)
            Test().same(T(low: 0, mid: 0         ).low,  0 as B.Magnitude)
            Test().same(T(low: 0, mid: 0         ).mid,  0 as B.Magnitude)
            Test().same(T(low: 0, mid: 0         ).high, 0 as B)
            Test().same(T(low: 1, mid: 2         ).low,  1 as B.Magnitude)
            Test().same(T(low: 1, mid: 2         ).mid,  2 as B.Magnitude)
            Test().same(T(low: 1, mid: 2         ).high, 0 as B)
            Test().same(T(low: 0, mid: 0, high: 0).low,  0 as B.Magnitude)
            Test().same(T(low: 0, mid: 0, high: 0).mid,  0 as B.Magnitude)
            Test().same(T(low: 0, mid: 0, high: 0).high, 0 as B)
            Test().same(T(low: 1, mid: 2, high: 3).low,  1 as B.Magnitude)
            Test().same(T(low: 1, mid: 2, high: 3).mid,  2 as B.Magnitude)
            Test().same(T(low: 1, mid: 2, high: 3).high, 3 as B)
            
            Test().same(T(low: 0, high: Doublet(low: 0, high: 0)).low,  0 as B.Magnitude)
            Test().same(T(low: 0, high: Doublet(low: 0, high: 0)).mid,  0 as B.Magnitude)
            Test().same(T(low: 0, high: Doublet(low: 0, high: 0)).high, 0 as B)
            Test().same(T(low: 1, high: Doublet(low: 2, high: 3)).low,  1 as B.Magnitude)
            Test().same(T(low: 1, high: Doublet(low: 2, high: 3)).mid,  2 as B.Magnitude)
            Test().same(T(low: 1, high: Doublet(low: 2, high: 3)).high, 3 as B)
            
            Test().same(T(low: Doublet(low: 0, high: 0)         ).low,  0 as B.Magnitude)
            Test().same(T(low: Doublet(low: 0, high: 0)         ).mid,  0 as B.Magnitude)
            Test().same(T(low: Doublet(low: 0, high: 0)         ).high, 0 as B)
            Test().same(T(low: Doublet(low: 1, high: 2)         ).low,  1 as B.Magnitude)
            Test().same(T(low: Doublet(low: 1, high: 2)         ).mid,  2 as B.Magnitude)
            Test().same(T(low: Doublet(low: 1, high: 2)         ).high, 0 as B)
            Test().same(T(low: Doublet(low: 0, high: 0), high: 0).low,  0 as B.Magnitude)
            Test().same(T(low: Doublet(low: 0, high: 0), high: 0).mid,  0 as B.Magnitude)
            Test().same(T(low: Doublet(low: 0, high: 0), high: 0).high, 0 as B)
            Test().same(T(low: Doublet(low: 1, high: 2), high: 3).low,  1 as B.Magnitude)
            Test().same(T(low: Doublet(low: 1, high: 2), high: 3).mid,  2 as B.Magnitude)
            Test().same(T(low: Doublet(low: 1, high: 2), high: 3).high, 3 as B)
            
            setters: do {
                let rhs  = T(low: 1, mid: 2, high: 3)
                var lhs  = T(low: 0, mid: 0, high: 0)
                
                lhs.low  = rhs.low
                lhs.mid  = rhs.mid
                lhs.high = rhs.high
                
                Test().same(lhs, rhs)
            }
            
            components: do {
                var low:  B.Magnitude
                var mid:  B.Magnitude
                var high: B
                
                (low, mid, high)  = T(low: 0, mid: 0, high: 0).components()
                Test().same(low,  0 as B.Magnitude)
                Test().same(mid,  0 as B.Magnitude)
                Test().same(high, 0 as B)
                
                (low, mid, high)  = T(low: 1, mid: 2, high: 3).components()
                Test().same(low,  1 as B.Magnitude)
                Test().same(mid,  2 as B.Magnitude)
                Test().same(high, 3 as B)
            }
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
    
    func testBitCast() {
        func whereTheBaseIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = TripleInt<B>
            typealias S = T.Signitude
            typealias M = T.Magnitude
            
            Test().same(M(raw: T(low:  1, mid:  2, high:  3)), M(low:  1, mid:  2, high:  3))
            Test().same(S(raw: T(low:  1, mid:  2, high:  3)), S(low:  1, mid:  2, high:  3))
            Test().same(M(raw: T(low: ~1, mid: ~2, high: ~3)), M(low: ~1, mid: ~2, high: ~3))
            Test().same(S(raw: T(low: ~1, mid: ~2, high: ~3)), S(low: ~1, mid: ~2, high: ~3))
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
    
    func testMemoryLayout() {
        func whereTheBaseIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = TripleInt<B>
            
            Test().same(MemoryLayout<T>.self, MemoryLayout<(B, B, B)>.self)
            Test().same(MemoryLayout<T>.size,      3 * MemoryLayout<B>.size)
            Test().same(MemoryLayout<T>.stride,    3 * MemoryLayout<B>.stride)
            Test().same(MemoryLayout<T>.alignment, 1 * MemoryLayout<B>.alignment)
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
}
