//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Signed Int x Comparison
//*============================================================================*

extension SignedInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func compared(to other: Self) -> Signum {
        let signum: Signum = if self.sign == other.sign {
            self.magnitude.compared(to: other.magnitude)
        }   else {
            self.magnitude == 0 && other.magnitude == 0 ? 0 : 1 as Signum
        }
        
        return self.sign == .plus ? signum : signum.negated()
    }
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.compared(to: rhs) == .same
    }
    
    @inlinable public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.compared(to: rhs) == .less
    }
}
