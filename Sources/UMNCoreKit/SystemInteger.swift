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
public protocol SystemInteger: BinaryInteger, BitCastable 
where Magnitude: UnsignedInteger & SystemInteger, Magnitude.BitPattern == BitPattern {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable static var bitWidth: Self { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable func count(_ bit: Bit, option: Bit.Selection) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Logic
    //=------------------------------------------------------------------------=
    
    @inlinable static prefix func ~(operand: consuming Self) -> Self
    
    @inlinable static func &(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func |(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func ^(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Shifts
    //=------------------------------------------------------------------------=
    
    @inlinable static func  <<(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func  >>(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Multiplication, Division
    //=------------------------------------------------------------------------=
    
    @inlinable static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> FullWidth<Self, Magnitude>
    
    @inlinable static func dividing(_ dividend: consuming FullWidth<Self, Magnitude>, by multiplier: borrowing Self) -> Overflow<QuoRem<Self, Self>>
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension SystemInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var min: Self {
        isSigned ? msb : 0
    }
    
    @inlinable public static var msb: Self {
        1 &<< (bitWidth &- 1)
    }
    
    @inlinable public static var max: Self {
        ~(min)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ bit: Bit) {
        self = bit == (0 as Bit) ? (0 as Self) : ( 1 as Self)
    }
    
    @inlinable public init(repeating bit: Bit) {
        self = bit == (0 as Bit) ? (0 as Self) : (~0 as Self)
    }
}
