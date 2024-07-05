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
    
    public func elements() {
        //=--------------------------------------=
        typealias X = T.Element.Magnitude
        //=--------------------------------------=
        if  let size  = IX(size: T.self) {
            let count = Swift.Int(size / IX(size: X.self))
            
            test.elements(~1 as T, [X(load: ~1 as T)] + [X](repeating: ~0, count: count - 1), Bit(T.isSigned))
            test.elements(~0 as T, [X(load: ~0 as T)] + [X](repeating: ~0, count: count - 1), Bit(T.isSigned))
            test.elements( 0 as T, [X(load:  0 as T)] + [X](repeating:  0, count: count - 1), 000000000000000)
            test.elements( 1 as T, [X(load:  1 as T)] + [X](repeating:  0, count: count - 1), 000000000000000)
        }
        
        element: do {
            let mask = T(load: X.max)
            
            var x = ~9 as T
            var y = ~9 as X.Signitude
            var z = ~9 as X.Magnitude
            
            for _ in 0 ..< 20 {
                test.load(y,  x)
                test.load(z,  x & mask)
                
                test.load(x,  y)
                test.load(x & mask,  y)
                
                x &+= 1
                y &+= 1
                z &+= 1
            }
        }
        
        sequences: do { 
            let size = UX(1 + Self.shlEsque)
            
            for offset: UX in (1 ... 12).lazy.map({ $0 &* size >> 3 }) {
                var element = X.zero
                var integer = T.zero
                var elements: [X] = []
                
                for x in (1 ... size >> 3).lazy.map({ $0  &+ offset }) {
                    integer <<= 8
                    element <<= 8
                    integer  |= T(load: x & 0xFF)
                    element  |= X(load: x & 0xFF)
                    
                    if  x % UX(size: X.self) >> 3 == 0 {
                        elements.insert(element, at: 0)
                    }
                }
                
                test.elements(integer,           elements,        Bit(!T.size.isInfinite && T.isSigned && elements.last! >= .msb))
                test.elements(integer.toggled(), elements.map(~), Bit( T.size.isInfinite || T.isSigned && elements.last! <  .msb))
            }
        }
    }
    
    public func exactlyArrayBodyMode() where T: BinaryInteger {
        //=--------------------------------------=
        typealias X = T.Element.Magnitude
        //=--------------------------------------=
        test.exactly([X](),   .signed, F(T.zero))
        test.exactly([X](), .unsigned, F(T.zero))
        //=--------------------------------------=
        func check(_ body: Array<X>, mode: Signedness, error: Bool = false) {
            var value = T(repeating: Bit(mode == .signed && (body.last ?? 0) >= .msb))
            
            for element in body.reversed() {
                value <<= T(load: IX(size: X.self))
                value  |= T(load: element)
            }
            
            test.exactly(body, mode, Fallible(value, error: error))
        }
        //=--------------------------------------=
        always: do { 
            var count = Int(T.size.isInfinite ? 12 : IX(size: T.self)! / IX(size: X.self))
            
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
    }
}
