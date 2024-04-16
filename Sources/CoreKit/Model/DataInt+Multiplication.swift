//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Multiplication x Canvas x Element
//*============================================================================*

extension DataInt.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the `low` part and returns the `high` part of multiplying `self`
    /// by `multiplier` then adding `increment`.
    ///
    /// - Returns: The `low` part is stored in `self` and the `high` part is returned.
    ///   Note that the largest result is `(low: [0] * count, high: ~0)`.
    ///
    /// - Important: This is `unsigned` and `finite`.
    ///
    @inlinable public consuming func multiply(
        by multiplier: borrowing Element,
        add increment: consuming Element
    )   -> Element {
        
        while UX(bitPattern: self.count) > 0 {
            var  wide = self[unchecked: Void()].multiplication(multiplier)
            wide.high &+= Element(Bit(wide.low.capture({ $0.plus(increment) })))
            increment = wide.high
            self[unchecked: Void()] = wide.low
            self = (consume self)[unchecked: 1...] // consume: this is a compiler bug...
        }
        
        return increment as Element
    }
}
