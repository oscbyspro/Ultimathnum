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
    
    @inlinable public func count(_ bit: Bit) -> Magnitude {
        switch Bool(bit) {
        case true:  Magnitude(Stdlib.Magnitude(truncatingIfNeeded: ( self).base.nonzeroBitCount))
        case false: Magnitude(Stdlib.Magnitude(truncatingIfNeeded: (~self).base.nonzeroBitCount))
        }
    }
    
    @inlinable public func ascending(_ bit: Bit) -> Magnitude {
        switch Bool(bit) {
        case true:  Magnitude(Stdlib.Magnitude(truncatingIfNeeded: (~self).base.trailingZeroBitCount))
        case false: Magnitude(Stdlib.Magnitude(truncatingIfNeeded: ( self).base.trailingZeroBitCount))
        }
    }
    
    @inlinable public func descending(_ bit: Bit) -> Magnitude {
        switch Bool(bit) {
        case true:  Magnitude(Stdlib.Magnitude(truncatingIfNeeded: (~self).base.leadingZeroBitCount))
        case false: Magnitude(Stdlib.Magnitude(truncatingIfNeeded: ( self).base.leadingZeroBitCount))
        }
    }
}
