//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Triplet x Numbers
//*============================================================================*

extension Triplet {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var complement: Self {
        consuming get {
            var overflow = true
            (self.low,  overflow) = (~self.low ).plus(Low (Bit(bitPattern: overflow))).components
            (self.mid,  overflow) = (~self.mid ).plus(Mid (Bit(bitPattern: overflow))).components
            (self.high, overflow) = (~self.high).plus(High(Bit(bitPattern: overflow))).components
            return self
        }
    }
    
    @inlinable public var magnitude: Magnitude {
        consuming get {
            
            if  self.high.isLessThanZero {
                self = self.complement
            }
            
            return Magnitude(bitPattern: self)
        }
    }
}
