//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Doublet
//*============================================================================*

/// A `high` and a `low` integer.
@frozen public struct Doublet<High>: Equatable where High: SystemInteger {
    
    public typealias Magnitude = Doublet<High.Magnitude>
    
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
    
    @inlinable public init(low: High.Magnitude, high: High) {
        self.low  = low
        self.high = high
    }
    
    @inlinable public init(high: High, low: High.Magnitude) {
        self.high = high
        self.low  = low
    }
    
    @inlinable public init(ascending  components: (low: High.Magnitude, high: High)) {
        self.init(low: components.low, high: components.high)
    }
    
    @inlinable public init(descending components: (high: High, low: High.Magnitude)) {
        self.init(high: components.high, low: components.low)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var ascending:  (low: High.Magnitude, high: High) {
        consuming get {
            (low: self.low, high: self.high)
        }
        
        consuming set {
            (low: self.low, high: self.high) = newValue
        }
    }
    
    @inlinable public var descending: (high: High, low: High.Magnitude) {
        consuming get {
            (high: self.high, low: self.low)
        }
        
        consuming set {
            (high: self.high, low: self.low) = newValue
        }
    }
}
