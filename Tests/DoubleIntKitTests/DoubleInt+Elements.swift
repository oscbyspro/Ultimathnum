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
// MARK: * Double Int x Elements
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
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
        
        for base in Self.bases where base.isSigned {
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
        
        for base in Self.bases where base.isSigned {
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
        
        for base in Self.bases where base.isSigned {
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
        
        for base in Self.bases where base.isSigned {
            whereTheBaseTypeIsSigned(base)
        }
    }
    
    func testInitBody() {
        func whereIsSigned<T, U>(_ type: T.Type, _ mode: U) where T: SystemsInteger, U: Signedness {
            typealias M = T.Magnitude
            typealias F = Fallible<T>
            
            let count = MemoryLayout<T>.size / MemoryLayout<T.Element>.stride
            
            Test().elements(( T.min).body(), mode, F( T.min, error: !mode.isSigned))
            Test().elements(( T.max).body(), mode, F( T.max))
            
            Test().elements(( M.min).body(), mode, F( T( 0)))
            Test().elements(( M.max).body(), mode, F( T(-1), error: !mode.isSigned))
            Test().elements(( M.msb).body(), mode, F( T.min, error: !mode.isSigned))
            Test().elements((~M.msb).body(), mode, F(~T.msb))
            
            Test().elements(Array(repeating:  0 as T.Element.Magnitude, count: 1 + count), mode, F( 0 as T))
            Test().elements(Array(repeating: ~0 as T.Element.Magnitude, count: 1 + count), mode, F(~0 as T, error: !mode.isSigned))
        }
        
        func whereIsUnsigned<T, U>(_ type: T.Type, _ mode: U) where T: SystemsInteger, U: Signedness {
            typealias M = T.Magnitude
            typealias F = Fallible<T>
            
            let count = MemoryLayout<T>.size / MemoryLayout<T.Element>.stride
            
            Test().elements(( M.min).body(), mode, F( T( 0)))
            Test().elements(( M.max).body(), mode, F( T.max, error: mode.isSigned))
            Test().elements(( M.msb).body(), mode, F( T.msb, error: mode.isSigned))
            Test().elements((~M.msb).body(), mode, F(~T.msb))
            
            Test().elements(Array(repeating:  0 as T.Element.Magnitude, count: 1 + count), mode, F( 0 as T))
            Test().elements(Array(repeating: ~0 as T.Element.Magnitude, count: 1 + count), mode, F(~0 as T, error: true))
        }
        
        for type in Self.types {
            for mode: any Signedness in [Signed(), Unsigned()] {
                type.isSigned ? whereIsSigned(type, mode) : whereIsUnsigned(type, mode)
            }
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

        for type in Self.types {
            whereIs(type)
        }
    }
}
