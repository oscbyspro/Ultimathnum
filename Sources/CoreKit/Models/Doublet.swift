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
@frozen public struct Doublet<High>: BitCastable, Comparable, Sendable where High: BinaryInteger {
    
    public typealias High = High
    
    public typealias Low  = High.Magnitude
    
    public typealias BitPattern = Doublet<High.Magnitude>
    
    public typealias Magnitude  = Doublet<High.Magnitude>
    
    public typealias Signitude  = Doublet<High.Signitude>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    #if _endian(big)
    public var high: High
    public var low:  High.Magnitude
    #else
    public var low:  High.Magnitude
    public var high: High
    #endif
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance equal to the `source`.
    ///
    /// - Note: The `high` part of an unsigned `source` is always `0`.
    ///
    @inlinable public init(_ source: consuming High) {
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
    @inlinable public init(low: consuming High.Magnitude) {
        self.low  = low
        self.high = High.zero
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming High.Magnitude, high: consuming High) {
        self.low  = low
        self.high = high
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming BitPattern) {
        self.init(
            low:  source.low,
            high: High(raw: source.high)
        )
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        BitPattern(
            low:  self.low,
            high: High.Magnitude(raw: self.high)
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
