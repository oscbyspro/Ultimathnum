//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Full Width
//*============================================================================*

@frozen public struct FullWidth<High, Low> {
    
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
}
