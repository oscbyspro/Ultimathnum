//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Signum x Comparison
//*============================================================================*

extension Signum {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Indicates whether `self` is `negative`.
    @inlinable public var isNegative: Bool {
        self == Self.negative
    }
    
    /// Indicates whether `self` is `zero`.
    @inlinable public var isZero: Bool {
        self == Self.zero
    }
    
    /// Indicates whether `self` is `positive`.
    @inlinable public var isPositive: Bool {
        self == Self.positive
    }
    
    /// Performs a three-way comparison of `self` versus `other`.
    @inlinable public func compared(to other: Self) -> Self {
        if  self < other {
            Self.negative
            
        }   else if self == other {
            Self.zero
            
        }   else {
            Self.positive
        }
    }
}
