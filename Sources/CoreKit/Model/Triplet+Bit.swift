//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Triplet x Bit
//*============================================================================*

extension Triplet {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Triplet<Base.Magnitude>) {
        self.init(
            low:  bitPattern.low,
            mid:  bitPattern.mid,
            high: Base(bitPattern: bitPattern.high)
        )
    }
    
    @inlinable public var bitPattern: Triplet<Base.Magnitude> {
        consuming get {
            Triplet<Base.Magnitude>(
                low:  self.low,
                mid:  self.mid,
                high: Base.Magnitude(bitPattern: self.high)
            )
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func complement() -> Self {
        self.complement(true).value
    }
    
    @inlinable public consuming func complement(_ increment: consuming Bool) -> Fallible<Self> {
        increment = self.low [{
            $0.complement(increment)
        }]
        
        increment = self.mid [{
            $0.complement(increment)
        }]
        
        increment = self.high[{ 
            $0.complement(increment)
        }]
        
        return self.combine(increment)
    }
    
    @inlinable public consuming func magnitude() -> Magnitude {
        Magnitude(bitPattern: self.high.isLessThanZero ? self.complement() : self)
    }
}
