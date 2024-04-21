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
// MARK: * Double Int x Bit
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            
            Test().same(T(repeating: 0 as Bit),  0 as T)
            Test().same(T(repeating: 1 as Bit), ~0 as T)
        }
        
        for base in bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testBitCountSelection() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            //=----------------------------------=
            let full = M.size
            let half = M(low: Base.size)
            let none = M.zero
            //=----------------------------------=
            Test().count(T(low:  00, high: 00), 0 as Bit, .anywhere,   full)
            Test().count(T(low: ~00, high: 00), 0 as Bit, .anywhere,   half)
            Test().count(T(low:  00, high: 11), 0 as Bit, .anywhere,   full - 3 as M)
            Test().count(T(low: ~00, high: 11), 0 as Bit, .anywhere,   half - 3 as M)
            Test().count(T(low:  11, high: 00), 0 as Bit, .anywhere,   full - 3 as M)
            Test().count(T(low: ~11, high: 00), 0 as Bit, .anywhere,   half + 3 as M)
            Test().count(T(low:  11, high: 11), 0 as Bit, .anywhere,   full - 6 as M)
            Test().count(T(low: ~11, high: 11), 0 as Bit, .anywhere,   half)
            
            Test().count(T(low:  00, high: 00), 1 as Bit, .anywhere,   none)
            Test().count(T(low: ~00, high: 00), 1 as Bit, .anywhere,   half)
            Test().count(T(low:  00, high: 11), 1 as Bit, .anywhere,   none + 3 as M)
            Test().count(T(low: ~00, high: 11), 1 as Bit, .anywhere,   half + 3 as M)
            Test().count(T(low:  11, high: 00), 1 as Bit, .anywhere,   none + 3 as M)
            Test().count(T(low: ~11, high: 00), 1 as Bit, .anywhere,   half - 3 as M)
            Test().count(T(low:  11, high: 11), 1 as Bit, .anywhere,   none + 6 as M)
            Test().count(T(low: ~11, high: 11), 1 as Bit, .anywhere,   half)
            
            Test().count(T(low:  00, high: 00), 0 as Bit, .ascending,  full)
            Test().count(T(low: ~00, high: 00), 0 as Bit, .ascending,  none)
            Test().count(T(low:  00, high: 11), 0 as Bit, .ascending,  half)
            Test().count(T(low: ~00, high: 11), 0 as Bit, .ascending,  none)
            Test().count(T(low:  11, high: 00), 0 as Bit, .ascending,  none)
            Test().count(T(low: ~11, high: 00), 0 as Bit, .ascending,  none + 2 as M)
            Test().count(T(low:  11, high: 11), 0 as Bit, .ascending,  none)
            Test().count(T(low: ~11, high: 11), 0 as Bit, .ascending,  none + 2 as M)
            
            Test().count(T(low:  00, high: 00), 1 as Bit, .ascending,  none)
            Test().count(T(low: ~00, high: 00), 1 as Bit, .ascending,  half)
            Test().count(T(low:  00, high: 11), 1 as Bit, .ascending,  none)
            Test().count(T(low: ~00, high: 11), 1 as Bit, .ascending,  half + 2 as M)
            Test().count(T(low:  11, high: 00), 1 as Bit, .ascending,  none + 2 as M)
            Test().count(T(low: ~11, high: 00), 1 as Bit, .ascending,  none)
            Test().count(T(low:  11, high: 11), 1 as Bit, .ascending,  none + 2 as M)
            Test().count(T(low: ~11, high: 11), 1 as Bit, .ascending,  none)
            
            Test().count(T(low:  00, high: 00), 0 as Bit, .descending, full)
            Test().count(T(low: ~00, high: 00), 0 as Bit, .descending, half)
            Test().count(T(low:  00, high: 11), 0 as Bit, .descending, half - 4 as M)
            Test().count(T(low: ~00, high: 11), 0 as Bit, .descending, half - 4 as M)
            Test().count(T(low:  11, high: 00), 0 as Bit, .descending, full - 4 as M)
            Test().count(T(low: ~11, high: 00), 0 as Bit, .descending, half)
            Test().count(T(low:  11, high: 11), 0 as Bit, .descending, half - 4 as M)
            Test().count(T(low: ~11, high: 11), 0 as Bit, .descending, half - 4 as M)
            
            Test().count(T(low:  00, high: 00), 1 as Bit, .descending, none)
            Test().count(T(low: ~00, high: 00), 1 as Bit, .descending, none)
            Test().count(T(low:  00, high: 11), 1 as Bit, .descending, none)
            Test().count(T(low: ~00, high: 11), 1 as Bit, .descending, none)
            Test().count(T(low:  11, high: 00), 1 as Bit, .descending, none)
            Test().count(T(low: ~11, high: 00), 1 as Bit, .descending, none)
            Test().count(T(low:  11, high: 11), 1 as Bit, .descending, none)
            Test().count(T(low: ~11, high: 11), 1 as Bit, .descending, none)
        }

        for base in bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testLeastSignificantBit() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            
            Test().same(( T .min).leastSignificantBit, 0 as Bit)
            Test().same(( T .max).leastSignificantBit, 1 as Bit)
            Test().same((~1 as T).leastSignificantBit, 0 as Bit)
            Test().same((~0 as T).leastSignificantBit, 1 as Bit)
            Test().same(( 0 as T).leastSignificantBit, 0 as Bit)
            Test().same(( 1 as T).leastSignificantBit, 1 as Bit)
            Test().same(( 2 as T).leastSignificantBit, 0 as Bit)
            Test().same(( 3 as T).leastSignificantBit, 1 as Bit)
            
            Test().same(T(low:  0, high:  0).leastSignificantBit, 0 as Bit)
            Test().same(T(low:  0, high: ~0).leastSignificantBit, 0 as Bit)
            Test().same(T(low: ~0, high:  0).leastSignificantBit, 1 as Bit)
            Test().same(T(low: ~0, high: ~0).leastSignificantBit, 1 as Bit)
        }
        
        for base in bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Elements
    //=------------------------------------------------------------------------=
    
    func testInitToken() {
        func whereTheBaseTypeIsSigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
                        
            Test().same(T(load:  0 as IX), T(load:  0 as IX))
            Test().same(T(load: -1 as IX), T(load: ~0 as IX))
            Test().same(M(load:  0 as IX), M(load:  0 as IX))
            Test().same(M(load: -1 as IX), M(load: ~0 as IX))
            
            Test().same(T(load:  0 as UX), T(load:  0 as UX))
            Test().same(T(load: ~0 as UX), T(load: ~0 as UX))
            Test().same(M(load:  0 as UX), M(load:  0 as UX))
            Test().same(M(load: ~0 as UX), M(load: ~0 as UX))
        }
        
        for base in bases where base.isSigned {
            whereTheBaseTypeIsSigned(base)
        }
    }
    
    func testMakeToken() {
        func whereTheBaseTypeIsSigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            
            Test().same(( 0 as T).load(as: IX.self), IX(load:  0 as T))
            Test().same((~0 as T).load(as: IX.self), IX(load: ~0 as T))
            Test().same(( 0 as M).load(as: IX.self), IX(load:  0 as M))
            Test().same((~0 as M).load(as: IX.self), IX(load: ~0 as M))
            
            Test().same(( 0 as T).load(as: UX.self), UX(load:  0 as T))
            Test().same((~0 as T).load(as: UX.self), UX(load: ~0 as T))
            Test().same(( 0 as M).load(as: UX.self), UX(load:  0 as M))
            Test().same((~0 as M).load(as: UX.self), UX(load: ~0 as M))
        }
        
        for base in bases where base.isSigned {
            whereTheBaseTypeIsSigned(base)
        }
    }
    
    func testInitElement() {
        func whereTheBaseTypeIsSigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            
            Test().load( 0 as T.Element,  0 as T)
            Test().load(-1 as T.Element, ~0 as T)
            Test().load( 0 as T.Element,  0 as M)
            Test().load(-1 as T.Element, ~0 as M)
            
            Test().load( 0 as M.Element,  T( 0 as M.Element))
            Test().load(~0 as M.Element,  T(~0 as M.Element))
            Test().load( 0 as M.Element,  M( 0 as M.Element))
            Test().load(~0 as M.Element,  M(~0 as M.Element))
        }
        
        for base in bases where base.isSigned {
            whereTheBaseTypeIsSigned(base)
        }
    }
    
    func testMakeElement() {
        func whereTheBaseTypeIsSigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            
            Test().load( 0 as T,  0 as T.Element)
            Test().load(-1 as T, ~0 as T.Element)
            Test().load( 0 as T,  0 as M.Element)
            Test().load(-1 as T, ~0 as M.Element)
            
            Test().load( 0 as M,  0 as M.Element)
            Test().load(~0 as M, ~0 as M.Element)
            Test().load( 0 as M,  0 as M.Element)
            Test().load(~0 as M, ~0 as M.Element)
        }
        
        for base in bases where base.isSigned {
            whereTheBaseTypeIsSigned(base)
        }
    }
    
    func testInitBody() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias F = Fallible<T>
            
            let count = MemoryLayout<T>.size / MemoryLayout<T.Element>.stride
            for isSigned in [true, false] {
                Test().elements(( T.min).body(), .isSigned(isSigned), F( T.min, error: !isSigned))
                Test().elements(( T.max).body(), .isSigned(isSigned), F( T.max))
                
                Test().elements(( M.min).body(), .isSigned(isSigned), F( T( 0)))
                Test().elements(( M.max).body(), .isSigned(isSigned), F( T(-1), error: !isSigned))
                Test().elements(( M.msb).body(), .isSigned(isSigned), F( T.min, error: !isSigned))
                Test().elements((~M.msb).body(), .isSigned(isSigned), F(~T.msb))
                
                Test().elements(Array(repeating:  0 as T.Element.Magnitude, count: 1 + count), .isSigned(isSigned), F( 0 as T))
                Test().elements(Array(repeating: ~0 as T.Element.Magnitude, count: 1 + count), .isSigned(isSigned), F(~0 as T, error: !isSigned))
            }
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias F = Fallible<T>
            
            let count = MemoryLayout<T>.size / MemoryLayout<T.Element>.stride
            for isSigned in [true, false] {
                Test().elements(( M.min).body(), .isSigned(isSigned), F( T( 0)))
                Test().elements(( M.max).body(), .isSigned(isSigned), F( T.max, error: isSigned))
                Test().elements(( M.msb).body(), .isSigned(isSigned), F( T.msb, error: isSigned))
                Test().elements((~M.msb).body(), .isSigned(isSigned), F(~T.msb))
                
                Test().elements(Array(repeating:  0 as T.Element.Magnitude, count: 1 + count), .isSigned(isSigned), F( 0 as T))
                Test().elements(Array(repeating: ~0 as T.Element.Magnitude, count: 1 + count), .isSigned(isSigned), F(~0 as T, error: true))
            }
        }
        
        for type in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testMakeBody() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias EX = T.Element.Magnitude
            
            Test().elements(~1 as T, [EX(load: ~1 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<EX>.size))
            Test().elements(~0 as T, [EX(load: ~0 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<EX>.size))
            Test().elements( 0 as T, [EX(load:  0 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<EX>.size))
            Test().elements( 1 as T, [EX(load:  1 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<EX>.size))
            
            Test().elements(~1 as T, [U8(load: ~1 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test().elements(~0 as T, [U8(load: ~0 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test().elements( 0 as T, [U8(load:  0 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test().elements( 1 as T, [U8(load:  1 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            
            Test().elements(~1 as T, [UX(load: ~1 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test().elements(~0 as T, [UX(load: ~0 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test().elements( 0 as T, [UX(load:  0 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test().elements( 1 as T, [UX(load:  1 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
        }

        for type in types {
            whereIs(type)
        }
    }
}
