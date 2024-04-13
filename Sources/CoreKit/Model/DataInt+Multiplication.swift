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
    
    @inlinable public func multiply(
        by multiplier: borrowing Element,
        add increment: consuming Element
    )   -> Element {
        var increment = increment // TODO: await ownership fixes
        
        for index in self.indices {
            var  wide = self[unchecked: copy index].multiplication(multiplier)
            wide.high &+= Element(Bit(wide.low.capture(increment){ $0.plus($1) }))
            increment = wide.high
            self[unchecked: copy index] = wide.low
        }
        
        return increment as Element
    }
}
