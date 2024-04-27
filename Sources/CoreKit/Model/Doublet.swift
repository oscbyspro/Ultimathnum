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
@frozen public struct Doublet<Base>: Functional, BitCastable, Comparable where Base: SystemsInteger {
    
    public typealias High = Base
    
    public typealias Low  = Base.Magnitude
    
    public typealias Magnitude = Doublet<Base.Magnitude>
    
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
    
    @inlinable public init(low: consuming Base.Magnitude, high: consuming Base) {
        self.low  = low
        self.high = high
    }
    
    @inlinable public init(high: consuming Base, low: consuming Base.Magnitude) {
        self.high = high
        self.low  = low
    }
}
