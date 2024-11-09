//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Order
//*============================================================================*

/// An `ascending` (0) or a `descending` (1) mode of operation.
@frozen public enum Order: BitCastable, Hashable, Sendable {
    
    public typealias BitPattern = Bit.BitPattern
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// The system byte order.
    @inlinable public static var endianess: Self {
        #if _endian(little)
        return Self.ascending
        #elseif _endian(big)
        return Self.descending
        #else
        #error("unknown or invalid system byte order")
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// An `ascending` (0) mode of operation.
    case ascending
    
    /// A `descending` (1) mode of operations.
    case descending
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance form the given indicator.
    ///
    /// The `descending` indicator naturally translates to `Bool`.
    ///
    ///             ┌────────────┬────────────┐
    ///             │   bit == 0 │   bit == 1 |
    ///     ┌───────┼────────────┤────────────┤
    ///     │  Bool │      false │       true │
    ///     ├───────┼────────────┤────────────┤
    ///     │ Order │  ascending │ descending │
    ///     └───────┴────────────┴────────────┘
    ///
    @inlinable public init(descending: Bool) {
        self = descending ? Self.descending : Self.ascending
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Bit) {
        self.init(raw: source)
    }
    
    @inlinable public init(raw source: BitPattern) {
        self = source ? Self.descending : Self.ascending
    }

    @inlinable public func load(as type: BitPattern.Type) -> BitPattern {
        self == Self.descending
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the opposite direction.
    @inlinable public func reversed() -> Self {
        self == Self.descending ? Self.ascending : Self.descending
    }
}
