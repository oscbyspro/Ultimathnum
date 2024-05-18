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
/// This coder unifies all integer types and all common radices (2...36) with
/// a single non-inlinable and non-generic algorithm. This design favors code
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
    
    public static let decimal = Self.radix(10)
    
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
    
    @inlinable public consuming func  lowercased() -> Self {
        self.numerals = self.numerals.lowercased()
        return self
    }
    
    @inlinable public consuming func  uppercased() -> Self {
        self.numerals = self.numerals.uppercased()
        return self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var radix: UX {
        UX(load: self.numerals.radix as U8)
    }
    
    @inlinable public var letters: Letters {
        self.numerals.letters
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.numerals == rhs.numerals
    }
}
