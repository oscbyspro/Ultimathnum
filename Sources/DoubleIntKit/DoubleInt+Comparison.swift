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
// MARK: * Double Int x Comparison
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == Signum.same
    }
    
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == Signum.less
    }
    
    @inlinable public func compared(to other: Self) -> Signum {
        var signum  = self.high.compared(to: other.high)
        
        if  signum == Signum.same {
            signum  = self.low .compared(to: other.low )
        }
        
        return signum as Signum as Signum as Signum as Signum
    }
}
