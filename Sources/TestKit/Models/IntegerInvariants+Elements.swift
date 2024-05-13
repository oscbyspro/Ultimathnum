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
    
    public func exactlyArrayBodyMode() where T: BinaryInteger {
        test.exactly([T.Element.Magnitude](),   .signed, F(T.zero))
        test.exactly([T.Element.Magnitude](), .unsigned, F(T.zero))
        //=--------------------------------------=
        var count = Int(T.size.isInfinite ? 12 : IX(load: T.size) / IX(size: T.Element.self))
        //=--------------------------------------=
        func check(_ body: Array<T.Element.Magnitude>, mode: some Signedness, error: Bool = false) {
            var value = T(repeating: Bit(mode.matchesSignedTwosComplementFormat && (body.last ?? 0) >= .msb))
            
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
    // MARK: Utilities
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
