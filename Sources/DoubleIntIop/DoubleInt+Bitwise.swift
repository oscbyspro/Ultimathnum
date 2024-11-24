//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit

//*============================================================================*
// MARK: * Double Int x Bitwise x Stdlib
//*============================================================================*

extension DoubleInt.Stdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: consuming Self) -> Self {
        Self(~instance.base)
    }
    
    @inlinable public static func &(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base & rhs.base)
    }
    
    @inlinable public static func &=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs & rhs
    }
    
    @inlinable public static func |(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base | rhs.base)
    }
    
    @inlinable public static func |=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs | rhs
    }
    
    @inlinable public static func ^(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base ^ rhs.base)
    }
    
    @inlinable public static func ^=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs ^ rhs
    }
}

//*============================================================================*
// MARK: * Double Int x Bitwise x Stdlib x Swift Fixed Width Integer
//*============================================================================*

extension DoubleInt.Stdlib {

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Systems
    //=------------------------------------------------------------------------=
    
    @inlinable public var byteSwapped: Self {
        Self(self.base.reversed(U8.self))
    }
}
