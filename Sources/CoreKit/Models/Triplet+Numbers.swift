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
            var error = true
            (self.low,  error) = (~self.low ).incremented(error).components
            (self.mid,  error) = (~self.mid ).incremented(error).components
            (self.high, error) = (~self.high).incremented(error).components
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
