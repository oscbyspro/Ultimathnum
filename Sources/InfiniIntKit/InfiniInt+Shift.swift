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
// MARK: * Infini Int x Shift x Signed
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func << (lhs: consuming Self, rhs: borrowing Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func >> (lhs: consuming Self, rhs: borrowing Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        fatalError("TODO")
    }
}

//*============================================================================*
// MARK: * Infini Int x Shift x Unsigned
//*============================================================================*

extension InfiniInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func << (lhs: consuming Self, rhs: borrowing Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func >> (lhs: consuming Self, rhs: borrowing Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        fatalError("TODO")
    }
}
