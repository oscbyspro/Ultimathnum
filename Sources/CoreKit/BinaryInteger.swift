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
public protocol BinaryInteger: BitCastable, BitOperable, Comparable, 
ExpressibleByIntegerLiteral, Hashable, Sendable, _MaybeLosslessStringConvertible where
Magnitude.BitPattern == BitPattern, Magnitude.Element == Element.Magnitude {
    
    associatedtype Element: SystemsInteger = Self where Element.Element == Element
    
    associatedtype Content: RandomAccessCollection<Element.Magnitude> = CollectionOfOne<Element.Magnitude>
    
    associatedtype Magnitude: UnsignedInteger where Magnitude.Magnitude == Magnitude
    
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
    
    /// ### Development
    ///
    /// - TODO: Consider whether this can be derived by bit casting.
    ///
    @inlinable init(sign: consuming Sign, magnitude: consuming Magnitude) throws
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    @inlinable init<T>(load source: T) where T: BitCastable<Element.BitPattern>
    
    @inlinable init<T>(load source: inout ExchangeInt<T, Element>.BitPattern.Stream)
    
    @inlinable func load<T>(as type: T.Type) -> T where T: BitCastable<Element.BitPattern>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init<T>(load source: T) where T: BitCastable<UX.BitPattern>
        
    @inlinable func load<T>(as type: T.Type) -> T where T: BitCastable<UX.BitPattern>
    
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
    
    /// The bit that may extend the bit pattern of this instance.
    ///
    /// If this value is `signed`, then the `appendix` is `1` for `negative`
    /// values and `0` otherwise. If this value is `unsigned`, then the `appendix`
    /// is `1` for `infinite` values and `0` otherwise.
    ///
    /// ### Development
    ///
    /// This requirement is an alternative to a static `isInfinite` value. One
    /// can derive the other, so it is a design choice. See:
    ///
    /// ```swift
    /// @inlinable public static var isInfinite: Bool {
    ///     Self.bitWidth.appendix == 1
    /// }
    /// ```
    ///
    /// ```swift
    /// @inlnable public var appendix: Bit {
    ///     Bit(bitPattern: (Self.isSigned || Self.isInfinite) && self.count(0, option: .descending) == 0)
    /// }
    /// ```
    ///
    @inlinable var appendix: Bit { borrowing get }
    
    @inlinable var elements: ExchangeInt<Content, Element> { consuming get }
    
    @inlinable var magnitude: Magnitude { consuming get }
    
    @inlinable borrowing func compared(to other: borrowing Self) -> Signum
    
    @inlinable borrowing func count(_ bit: Bit, option: Bit.Selection) -> Magnitude
}
