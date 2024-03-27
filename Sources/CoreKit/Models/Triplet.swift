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
@frozen public struct Triplet<Base>: Hashable where Base: SystemsInteger {
    
    public typealias Magnitude = Doublet<Base.Magnitude>
    
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
    
    @inlinable public init(low: Base.Magnitude, mid: Base.Magnitude, high: Base) {
        self.low  = low
        self.mid  = mid
        self.high = high
    }
    
    @inlinable public init(high: Base, mid: Base.Magnitude, low: Base.Magnitude) {
        self.high = high
        self.mid  = mid
        self.low  = low
    }
    
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
