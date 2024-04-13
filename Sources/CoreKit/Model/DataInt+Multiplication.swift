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
    
    @inlinable borrowing public func multiply(
        by multiplier: borrowing Element,
        add increment: consuming Element
    )   -> Element {
                
        self.multiply(by: multiplier, add: increment, from: IX.zero, to: self.count)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    @inlinable public func multiply(
        by multiplier: borrowing Element,
        add increment: consuming Element,
        from index:    consuming IX,
        to   limit:    consuming IX
    )   -> Element {
        //=--------------------------------------=
        Swift.assert(index >= 00000)
        Swift.assert(index <= limit)
        Swift.assert(limit <= self.count)
        //=--------------------------------------=
        // TODO: await consuming element fixes
        //=--------------------------------------=
        var increment = increment
        
        forwards: while index < limit {
            var  wide = self[unchecked: copy index].multiplication(multiplier)
            wide.high &+= Element(Bit(wide.low.capture(increment){ $0.plus($1) }))
            increment = wide.high
            self[unchecked: copy index] = wide.low
            index = index.plus(1).assert()
        }
        
        return increment as Element
    }
}
