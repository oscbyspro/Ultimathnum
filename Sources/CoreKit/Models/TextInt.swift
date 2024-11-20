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

/// A lone description coder for all binary integers types.
///
/// ### Format
///
/// The baseline binary integer description starts with a conditional sign,
/// followed by a conditional mask, and then a mandatory sequence of radix-appropriate
/// numerals. In other words, it matches the following regular expression:
///
/// ```swift
/// let regex: Regex = #/^(\+|-)?(&)?([0-9A-Za-z]+)$/#
/// ```
///
/// Negative values must contain a minus sign (`"-"`) and infinite values must
/// contain a binary integer infinity mask (`"&"`). Natural values may contain
/// a plus sign (`"+"`). Zero may contain either sign, or no sign. The numeral
/// part may also contain redundant leading zeros.
///
/// - Note: The default encoding strategy only includes essential elements.
///
/// - Note: The numerals of infinite values represent some distance from the
///   maximum infinite magnitude of an unsigned and arbitrary binary integer.
///   As such, `&1` translates to `UXL.max-1`.
///
@frozen public struct TextInt: Equatable, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// A `TextInt` instance with a radix of `2`.
    ///
    /// - Note: This value caches the result of `radix(2)`.
    ///
    public static let binary = Self.radix(2)!
    
    /// A `TextInt` instance with a radix of `10`.
    ///
    /// - Note: This value caches the result of `radix(10)`.
    ///
    public static let decimal = Self.radix(10)!
    
    /// A `TextInt` instance with a radix of `16`.
    ///
    /// - Note: This value caches the result of `radix(16)`.
    ///
    public static let hexadecimal = Self.radix(16)!
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// A numeral map.
    ///
    /// - Note: Decoding is case insensitive.
    ///
    /// - Note: Encoding is case sensitive.
    ///
    /// ### Development
    ///
    /// - Note: I wish `@inlinable` did not break `private(set)` access.
    ///
    /// - Note: Arbitrary mutations may break `exponent` and `power` invariants.
    ///
    @usableFromInline var base: Numerals
    
    /// The number of elements per chunk.
    ///
    /// - Note: It equals the number of numerals in a `power` chunk.
    ///
    @usableFromInline let exponent: IX
    
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
    @inlinable public static func radix(_ radix: some BinaryInteger) -> Optional<Self> {
        Self.radix(UX(radix))
    }
    
    /// Creates a new instance using the given `radix`.
    ///
    /// - Requires: `2 ≤ radix ≤ 36`
    ///
    @inlinable public static func radix(_ radix: UX) -> Optional<Self> {
        Self(radix: radix)
    }
    
    /// Creates a new instance using the given `radix` and `letters`.
    ///
    /// - Requires: `2 ≤ radix ≤ 36`
    ///
    @inlinable public init?(radix: some BinaryInteger, letters: Letters = .lowercase) {
        guard let radix = UX.exactly(radix).optional() else { return nil }
        self.init(radix:  radix, letters: letters)
    }
    
    /// Creates a new instance using the given `radix` and `letters`.
    ///
    /// - Requires: `2 ≤ radix ≤ 36`
    ///
    @inlinable public init?(radix: UX, letters: Letters = .lowercase) {
        guard let base = Numerals(radix: radix, letters: letters) else { return nil }
        guard let exponentiation = Exponentiation.init(((radix))) else { return nil }
        
        self.base = base
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
        self.base = self.base.letters(letters)
        return self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A numeral map.
    ///
    /// - Note: Decoding is case insensitive.
    ///
    /// - Note: Encoding is case sensitive.
    ///
    @inlinable public var numerals: Numerals {
        self.base
    }

    /// The type of `letters` produced by this instance.
    ///
    /// - Returns: A `lowercase` or `uppercase` indicator.
    ///
    @inlinable public var letters: Letters {
        self.base.letters
    }
    
    /// The `radix` of its number system.
    ///
    /// - Returns: A value in the closed range from `2` through `36`.
    ///
    /// - Note: The return type is `U8` to minimize size-related validation.
    ///
    @inlinable public var radix: U8 {
        self.base.radix
    }
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.base == rhs.base
    }
}
