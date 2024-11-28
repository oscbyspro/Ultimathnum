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
    
    @inline(never) @inlinable public consuming func up(_ distance: Shift<Magnitude>) -> Self {
        if  let distance = distance.natural().optional() {
            let divisor  = Nonzero<IX>(size: Element.self)
            let division = distance.division(divisor).unchecked() as Division<IX, IX>
            self.storage.upshift(major: division.quotient, minor: division.remainder)
            Swift.assert(self.storage.isNormal)
            return self as Self as Self as Self
            
        }   else {
            let zeros = UX(raw: self.ascending(Bit.zero))
            let index = UX(raw: distance.value).toggled()
            precondition(zeros  >= index, String.overallocation())
            return Self.zero // overshift of all nonzero bits
        }
    }
    
    @inline(never) @inlinable public consuming func down(_ distance: Shift<Magnitude>) -> Self {
        if  let distance = distance.natural().optional() {
            let divisor  = Nonzero<IX>(size: Element.self)
            let division = distance.division(divisor).unchecked() as Division<IX, IX>
            self.storage.downshift(major: division.quotient, minor: division.remainder)
            Swift.assert(self.storage.isNormal)
            return self as Self as Self as Self
            
        }   else {
            return Self(repeating: self.appendix)
        }
    }
}
