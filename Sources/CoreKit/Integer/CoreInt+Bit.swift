//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Bit
//*============================================================================*

extension CoreInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public func count(_ bit: Bit, option: Bit.Selection) -> Magnitude {
        switch (Bool(bit), option) {
        case (true,         .all): Magnitude(Base.Magnitude(truncatingIfNeeded: ( self).base     .nonzeroBitCount))
        case (false,        .all): Magnitude(Base.Magnitude(truncatingIfNeeded: (~self).base     .nonzeroBitCount))
        case (true,   .ascending): Magnitude(Base.Magnitude(truncatingIfNeeded: (~self).base.trailingZeroBitCount))
        case (false,  .ascending): Magnitude(Base.Magnitude(truncatingIfNeeded: ( self).base.trailingZeroBitCount))
        case (true,  .descending): Magnitude(Base.Magnitude(truncatingIfNeeded: (~self).base .leadingZeroBitCount))
        case (false, .descending): Magnitude(Base.Magnitude(truncatingIfNeeded: ( self).base .leadingZeroBitCount))
        }
    }
}
