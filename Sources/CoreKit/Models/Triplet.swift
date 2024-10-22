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
@frozen public struct Triplet<Base>: BitCastable, Comparable, Sendable where Base: BinaryInteger {
    
    public typealias High = Base
    
    public typealias Mid  = Base.Magnitude
    
    public typealias Low  = Base.Magnitude
    
    public typealias BitPattern = Triplet<Base.Magnitude>
        
    public typealias Magnitude  = Triplet<Base.Magnitude>
    
    public typealias Signitude  = Triplet<Base.Signitude>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    #if _endian(big)
    public var high: Base
    public var mid:  Base.Magnitude
    public var low:  Base.Magnitude
    #else
    public var low:  Base.Magnitude
    public var mid:  Base.Magnitude
    public var high: Base
    #endif
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance equal to the `source`.
    ///
    /// - Note: The `mid` and `high` parts of an unsigned `source` are always `0`.
    ///
    @inlinable public init(_ source: consuming Base) {
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
    @inlinable public init(low: consuming Base.Magnitude) {
        self.low  = low
        self.mid  = Mid .zero
        self.high = High.zero
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Base.Magnitude, mid: consuming Base.Magnitude) {
        self.low  = low
        self.mid  = mid
        self.high = High.zero
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Base.Magnitude, mid: consuming Base.Magnitude, high: consuming Base) {
        self.low  = low
        self.mid  = mid
        self.high = high
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Base.Magnitude, high: consuming Doublet<Base>) {
        self.low  = low
        self.mid  = high.low
        self.high = high.high
    }
    
        /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Doublet<Base.Magnitude>) {
        self.low  = low.low
        self.mid  = low.high
        self.high = High.zero
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Doublet<Base.Magnitude>, high: consuming Base) {
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
            high: Base(raw: source.high)
        )
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        BitPattern(
            low:  self.low,
            mid:  self.mid,
            high: Base.Magnitude(raw: self.high)
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
