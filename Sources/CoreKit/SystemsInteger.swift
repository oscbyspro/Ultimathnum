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
/// Non-power-of-two-bit-width integers are banned. Keep it simple.
///
/// - Requires: Its bit width must be a power of two.
///
/// - Requires: Its bit width must fit in a signed word (e.g. Swift.Int).
///
/// ### Magnitude
///
/// The magnitude must have the same bit width as this type. It then follows that
/// the magnitude must also be unsigned. This ensures that the type can represent
/// the minimum signed value's magnitude.
///
/// - Requires: Its magnitude must be unsigned and the same size as this type.
///
/// ### Words
///
/// - Requires: Its words collection view must have an identical memory layout.
///
/// ### Development
///
/// Consider primitive static base methods that match stdlib operations:
///
/// ```swift
/// static func addition(_:_:) -> OverflowStatus<Self>
/// static func multiplication112(_:_:) -> Doublet<Self>
/// static func division2111(_:_:) -> Optional<Division<Self, Self>>
/// ```
///
/// - Note: It is an alternative in case typed throws don't perform well.
///
/// ### Development
///
/// - TODO: Consider `static func squaring(_:) -> Doublet<Self>`
///
public protocol SystemsInteger<BitPattern>: BinaryInteger where Magnitude: SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init<T>(load source: T) where T: SystemsInteger<UX.BitPattern>
    
    @inlinable func load<T>(as type: T.Type) -> T where T: SystemsInteger<UX.BitPattern>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func plus (_ decrement: borrowing Self, carrying error: consuming Bool) -> Fallible<Self>
    
    @inlinable consuming func minus(_ increment: borrowing Self, carrying error: consuming Bool) -> Fallible<Self>
    
    @inlinable static func multiplication(_ lhs: borrowing Self, by rhs: borrowing Self) -> DoubleIntLayout<Self>
    
    @inlinable static func division(_ lhs: consuming DoubleIntLayout<Self>, by rhs: borrowing Self) -> Fallible<Division<Self, Self>>
}
