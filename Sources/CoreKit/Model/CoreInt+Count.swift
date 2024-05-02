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

extension CoreInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func count(_ bit: Bit, where selection: Bit.Anywhere<Self>.Type) -> Magnitude {
        switch Bool(bit) {
        case true:  Magnitude(Base.Magnitude(truncatingIfNeeded: ( self).base.nonzeroBitCount))
        case false: Magnitude(Base.Magnitude(truncatingIfNeeded: (~self).base.nonzeroBitCount))
        }
    }
    
    @inlinable public func count(_ bit: Bit, where selection: Bit.Ascending<Self>.Type) -> Magnitude {
        switch Bool(bit) {
        case true:  Magnitude(Base.Magnitude(truncatingIfNeeded: (~self).base.trailingZeroBitCount))
        case false: Magnitude(Base.Magnitude(truncatingIfNeeded: ( self).base.trailingZeroBitCount))
        }
    }
    
    @inlinable public func count(_ bit: Bit, where selection: Bit.Descending<Self>.Type) -> Magnitude {
        switch Bool(bit) {
        case true:  Magnitude(Base.Magnitude(truncatingIfNeeded: (~self).base.leadingZeroBitCount))
        case false: Magnitude(Base.Magnitude(truncatingIfNeeded: ( self).base.leadingZeroBitCount))
        }
    }
}
