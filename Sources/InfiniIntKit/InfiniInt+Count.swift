//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Infini Int x Count
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inline(never) @inlinable public func count(_ selection: Bit) -> Magnitude {
        var count = Magnitude()
        let contrast = self.appendix.toggled()
        
        self.withUnsafeBinaryIntegerBody {
            var small: IX = $0.count(contrast)
            
            if  contrast != selection {
                small.toggle()
            }
            
            count = Magnitude(load: small as IX)
        }
        
        return count as Magnitude
    }
    
    @inline(never) @inlinable public func ascending(_ bit: Bit) -> Magnitude {
        let match = self.appendix == bit
        var count = Magnitude.size
        
        self.withUnsafeBinaryIntegerBody {
            let ascending = $0.ascending(bit)
            let maximum = match && ascending == $0.size()
            if !maximum {
                count = Magnitude(load: ascending)
            }
        }
        
        return count as Magnitude
    }
    
    @inline(never) @inlinable public func descending(_ bit: Bit) -> Magnitude {
        let match = self.appendix == bit
        var count = Magnitude(repeating: Bit(match))
                
        if  match {
            self.withUnsafeBinaryIntegerBody {
                count = count.minus(Magnitude(load: $0.nondescending(bit))).unchecked()
            }
        }
        
        return count as Magnitude
    }
}
