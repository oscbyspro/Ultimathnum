//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Signum x Addition
//*============================================================================*

extension Signum {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the additive inverse of `self`
    @inlinable public mutating func negate() {
        self = self.negated()
    }
    
    /// Returns the additive inverse of `self`
    @inlinable public consuming func negated() -> Self {
        switch self {
        case Self.negative: Self.positive
        case Self.zero:     Self.zero
        case Self.positive: Self.negative
        }
    }
    
    /// Returns the additive inverse of `self`
    @inlinable public static prefix func -(instance: consuming Self) -> Self {
        instance.negated()
    }
}
