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

/// A `unsigned` (0) or `signed` (1) mode of operation.
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
    @inlinable public init(isSigned: Bool) {
        self = isSigned ? Self.signed : Self.unsigned
    }
    
    /// Indicates whether `self` matches the `signed` case.
    @inlinable public var isSigned: Bool {
        self == Self.signed
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: BitPattern) {
        self.init(isSigned: source)
    }

    @inlinable public func load(as type: BitPattern.Type) -> BitPattern {
        self.isSigned
    }
}
