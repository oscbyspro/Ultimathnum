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
// MARK: * Infini Int x Comparison x Signed
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == Signum.less
    }
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == Signum.same
    }
    
    @inlinable public func compared(to other: borrowing Self) -> Signum {
        fatalError("TODO")
    }
}

//*============================================================================*
// MARK: * Infini Int x Comparison x Unsigned
//*============================================================================*

extension InfiniInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == Signum.less
    }
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == Signum.same
    }
    
    @inlinable public func compared(to other: borrowing Self) -> Signum {
        fatalError("TODO")
    }
}
