//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Bit x Canvas
//*============================================================================*

extension DataInt.Canvas {
    
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
    @inlinable public borrowing func toggle(carrying increment: inout Bool) {
        for index in self.indices {
            increment = self[unchecked: index][{ $0.complement(increment) }]
        }
    }
}
