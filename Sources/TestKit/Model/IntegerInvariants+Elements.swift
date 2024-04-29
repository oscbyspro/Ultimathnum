//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Integer Invariants x Elements
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func exactlySameSizeSystemsIntegers() where T: SystemsInteger {
        test.exactly( S.min, F( T(raw: S.min), error: T.isSigned == false))
        test.exactly( S.lsb, F( T(raw: S.lsb)))
        test.exactly( S.msb, F( T(raw: S.msb), error: T.isSigned == false))
        test.exactly( S.max, F( T(raw: S.max)))
        
        test.exactly(~S.min, F(~T(raw: S.min)))
        test.exactly(~S.lsb, F(~T(raw: S.lsb), error: T.isSigned == false))
        test.exactly(~S.msb, F(~T(raw: S.msb)))
        test.exactly(~S.max, F(~T(raw: S.max), error: T.isSigned == false))
        
        test.exactly( M.min, F( T(raw: M.min)))
        test.exactly( M.lsb, F( T(raw: M.lsb)))
        test.exactly( M.msb, F( T(raw: M.msb), error: T.isSigned == true ))
        test.exactly( M.max, F( T(raw: M.max), error: T.isSigned == true ))
        
        test.exactly(~M.min, F(~T(raw: M.min), error: T.isSigned == true))
        test.exactly(~M.lsb, F(~T(raw: M.lsb), error: T.isSigned == true))
        test.exactly(~M.msb, F(~T(raw: M.msb)))
        test.exactly(~M.max, F(~T(raw: M.max)))
    }
    
    public func exactlyCoreSystemsIntegers() {
        func whereIs<Other>(_ other: Other.Type) where Other: SystemsInteger {
            typealias I = Other.Signitude
            typealias U = Other.Magnitude
            
            test.exactly( I.min, F( T(load:  I.min), error: T.size < I.size || (T.isSigned == false)))
            test.exactly( I.lsb, F( T(load:  I.lsb)))
            test.exactly( I.msb, F( T(load:  I.msb), error: T.size < I.size || (T.isSigned == false)))
            test.exactly( I.max, F( T(load:  I.max), error: T.size < I.size))
            
            test.exactly(~I.min, F(~T(load:  I.min), error: T.size < I.size))
            test.exactly(~I.lsb, F(~T(load:  I.lsb), error: T.isSigned == false))
            test.exactly(~I.msb, F(~T(load:  I.msb), error: T.size < I.size))
            test.exactly(~I.max, F(~T(load:  I.max), error: T.size < I.size || (T.isSigned == false)))
            
            test.exactly( U.min, F( T(load:  U.min)))
            test.exactly( U.lsb, F( T(load:  U.lsb)))
            test.exactly( U.msb, F( T(load:  U.msb), error: T.size < U.size || (T.isSigned && T.size == U.size)))
            test.exactly( U.max, F( T(load:  U.max), error: T.size < U.size || (T.isSigned && T.size == U.size)))
            
            test.exactly(~U.min, F( T(load: ~U.min), error: T.size < U.size || (T.isSigned && T.size == U.size)))
            test.exactly(~U.lsb, F( T(load: ~U.lsb), error: T.size < U.size || (T.isSigned && T.size == U.size)))
            test.exactly(~U.msb, F( T(load: ~U.msb), error: T.size < U.size))
            test.exactly(~U.max, F( T(load: ~U.max)))
        }
        
        for other in coreSystemsIntegers {
            whereIs(other)
        }
    }
    
    public func exactlyArrayBodyMode() where T: BinaryInteger {
        test.exactly([T.Element.Magnitude](),   .signed, F(T.zero))
        test.exactly([T.Element.Magnitude](), .unsigned, F(T.zero))
        //=--------------------------------------=
        var count = Int(T.size.isInfinite ? 12 : IX(load: T.size) / IX(size: T.Element.self))
        //=--------------------------------------=
        func check(_ body: Array<T.Element.Magnitude>, mode: some Signedness, error: Bool = false) {
            var value = T(repeating: Bit(mode.isSigned && (body.last ?? 0) >= .msb))
            
            for element in body.reversed() {
                value <<= T(T.Element.Magnitude.size)
                value  |= T(load: element)
            }
            
            test.exactly(body, mode, Fallible(value, error: error))
        }
        //=--------------------------------------=
        check(Array(repeating:  0, count: count), mode:   .signed)
        check(Array(repeating:  1, count: count), mode:   .signed)
        check(Array(repeating: ~1, count: count), mode:   .signed, error: !T.isSigned)
        check(Array(repeating: ~0, count: count), mode:   .signed, error: !T.isSigned)
        
        check(Array(repeating:  0, count: count), mode: .unsigned)
        check(Array(repeating:  1, count: count), mode: .unsigned)
        check(Array(repeating: ~1, count: count), mode: .unsigned, error:  T.isSigned && !T.size.isInfinite)
        check(Array(repeating: ~0, count: count), mode: .unsigned, error:  T.isSigned && !T.size.isInfinite)
        
        count += 1
        
        check(Array(repeating:  0, count: count), mode:   .signed)
        check(Array(repeating:  1, count: count), mode:   .signed, error: !T.size.isInfinite)
        check(Array(repeating: ~1, count: count), mode:   .signed, error: !T.isSigned || !T.size.isInfinite)
        check(Array(repeating: ~0, count: count), mode:   .signed, error: !T.isSigned)

        check(Array(repeating:  0, count: count), mode: .unsigned)
        check(Array(repeating:  1, count: count), mode: .unsigned, error: !T.size.isInfinite)
        check(Array(repeating: ~1, count: count), mode: .unsigned, error: !T.size.isInfinite)
        check(Array(repeating: ~0, count: count), mode: .unsigned, error: !T.size.isInfinite)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    public func elements() where T: SystemsInteger {
        typealias X = T.Element.Magnitude
        //=--------------------------------------=
        let count = IX(size: T.self) / IX(size: X.self)
        //=--------------------------------------=
        test.elements(~1 as T, [X(load: ~1 as T)] + [X](repeating: ~0, count: Int(count - 1)), Bit(T.isSigned))
        test.elements(~0 as T, [X(load: ~0 as T)] + [X](repeating: ~0, count: Int(count - 1)), Bit(T.isSigned))
        test.elements( 0 as T, [X(load:  0 as T)] + [X](repeating:  0, count: Int(count - 1)), Bit.zero)
        test.elements( 1 as T, [X(load:  1 as T)] + [X](repeating:  0, count: Int(count - 1)), Bit.zero)
    }
}
