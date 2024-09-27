//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Sign x Text
//*============================================================================*

extension Sign {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given `ASCII` representation.
    ///
    /// ```swift
    /// Sign(ascii: 42) // nil
    /// Sign(ascii: 43) // plus
    /// Sign(ascii: 44) // nil
    /// Sign(ascii: 45) // minus
    /// Sign(ascii: 46) // nil
    /// ```
    ///
    @inlinable public init?(ascii: some BinaryInteger) {
        guard let small = UX.exactly(ascii).optional() else { return nil }
        self.init(ascii: small)
    }
    
    /// Creates a new instance from the given `ASCII` representation.
    ///
    /// ```swift
    /// Sign(ascii: 42) // nil
    /// Sign(ascii: 43) // plus
    /// Sign(ascii: 44) // nil
    /// Sign(ascii: 45) // minus
    /// Sign(ascii: 46) // nil
    /// ```
    ///
    @inlinable public init?(ascii: UX) {
        switch ascii {
        case 43: self = Self.plus
        case 45: self = Self.minus
        default: return nil
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The `ASCII` representation of `self`.
    ///
    /// ```swift
    /// Sign.plus .ascii // 43 (description: "+")
    /// Sign.minus.ascii // 45 (description: "-")
    /// ```
    ///
    @inlinable public var ascii: U8 {
        switch self {
        case  .plus: 43
        case .minus: 45
        }
    }
    
    /// AA textual representation of `self`.
    ///
    /// ```swift
    /// Sign.plus .description // "+" (ASCII: 43)
    /// Sign.minus.description // "-" (ASCII: 45)
    /// ```
    ///
    @inlinable public var description: String {
        switch self {
        case  .plus: "+"
        case .minus: "-"
        }
    }
}
