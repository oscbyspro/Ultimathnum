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
// MARK: * Infini Int x Shift
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inline(never) @inlinable public consuming func up(_ distance: Shift<Self>) -> Self {
        //=--------------------------------------=
        Swift.assert(!distance.value.isInfinite)
        Swift.assert(!distance.value.isNegative)
        //=--------------------------------------=
        // path: flush >= IX.max as per protocol
        //=--------------------------------------=
        guard let distance = IX.exactly(distance.value).optional() else {
            return Self.zero
        }
        //=--------------------------------------=
        let division = distance.division(Divisor(size: Element.self)).unchecked()
        self.storage.upshift(major: division.quotient, minor: division.remainder)
        Swift.assert(self.storage.isNormal)
        return self as Self as Self as Self
    }
    
    @inline(never) @inlinable public consuming func down(_ distance: Shift<Self>) -> Self {
        //=--------------------------------------=
        Swift.assert(!distance.value.isInfinite)
        Swift.assert(!distance.value.isNegative)
        //=--------------------------------------=
        // path: flush >= IX.max as per protocol
        //=--------------------------------------=
        guard let distance = IX.exactly(distance.value).optional() else {
            return Self(repeating: self.appendix)
        }
        //=--------------------------------------=
        // path: success
        //=--------------------------------------=
        let division = distance.division(Divisor(size: Element.self)).unchecked()
        self.storage.downshift(major: division.quotient, minor: division.remainder)
        Swift.assert(self.storage.isNormal)
        return self as Self as Self as Self
    }
}
