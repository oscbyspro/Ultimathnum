//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Countable x Count
//*============================================================================*

extension BitCountable {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func count(_ selection: Bit) -> BitCount {
        Bit.Anywhere<Self>(selection).count(in: self)
    }
    
    @inlinable public borrowing func count(_ selection: some BitSelection<Self>) -> BitCount {
        selection.count(in: self)
    }
}
