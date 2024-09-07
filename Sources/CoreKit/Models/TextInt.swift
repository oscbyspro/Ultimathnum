//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Text Int
//*============================================================================*

/// A common text de/encoder for all binary integers.
///
/// ### Tradeoffs
///
/// This coder unifies all binary integer types and all radices (`2...36`)
/// with non-generic and non-inlinable algorithms. This design favors code
/// size over performance.
///
@frozen public struct TextInt: Equatable, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// A `TextInt` instance with a radix of `2`.
    ///
    /// - Note: This value caches the result of `radix(2)`.
    ///
    public static let binary = Self.radix(2)
    
    /// A `TextInt` instance with a radix of `10`.
    ///
    /// - Note: This value caches the result of `radix(10)`.
    ///
    public static let decimal = Self.radix(10)
    
    /// A `TextInt` instance with a radix of `16`.
    ///
    /// - Note: This value caches the result of `radix(16)`.
    ///
    public static let hexadecimal = Self.radix(16)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// A numeral map.
    ///
    /// - Note: Decoding is case insensitive.
    ///
    /// - Note: Encoding is case sensitive.
    ///
    public var numerals: Numerals
    
    /// The number of elements per chunk.
    ///
    /// - Note: It equals the number of numerals in a `power` chunk.
    ///
    @usableFromInline var exponent: IX
    
    /// A 2-by-1 `power` divider.
    ///
    /// - Note: The `divisor` is set to `1` when the real `power` is `max+1`.
    ///
    @usableFromInline let power: Divider21<UX>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance with a radix of `10`.
    @inlinable public init() {
        self = Self.decimal
    }
    
    /// Creates a new instance using the given `radix`.
    ///
    /// - Requires: `2 ≤ radix ≤ 36`
    ///
    /// - Note: Use `init(radix:letters:)` to recover from invalid radices.
    ///
    @inlinable public static func radix(_ radix: some BinaryInteger) -> Self {
        Self.radix(UX(radix))
    }
    
    /// Creates a new instance using the given `radix`.
    ///
    /// - Requires: `2 ≤ radix ≤ 36`
    ///
    /// - Note: Use `init(radix:letters:)` to recover from invalid radices.
    ///
    @inlinable public static func radix(_ radix: UX) -> Self {
        try! Self(radix: radix)
    }
    
    /// Creates a new instance using the given `radix` and `letters`.
    ///
    /// - Requires: `2 ≤ radix ≤ 36`
    ///
    /// - Throws: `TextInt.Error.invalid` if the `radix` is invalid.
    ///
    @inlinable public init(
        radix: some BinaryInteger,
        letters: Letters = .lowercase
    )   throws {
        try self.init(
            radix: try UX.exactly(radix).prune(Error.invalid),
            letters: letters
        )
    }
    
    /// Creates a new instance using the given `radix` and `letters`.
    ///
    /// - Requires: `2 ≤ radix ≤ 36`
    ///
    /// - Throws: `TextInt.Error.invalid` if the `radix` is invalid.
    ///
    @inlinable public init(
        radix: UX,
        letters: Letters = .lowercase
    )   throws {
        self.numerals = try Numerals(radix: radix, letters: letters)
        let exponentiation = try Exponentiation(radix)
        self.exponent = exponentiation.exponent as IX
        self.power = Divider21(Swift.max(1, exponentiation.power))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns a similar instance that encodes `lowercase` numerals.
    @inlinable public consuming func lowercased() -> Self {
        self.letters(Letters.lowercase)
    }
    
    /// Returns a similar instance that encodes `uppercase` numerals.
    @inlinable public consuming func uppercased() -> Self {
        self.letters(Letters.uppercase)
    }
    
    /// Returns an similar instance that encodes the given `letters`.
    @inlinable public consuming func letters(_ letters: Letters) -> Self {
        self.numerals = self.numerals.letters(letters)
        return self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The type of `letters` produced by this instance.
    ///
    /// - Returns: A `lowercase` or `uppercase` indicator.
    ///
    @inlinable public var letters: Letters {
        self.numerals.letters
    }
    
    /// The `radix` of its number system.
    ///
    /// - Returns: A value in the closed range from `2` through `36`.
    ///
    /// - Note: The return type is `U8` to minimize size-related validation.
    ///
    @inlinable public var radix: U8 {
        self.numerals.radix
    }
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.numerals == rhs.numerals
    }
}
