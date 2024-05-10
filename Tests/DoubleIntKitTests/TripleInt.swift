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
    
    static let basesWhereIsSigned: [any (SystemsInteger & SignedInteger).Type] = [
        I8x3.High.self,
        IXx3.High.self,
    ]
    
    static let basesWhereIsUnsigned: [any (SystemsInteger & UnsignedInteger).Type] = [
        U8x3.High.self,
        UXx3.High.self,
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInvariants() {
        func whereTheBaseIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = TripleInt<B>
            typealias M = TripleInt<B>.Magnitude
            
            Test().same(T.mode.isSigned, B.isSigned)
            Test().same(T.size, M(low: 3 * B.size, mid: 0, high: 0))
        }
        
        for base in coreSystemsIntegers {
            whereTheBaseIs(base)
        }
    }
    
    func testInit() {
        func whereTheBaseIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = TripleInt<B>
            
            Test().same(T(low: 1, mid: 2, high: 3).low,  1 as B.Magnitude)
            Test().same(T(low: 1, mid: 2, high: 3).mid,  2 as B.Magnitude)
            Test().same(T(low: 1, mid: 2, high: 3).high, 3 as B)
            
            Test().same(T(high: 1, mid: 2, low: 3).low,  3 as B.Magnitude)
            Test().same(T(high: 1, mid: 2, low: 3).mid,  2 as B.Magnitude)
            Test().same(T(high: 1, mid: 2, low: 3).high, 1 as B)
            
            Test().same(T(low:  1, high: Doublet(low:  2, high: 3)).low,   1 as B.Magnitude)
            Test().same(T(low:  1, high: Doublet(low:  2, high: 3)).mid,   2 as B.Magnitude)
            Test().same(T(low:  1, high: Doublet(low:  2, high: 3)).high,  3 as B)
            
            Test().same(T(high: 1, low: Doublet(high:  2,  low:  3)).low,  3 as B.Magnitude)
            Test().same(T(high: 1, low: Doublet(high:  2,  low:  3)).mid,  2 as B.Magnitude)
            Test().same(T(high: 1, low: Doublet(high:  2,  low:  3)).high, 1 as B)
            
            Test().same(T(low:  Doublet(low:  1, high: 2), high: 3 ).low,  1 as B.Magnitude)
            Test().same(T(low:  Doublet(low:  1, high: 2), high: 3 ).mid,  2 as B.Magnitude)
            Test().same(T(low:  Doublet(low:  1, high: 2), high: 3 ).high, 3 as B)
            
            Test().same(T(high: Doublet(high: 1, low:  2), low:  3 ).low,  3 as B.Magnitude)
            Test().same(T(high: Doublet(high: 1, low:  2), low:  3 ).mid,  2 as B.Magnitude)
            Test().same(T(high: Doublet(high: 1, low:  2), low:  3 ).high, 1 as B)
        }
        
        for base in coreSystemsIntegers {
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
        
        for base in coreSystemsIntegers {
            whereTheBaseIs(base)
        }
    }
    
    func testMemoryLayout() {
        func whereTheBaseIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = TripleInt<B>
            
            Test().same(MemoryLayout<T>.self, MemoryLayout<(B, B, B)>.self)
            Test().same(MemoryLayout<T>.size, 3 * MemoryLayout<B>.size)
            Test().same(MemoryLayout<T>.size, 3 * MemoryLayout<B>.stride)
            Test().same(MemoryLayout<T>.size, 3 * MemoryLayout<B>.alignment)
        }
        
        for base in coreSystemsIntegers {
            whereTheBaseIs(base)
        }
    }
    
    func testComponents() {
        func whereTheBaseIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = TripleInt<B>
            
            let rhs  = T(low: 1, mid: 2, high: 3)
            var lhs  = T(low: 0, mid: 0, high: 0)
            
            lhs.low  = rhs.low
            lhs.mid  = rhs.mid
            lhs.high = rhs.high
            
            Test().same(lhs, rhs)
        }
        
        for base in coreSystemsIntegers {
            whereTheBaseIs(base)
        }
    }
    
    //*========================================================================*
    // MARK: * Case
    //*========================================================================*
    
    struct Case<Base: SystemsInteger> {
        
        typealias Item = TripleInt<Base>
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=

        var test: Test
        var item: Item
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        init(_ item: Item, test: Test) {
            self.test = test
            self.item = item
        }
        
        init(_ item: Item, file: StaticString = #file, line: UInt = #line) {
            self.init(item, test: Test(file: file, line: line))
        }
    }
}
