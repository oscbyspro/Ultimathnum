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
public protocol BinaryInteger: BitCastable, BitOperable, Comparable, ExpressibleByIntegerLiteral, Hashable, Sendable, _MaybeLosslessStringConvertible {
    
    /// ### Development
    ///
    /// - TODO: Consider a concrete contiguous memory buffer.
    ///
    associatedtype Element: SystemsInteger = Self
    
    associatedtype Words: RandomAccessCollection<UX>
        
    associatedtype Magnitude: UnsignedInteger where Magnitude.Magnitude == Magnitude, Magnitude.BitPattern == BitPattern
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    /// Indicates whether this type can represent negative values.
    ///
    /// ```
    /// ┌──────┬──────────┬─────┬─────┐
    /// │ type │ isSigned │ min │ max │
    /// ├──────┼──────────┼─────┼─────┤
    /// │ I1   │ true     │ -1  │   0 │
    /// │ U1   │ false    │  0  │  -1 │
    /// └──────┴──────────┴─────┴─────┘
    /// ```
    ///
    @inlinable static var isSigned: Bool { get }
    
    /// The bit width of this type.
    ///
    /// ```
    /// ┌──────┬───────────────────┐
    /// │ type │ bitWidth          │
    /// ├──────┼───────────────────┤
    /// │ I64  │ U64(repeating: 1) │ // 64
    /// │ IXL  │ UXL(repeating: 1) │ // infinite
    /// └──────┴───────────────────┘
    /// ```
    ///
    @inlinable static var bitWidth: Magnitude { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(sign: consuming Sign, magnitude: consuming Magnitude) throws
    
    @inlinable init(words: consuming some RandomAccessCollection<UX>, isSigned: consuming Bool) throws
    
    @inlinable init(load source: consuming Pattern<some RandomAccessCollection<UX>>)
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func plus(_ increment: borrowing Self) throws -> Self
    
    @inlinable consuming func negated() throws -> Self
    
    @inlinable consuming func minus(_ decrement: borrowing Self) throws -> Self
    
    @inlinable consuming func squared() throws -> Self
    
    @inlinable consuming func times(_ multiplier: borrowing Self) throws -> Self
    
    @inlinable consuming func quotient ( divisor: borrowing Self) throws -> Self
    
    @inlinable consuming func remainder( divisor: borrowing Self) throws -> Self
    
    @inlinable consuming func divided(by divisor: borrowing Self) throws -> Division<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable static func  <<(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func  >>(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable borrowing func compared(to other: borrowing Self) -> Signum
    
    @inlinable func count(_ bit: Bit, option: Bit.Selection) -> Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable var words: Words { consuming get }
    
    @inlinable var magnitude: Magnitude { consuming get }
}
