//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Triple Int Layout x Logic
//*============================================================================*

extension TripleIntLayout {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: consuming Self) -> Self {
        Self(low: ~instance.low, mid: ~instance.mid, high: ~instance.high)
    }
    
    @inlinable public static func &(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(low: lhs.low & rhs.low, mid: lhs.mid & rhs.mid, high: lhs.high & rhs.high)
    }
    
    @inlinable public static func |(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(low: lhs.low | rhs.low, mid: lhs.mid | rhs.mid, high: lhs.high | rhs.high)
    }
    
    @inlinable public static func ^(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(low: lhs.low ^ rhs.low, mid: lhs.mid ^ rhs.mid, high: lhs.high ^ rhs.high)
    }
}
