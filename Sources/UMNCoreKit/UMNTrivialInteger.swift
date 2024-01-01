//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Trivial Integer
//*============================================================================*

/// ### Magnitude
///
/// The magnitude must have the same bit width as this type. It then follows that
/// the magnitude must also be unsigned. This ensures that the type can represent
/// the minimum signed value's magnitude.
///
/// - Requires: The magnitude must be unsigned and the same size as this type.
///
public protocol UMNTrivialInteger: UMNBinaryInteger, UMNBitCastable where
Magnitude: UMNUnsignedInteger & UMNTrivialInteger, Magnitude.BitPattern == BitPattern,
Stdlib: Swift.FixedWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable static var min: Self { get }
    
    @inlinable static var max: Self { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Complements
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func onesComplement() -> Self
    
    @inlinable consuming func twosComplement() -> UMNOverflow<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Logic
    //=------------------------------------------------------------------------=
    
    @inlinable static func &(lhs: consuming Self, rhs: consuming Self) -> Self
    
    @inlinable static func |(lhs: consuming Self, rhs: consuming Self) -> Self
    
    @inlinable static func ^(lhs: consuming Self, rhs: consuming Self) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> UMNFullWidth<Self, Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Division
    //=------------------------------------------------------------------------=
    
    @inlinable static func dividing(_ dividend: consuming UMNFullWidth<Self, Magnitude>, by multiplier: borrowing Self) -> UMNOverflow<UMNQuoRem<Self, Self>>
}
