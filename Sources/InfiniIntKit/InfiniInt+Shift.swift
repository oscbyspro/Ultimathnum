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
    
    @inline(never) @inlinable public consuming func upshift(_ distance: Shift<Self>) -> Self {
        //=--------------------------------------=
        Swift.assert(!distance.value.isInfinite)
        Swift.assert(!distance.value.isNegative)
        //=--------------------------------------=
        // path: zero would otherwise denormalize
        //=--------------------------------------=
        if  self.isZero {
            return self
        }
        //=--------------------------------------=
        let shift = IX.exactly(distance.value).unwrap("BinaryInteger/entropy/0...IX.max")
        let split = shift.division(Divisor(size: Element.self)).unchecked()
        self.storage.resizeByLenientUpshift(major: split.quotient, minor: split.remainder)
        Swift.assert(self.storage.isNormal)
        return self as Self as Self as Self
    }
    
    @inline(never) @inlinable public consuming func downshift(_ distance: Shift<Self>) -> Self {
        //=--------------------------------------=
        Swift.assert(!distance.value.isInfinite)
        Swift.assert(!distance.value.isNegative)
        //=--------------------------------------=
        let shift = IX.exactly(distance.value)
        //=--------------------------------------=
        // path: distance is >= body per protocol
        //=--------------------------------------=
        if  shift.error {
            return Self(repeating: self.appendix)
        }
        //=--------------------------------------=
        // path: success
        //=--------------------------------------=
        let split = shift.value.division(Divisor(size: Element.self)).unchecked()
        self.storage.resizeByLenientDownshift(major: split.quotient, minor: split.remainder)
        Swift.assert(self.storage.isNormal)
        return self as Self as Self as Self
    }
}
