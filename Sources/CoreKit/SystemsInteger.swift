//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Systems Integer
//*============================================================================*

/// A binary systems integer.
///
/// ### Trivial
///
/// Its bit pattern must represent its value. It may not use indirection.
///
/// - Requires: It must be bitwise copyable.
///
/// ### Bit Width
///
/// Keep it simple.
///
/// - Requires: Its bit width must be at least 8.
///
/// - Requires: Its bit width must be a power of 2.
///
/// - Requires: Its bit width must fit in `IX`.
///
/// ### Magnitude
///
/// The magnitude must have the same bit width as this type. It then follows that
/// the magnitude must also be unsigned. This ensures that the type can represent
/// the minimum signed value's magnitude.
///
/// - Requires: Its magnitude must be unsigned and the same size as this type.
///
public protocol SystemsInteger<BitPattern>: BinaryInteger where Section == Self, Magnitude: SystemsInteger, Signitude: SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable borrowing func multiplication(_ multiplier: borrowing Self) -> Doublet<Self>
    
    @inlinable static func division(_ dividend: consuming Doublet<Self>, by divisor: borrowing Self) -> Fallible<Division<Self, Self>>
}
