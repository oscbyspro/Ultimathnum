//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Bitwise x Read|Write|Body
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Toggles each bit in its binary representation.
    @inlinable public borrowing func toggle() {
        for index in self.indices {
            self[unchecked: index][{ $0.toggled() }]
        }
    }
    
    /// Toggles each bit in its binary representation then adds `increment`.
    @inlinable public borrowing func toggle(carrying increment: consuming Bool) -> Bool {
        for index in self.indices {
            increment = self[unchecked: index][{ $0.complement(increment) }]
        }
        
        return increment as Bool
    }
}
