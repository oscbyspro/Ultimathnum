//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Count x Comparison
//*============================================================================*

extension Count {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.base == rhs.base
    }
    
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        UX(raw: lhs.base) < UX(raw: rhs.base)
    }
    
    @inlinable public borrowing func compared(to other: Self) -> Signum {
        UX(raw: self.base).compared(to:  UX(raw: other.base))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Indicates whether this value is zero.
    @inlinable public var isZero: Bool {
        self.base.isZero
    }
    
    /// Indicates whether this value is infinite.
    @inlinable public var isInfinite: Bool {
        Bool(self.base.appendix)
    }
    
    /// Indicates whether this value is a power of `2`.
    ///
    /// - Note: `log2(&0+1)` is the only representable infinite power of `2`.
    ///
    @inlinable public var isPowerOf2: Bool {
        if  self.base.isPositive {
            return (self.base & self.base.decremented().unchecked()).isZero
            
        }   else {
            return (self == Self.infinity)
        }
    }
}
