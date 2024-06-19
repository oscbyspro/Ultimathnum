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
// MARK: * Double Int
//*============================================================================*

final class DoubleIntTests: XCTestCase {
    
    typealias X2<Base> = DoubleInt<Base> where Base: SystemsInteger
    
    typealias I8x2 = DoubleInt<I8>
    typealias U8x2 = DoubleInt<U8>
    
    typealias I8x4 = DoubleInt<I8x2>
    typealias U8x4 = DoubleInt<U8x2>
    
    typealias IXx2 = DoubleInt<IX>
    typealias UXx2 = DoubleInt<UX>
    
    typealias IXx4 = DoubleInt<IXx2>
    typealias UXx4 = DoubleInt<UXx2>
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let types: [any SystemsInteger.Type] = {
        typesWhereIsSigned +
        typesWhereIsUnsigned
    }()
    
    static let typesWhereIsSigned: [any (SystemsInteger & SignedInteger).Type] = [
        I8x2.self,
        I8x4.self,
        IXx2.self,
        IXx4.self,
    ]
    
    static let typesWhereIsUnsigned: [any (SystemsInteger & UnsignedInteger).Type] = [
        U8x2.self,
        U8x4.self,
        UXx2.self,
        UXx4.self,
    ]
    
    static let bases: [any SystemsInteger.Type] = {
        basesWhereIsSigned +
        basesWhereIsUnsigned
    }()
    
    static let basesWhereIsSigned: [any (SystemsInteger & SignedInteger).Type] = [
        I8x2.High.self,
        I8x4.High.self,
        IXx2.High.self,
        IXx4.High.self,
    ]
    
    static let basesWhereIsUnsigned: [any (SystemsInteger & UnsignedInteger).Type] = [
        U8x2.High.self,
        U8x4.High.self,
        UXx2.High.self,
        UXx4.High.self,
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInvariants() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).mode(BinaryIntegerID())
            IntegerInvariants(T.self).size(SystemsIntegerID())
            IntegerInvariants(T.self).protocols()
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testComponents() {
        func whereTheBaseIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            
            Test().same(T(low: 1, high: 2).low,  1 as B.Magnitude)
            Test().same(T(low: 1, high: 2).high, 2 as B)
            
            setters: do {
                let rhs  = T(low: 1, high: 2)
                var lhs  = T(low: 0, high: 0)
                
                lhs.low  = rhs.low
                lhs.high = rhs.high
                
                Test().same(lhs, rhs)
            }
            
            components: do {
                let (low, high) = T(low: 1, high: 2).components()
                Test().same(low,  1 as B.Magnitude)
                Test().same(high, 2 as B)
            }
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
    
    func testBitCast() {
        func whereTheBaseIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias S = T.Signitude
            typealias M = T.Magnitude
            
            Test().same(M(raw: T(low:  1, high:  2)), M(low:  1, high:  2))
            Test().same(S(raw: T(low:  1, high:  2)), S(low:  1, high:  2))
            Test().same(M(raw: T(low: ~1, high: ~2)), M(low: ~1, high: ~2))
            Test().same(S(raw: T(low: ~1, high: ~2)), S(low: ~1, high: ~2))
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
    
    func testMemoryLayout() {
        func whereTheBaseIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            
            Test().same(MemoryLayout<T>.self, MemoryLayout<(B, B)>.self)
            Test().same(MemoryLayout<T>.size,      2 * MemoryLayout<B>.size)
            Test().same(MemoryLayout<T>.stride,    2 * MemoryLayout<B>.stride)
            Test().same(MemoryLayout<T>.alignment, 1 * MemoryLayout<B>.alignment)
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
        
    //*========================================================================*
    // MARK: * Case
    //*========================================================================*
    
    struct Case<Base: SystemsInteger> {
        
        typealias Item = DoubleInt<Base>
        
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
