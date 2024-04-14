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
// MARK: * Data Int x Bit x Canvas
//*============================================================================*

extension DataInt.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable public borrowing func toggle() {
        for index in self.indices {
            self[unchecked: index].capture(~)
        }
    }
    
    @inlinable public borrowing func toggle(carrying increment: inout Bool) {
        for index in self.indices {
            increment = self[unchecked: index].capture {
                $0.complement(increment)
            }
        }
    }
}
