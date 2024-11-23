//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Triplet
//*============================================================================*

/// An integer split into 3 parts.
@frozen public struct Triplet<High>: BitCastable, Comparable, Sendable where High: BinaryInteger {
    
    public typealias High = High
    
    public typealias Mid  = High.Magnitude
    
    public typealias Low  = High.Magnitude
    
    public typealias BitPattern = Triplet<High.Magnitude>
        
    public typealias Magnitude  = Triplet<High.Magnitude>
    
    public typealias Signitude  = Triplet<High.Signitude>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    #if _endian(big)
    public var high: High
    public var mid:  High.Magnitude
    public var low:  High.Magnitude
    #else
    public var low:  High.Magnitude
    public var mid:  High.Magnitude
    public var high: High
    #endif
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance equal to the `source`.
    ///
    /// - Note: The `mid` and `high` parts of an unsigned `source` are always `0`.
    ///
    @inlinable public init(_ source: consuming High) {
        let x = Bit(source.isNegative)
        self.low  = Low (raw:  source)
        self.mid  = Mid (repeating: x)
        self.high = High(repeating: x)
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init() {
        self.low  = Low .zero
        self.mid  = Mid .zero
        self.high = High.zero
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming High.Magnitude) {
        self.low  = low
        self.mid  = Mid .zero
        self.high = High.zero
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming High.Magnitude, mid: consuming High.Magnitude) {
        self.low  = low
        self.mid  = mid
        self.high = High.zero
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming High.Magnitude, mid: consuming High.Magnitude, high: consuming High) {
        self.low  = low
        self.mid  = mid
        self.high = high
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming High.Magnitude, high: consuming Doublet<High>) {
        self.low  = low
        self.mid  = high.low
        self.high = high.high
    }
    
        /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Doublet<High.Magnitude>) {
        self.low  = low.low
        self.mid  = low.high
        self.high = High.zero
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Doublet<High.Magnitude>, high: consuming High) {
        self.low  = low.low
        self.mid  = low.high
        self.high = high
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming BitPattern) {
        self.init(
            low:  source.low,
            mid:  source.mid,
            high: High(raw: source.high)
        )
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        BitPattern(
            low:  self.low,
            mid:  self.mid,
            high: High.Magnitude(raw: self.high)
        )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns its components in ascending order.
    @inlinable public consuming func components() -> (low: Low, mid: Mid, high: High) {
        (low: self.low, mid: self.mid, high: self.high)
    }
}
