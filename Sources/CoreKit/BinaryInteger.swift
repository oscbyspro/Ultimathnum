//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer
//*============================================================================*

/// A binary integer.
///
/// ### Binary
///
/// Its signedness is with respect to un/signed two's complement.
///
/// - Requires: Negative values must use binary two's complement form.
///
/// ### Magnitude
///
/// Its magnitude may be signed to accomodate lone big integers.
///
/// ### Development
///
/// - TODO: Consider a static { get throws } bit width requirement.
///
/// - TODO: Consider &+ operations with infinite width requirement.
///
/// - TODO: Consider binary integer as an alias for a bit invertible integer.
///
public protocol BinaryInteger: BitCastable, BitOperable, Integer where Magnitude: BinaryInteger, Magnitude.BitPattern == BitPattern { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - FIXME: Consuming caues bad accesss (2024-01-13, Swift 5.9).
    ///
    @inlinable public static func &+(lhs: Self, rhs: Self) -> Self {
        Overflow.ignore({ try lhs.plus(rhs) })
    }
    
    /// ### Development
    ///
    /// - FIXME: Consuming caues bad accesss (2024-01-13, Swift 5.9).
    ///
    @inlinable public static func &-(lhs: Self, rhs: Self) -> Self {
        Overflow.ignore({ try lhs.minus(rhs) })
    }
    
    /// ### Development
    ///
    /// - FIXME: Consuming caues bad accesss (2024-01-13, Swift 5.9).
    ///
    @inlinable public static func &*(lhs: Self, rhs: Self) -> Self {
        Overflow.ignore({ try lhs.times(rhs) })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns whether this value is less than zero.
    ///
    /// It checks `isSigned` first which is preferred in inlinable generic code.
    ///
    @inlinable public var isLessThanZero: Bool {
        Self.isSigned &&  self < 0
    }
}
