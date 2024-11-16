//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit
//*============================================================================*

/// A binary unit equal to `0` or a `1`.
///
/// ### Development
///
/// - Note: It must not conform to `ExpressibleByIntegerLiteral` (#93).
///
@frozen public struct Bit:
    BitCastable,
    BitOperable,
    Comparable,
    CustomStringConvertible,
    Hashable,
    Recoverable,
    Sendable
{
    
    public typealias BitPattern = Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// A bit set to `0`.
    ///
    /// - Note: A bit can only bet set to `0` or `1`.
    ///
    public static let zero = Self(false)
    
    /// A bit set to `1`.
    ///
    /// - Note: A bit can only bet set to `0` or `1`.
    ///
    public static let one  = Self(true)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns a new instance equal to `zero`.
    ///
    /// - Note: The `BitCastable<Bit.BitPattern>` default is `Bit.zero`.
    ///
    @inlinable public init() {
        self.base = false
    }
    
    /// Reinterprets the given `source` as an instance of `Self`.
    @inlinable public init(_ source: some BitCastable<BitPattern>) {
        self.base = source.load(as: BitPattern.self)
    }
    
    /// Reinterprets the given `source` as an instance of `Self`.
    @inlinable public init(raw source: BitPattern) {
        self.base = source
    }
    
    /// Reinterprets the given `source` as an instance of `BitPattern`.
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        self.base
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        switch self.base {
        case  true: "1"
        case false: "0"
        }
    }
}
