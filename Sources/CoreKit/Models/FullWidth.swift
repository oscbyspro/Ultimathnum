//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Full Width
//*============================================================================*

@frozen public struct FullWidth<High: SystemInteger, Low: SystemInteger & UnsignedInteger>: Equatable {
    
    public typealias Magnitude = FullWidth<High.Magnitude, Low.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    #if _endian(big)
    public var high: High
    public var low:  Low
    #else
    public var low:  Low
    public var high: High
    #endif
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(low: Low, high: High) {
        self.low  = low
        self.high = high
    }
    
    @inlinable public init(high: High, low: Low) {
        self.high = high
        self.low  = low
    }
    
    @inlinable public init(ascending  components: (low: Low, high: High)) {
        self.init(low: components.low, high: components.high)
    }
    
    @inlinable public init(descending components: (high: High, low: Low)) {
        self.init(high: components.high, low: components.low)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var ascending:  (low: Low, high: High) {
        consuming get {
            (low: self.low, high: self.high)
        }
        
        consuming set {
            (low: self.low, high: self.high) = newValue
        }
    }
    
    @inlinable public var descending: (high: High, low: Low) {
        consuming get {
            (high: self.high, low: self.low)
        }
        
        consuming set {
            (high: self.high, low: self.low) = newValue
        }
    }
}

//*============================================================================*
// MARK: * Full Width x Numbers
//*============================================================================*

extension FullWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public var magnitude: Magnitude {
        consuming get { var value = consume self
            
            if  value.high.isLessThanZero {
                var carry:   Bool
                (value.low,  carry) = (~value.low ).incremented(by: 0000000000001).components
                (value.high, carry) = (~value.high).incremented(by: carry ? 1 : 0).components
            }
                        
            return Magnitude(high: High.Magnitude(bitPattern: value.high), low: Low.Magnitude(bitPattern: value.low))
        }
    }
}
