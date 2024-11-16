//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Sign
//*============================================================================*

@frozen public enum Sign: BitCastable, BitOperable, CustomStringConvertible, Hashable, Interoperable, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    case plus
    case minus
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns a new instance equal to `plus`.
    ///
    /// - Note: The `BitCastable<Bit.BitPattern>` default is `Bit.zero`.
    ///
    @inlinable public init() {
        self = Self.plus
    }
    
    @inlinable public init(_ source: Bit) {
        self.init(raw: source)
    }
    
    @inlinable public init(_ source: Bool) {
        self.init(raw: source)
    }
    
    @inlinable public init(_ source: FloatingPointSign) {
        self.init(raw: source)
    }
    
    @inlinable public func stdlib() -> FloatingPointSign {
        FloatingPointSign(self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: Bool) {
        self = source ? Self.minus : Self.plus
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        self == Self.minus
    }
}
