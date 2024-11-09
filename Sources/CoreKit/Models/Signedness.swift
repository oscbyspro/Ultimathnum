//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Signedness
//*============================================================================*

/// An `unsigned` (0) or a `signed` (1) mode of operation.
@frozen public enum Signedness: BitCastable, Hashable, Sendable {
    
    public typealias BitPattern = Bit.BitPattern
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// An `unsigned` (0) mode of operation.
    ///
    /// - Note: The `appendix` of a `unsigned` integer signals infinity.
    ///
    case unsigned
    
    /// A `signed` (1) mode of operations.
    ///
    /// - Note: The `appendix` of a `signed` integer signals negativity.
    ///
    case signed
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance form the given indicator.
    ///
    /// The `signed` indicator naturally translates to `Bool`.
    ///
    ///                  ┌──────────┬──────────┐
    ///                  │ bit == 0 │ bit == 1 |
    ///     ┌────────────┼──────────┤──────────┤
    ///     │       Bool │    false │     true │
    ///     ├────────────┼──────────┤──────────┤
    ///     │ Signedness │ unsigned │   signed │
    ///     └────────────┴──────────┴──────────┘
    ///
    @inlinable public init(signed: Bool) {
        self = signed ? Self.signed : Self.unsigned
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Bit) {
        self.init(raw: source)
    }
    
    @inlinable public init(raw source: BitPattern) {
        self.init(signed: source)
    }

    @inlinable public func load(as type: BitPattern.Type) -> BitPattern {
        self == Self.signed
    }
}
