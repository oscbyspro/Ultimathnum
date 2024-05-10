//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Count
//*============================================================================*

extension CoreInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func count(_ selection: Bit) -> Magnitude {
        switch Bool(selection) {
        case true:  Magnitude(Stdlib.Magnitude(truncatingIfNeeded: ( self).base.nonzeroBitCount))
        case false: Magnitude(Stdlib.Magnitude(truncatingIfNeeded: (~self).base.nonzeroBitCount))
        }
    }
    
    @inlinable public func count(_ selection: Bit.Ascending) -> Magnitude {
        switch Bool(selection.bit) {
        case true:  Magnitude(Stdlib.Magnitude(truncatingIfNeeded: (~self).base.trailingZeroBitCount))
        case false: Magnitude(Stdlib.Magnitude(truncatingIfNeeded: ( self).base.trailingZeroBitCount))
        }
    }
    
    @inlinable public func count(_ selection: Bit.Descending) -> Magnitude {
        switch Bool(selection.bit) {
        case true:  Magnitude(Stdlib.Magnitude(truncatingIfNeeded: (~self).base.leadingZeroBitCount))
        case false: Magnitude(Stdlib.Magnitude(truncatingIfNeeded: ( self).base.leadingZeroBitCount))
        }
    }
}
