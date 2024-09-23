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
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var size: Count {
        Count(raw: IX(Stdlib.bitWidth))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func count(_ bit: Bit) -> Count {
        switch Bool(bit) {
        case true:  Count(raw: ( self).stdlib().nonzeroBitCount)
        case false: Count(raw: (~self).stdlib().nonzeroBitCount)
        }
    }
    
    @inlinable public func ascending(_ bit: Bit) -> Count {
        switch Bool(bit) {
        case true:  Count(raw: (~self).stdlib().trailingZeroBitCount)
        case false: Count(raw: ( self).stdlib().trailingZeroBitCount)
        }
    }
    
    @inlinable public func descending(_ bit: Bit) -> Count {
        switch Bool(bit) {
        case true:  Count(raw: (~self).stdlib().leadingZeroBitCount)
        case false: Count(raw: ( self).stdlib().leadingZeroBitCount)
        }
    }
}
