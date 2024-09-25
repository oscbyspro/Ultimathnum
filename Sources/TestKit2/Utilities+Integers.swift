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
// MARK: * Utilities x Integers x Edgy
//*============================================================================*

extension EdgyInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var all: ClosedRange<Self> {
        ClosedRange(uncheckedBounds: (Self.min, Self.max))
    }
    
    @inlinable public static var negatives: Range<Self> {
        Range(uncheckedBounds: (Self.min, Self.zero))
    }
    
    @inlinable public static var positives: ClosedRange<Self> {
        ClosedRange(uncheckedBounds: (Self.lsb, Self.max))
    }
    
    @inlinable public static var nonnegatives: ClosedRange<Self> {
        ClosedRange(uncheckedBounds: (Self.zero, Self.max))
    }
    
    @inlinable public static var nonpositives: Range<Self> {
        Range(uncheckedBounds: (Self.min, Self.lsb))
    }
}
