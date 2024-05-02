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
    
    @inlinable public func count(_ bit: Bit, where selection: Bit.Anywhere<Self>.Type) -> Magnitude {
        var count = Magnitude()
        
        let contrast = self.appendix.toggled()
        self.storage.withUnsafeBinaryIntegerBody {
            count = Magnitude(load: $0.count(.anywhere(contrast)))
            if  contrast != bit {
                count.toggle()
            }
        }
        
        return count as Magnitude
    }
    
    @inlinable public func count(_ bit: Bit, where selection: Bit.Ascending<Self>.Type) -> Magnitude {
        var count = Magnitude()
        
        let bitIsAppendix = self.appendix == bit
        self.storage.withUnsafeBinaryIntegerBody {
            let ascending =  $0.count(.ascending(bit))
            if  ascending == $0.size(), bitIsAppendix {
                count = Magnitude.size
            }   else {
                count = Magnitude(load: ascending)
            }
        }
        
        return count as Magnitude
    }
    
    @inlinable public func count(_ bit: Bit, where selection: Bit.Descending<Self>.Type) -> Magnitude {
        var count = Magnitude()
        
        if  self.appendix == bit {
            self.withUnsafeBinaryIntegerBody {
                count = Self.size - Magnitude(load: $0.count(.nondescending(bit)))
            }
        }
        
        return count as Magnitude
    }
}
