//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Doublet
//*============================================================================*

/// An integer split into 2 parts.
@frozen public struct Doublet<Base>: BitCastable, Comparable, Sendable where Base: BinaryInteger {
    
    public typealias High = Base
    
    public typealias Low  = Base.Magnitude
    
    public typealias BitPattern = Doublet<Base.Magnitude>
    
    public typealias Magnitude  = Doublet<Base.Magnitude>
    
    public typealias Signitude  = Doublet<Base.Signitude>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    #if _endian(big)
    public var high: Base
    public var low:  Base.Magnitude
    #else
    public var low:  Base.Magnitude
    public var high: Base
    #endif
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance equal to the `source`.
    ///
    /// - Note: The `high` part of an unsigned `source` is always `0`.
    ///
    @inlinable public init(_ source: consuming Base) {
        let x = Bit(source.isNegative)
        self.low  = Low (raw:  source)
        self.high = High(repeating: x)
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init() {
        self.low  = Low .zero
        self.high = High.zero
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Base.Magnitude) {
        self.low  = low
        self.high = High.zero
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Base.Magnitude, high: consuming Base) {
        self.low  = low
        self.high = high
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming BitPattern) {
        self.init(
            low:  source.low,
            high: Base(raw: source.high)
        )
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        BitPattern(
            low:  self.low,
            high: Base.Magnitude(raw: self.high)
        )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns its components in ascending order.
    @inlinable public consuming func components() -> (low: Low, high: High) {
        (low: self.low, high: self.high)
    }
}
