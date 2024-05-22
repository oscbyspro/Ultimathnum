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
/// ### Development
///
/// - TODO: Consider adding a `<= UX.size` fast path.
///
@frozen public struct TextInt: Equatable {
    
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
    
    @usableFromInline var numerals: Numerals
    
    @usableFromInline var exponentiation: Exponentiation
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func radix(_ radix: UX) -> Self {
        try! Self(radix: radix, letters: .lowercase)
    }
    
    @inlinable public init(radix: UX, letters: Letters) throws {
        self.numerals = try Numerals(radix, letters: letters)
        self.exponentiation = try Exponentiation(radix)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns a similar instance that encodes `lowercase` numerals.
    @inlinable public consuming func  lowercased() -> Self {
        self.numerals = self.numerals.lowercased()
        return self
    }
    
    /// Returns a similar instance that encodes `uppercase` numerals.
    @inlinable public consuming func  uppercased() -> Self {
        self.numerals = self.numerals.uppercased()
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
    
    /// The `radix` of the number system that is used by this instance.
    ///
    /// - Returns: A value in the closed range from `2` through `36`.
    ///
    @inlinable public var radix: UX {
        UX(load: self.numerals.radix as U8)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.numerals == rhs.numerals
    }
}
