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
@frozen public struct Triplet<Base>: BitCastable, Comparable where Base: SystemsInteger {
    
    public typealias High = Base
    
    public typealias Mid  = Base.Magnitude
    
    public typealias Low  = Base.Magnitude
    
    public typealias Magnitude = Triplet<Base.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        Base.isSigned
    }
    
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
    
    @inlinable public init(low: consuming Base.Magnitude, mid: consuming Base.Magnitude, high: consuming Base) {
        self.low  = low
        self.mid  = mid
        self.high = high
    }
    
    @inlinable public init(high: consuming Base, mid: consuming Base.Magnitude, low: consuming Base.Magnitude) {
        self.high = high
        self.mid  = mid
        self.low  = low
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(low: consuming Base.Magnitude, high: consuming Doublet<Base>) {
        self.low  = low
        self.mid  = high.low
        self.high = high.high
    }
    
    @inlinable public init(high: consuming Doublet<Base>, low: consuming Base.Magnitude) {
        self.high = high.high
        self.mid  = high.low
        self.low  = low
    }
    
    @inlinable public init(high: consuming Base, low: consuming Doublet<Base.Magnitude>) {
        self.high = high
        self.mid  = low.high
        self.low  = low.low
    }
    
    @inlinable public init(low: consuming Doublet<Base.Magnitude>, high: consuming Base) {
        self.low  = low.low
        self.mid  = low.high
        self.high = high
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(ascending  components: (low: Base.Magnitude, mid: Base.Magnitude, high: Base)) {
        self.init(low: components.low, mid: components.mid, high: components.high)
    }
    
    @inlinable public init(descending components: (high: Base, mid: Base.Magnitude, low: Base.Magnitude)) {
        self.init(high: components.high, mid: components.mid, low: components.low)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var ascending:  (low: Base.Magnitude, mid: Base.Magnitude, high: Base) {
        consuming get {
            (low: self.low, mid: self.mid, high: self.high)
        }
        
        consuming set {
            (low: self.low, mid: self.mid, high: self.high) = newValue
        }
    }
    
    @inlinable public var descending: (high: Base, mid: Base.Magnitude, low: Base.Magnitude) {
        consuming get {
            (high: self.high, mid: self.mid, low: self.low)
        }
        
        consuming set {
            (high: self.high, mid: self.mid, low: self.low) = newValue
        }
    }
}
