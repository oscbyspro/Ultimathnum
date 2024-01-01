//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x System Integer
//*============================================================================*

/// A binary system integer.
///
/// ### Bit Width
///
/// Non-power-of-two-bit-width integers are banned.
///
/// - Requires: Its bit width must be a power of two.
///
/// - Note: Write better algorithms; don't push anti-pattern models.
///
/// ### Endianess
///
/// - Requires: It must match the platform's endianess.
///
/// ### Magnitude
///
/// The magnitude must have the same bit width as this type. It then follows that
/// the magnitude must also be unsigned. This ensures that the type can represent
/// the minimum signed value's magnitude.
///
/// - Requires: Its magnitude must be unsigned and the same size as this type.
///
/// ### Storage
///
/// Its bit pattern must be its value. It may not contain any indirection.
///
/// - Requires: Its storage must be trivial.
///
public protocol UMNSystemInteger: UMNBinaryInteger, UMNBitCastable where
Magnitude: UMNUnsignedInteger & UMNSystemInteger, Magnitude.BitPattern == BitPattern,
Stdlib: Swift.FixedWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable static var bitWidth: Self { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> UMNFullWidth<Self, Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Division
    //=------------------------------------------------------------------------=
    
    @inlinable static func dividing(_ dividend: consuming UMNFullWidth<Self, Magnitude>, by multiplier: borrowing Self) -> UMNOverflow<UMNQuoRem<Self, Self>>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Logic
    //=------------------------------------------------------------------------=
    
    @inlinable static prefix func ~(operand: consuming Self) -> Self
    
    @inlinable static func &(lhs: consuming Self, rhs: consuming Self) -> Self
    
    @inlinable static func |(lhs: consuming Self, rhs: consuming Self) -> Self
    
    @inlinable static func ^(lhs: consuming Self, rhs: consuming Self) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Shifts
    //=------------------------------------------------------------------------=
    
    @inlinable static func  <<(lhs: consuming Self, rhs: consuming Self) -> Self
    
    @inlinable static func &<<(lhs: consuming Self, rhs: consuming Self) -> Self
    
    @inlinable static func  >>(lhs: consuming Self, rhs: consuming Self) -> Self
    
    @inlinable static func &>>(lhs: consuming Self, rhs: consuming Self) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension UMNSystemInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static var min: Self {
        Self.isSigned ? 1 &<<  Self.bitWidth &- 1 : 0
    }

    @inlinable public static var max: Self {
        ~Self.min
    }
}