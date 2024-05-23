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
        self.storage.withUnsafeBinaryIntegerBody {
            count = Magnitude(load: $0.count(contrast))
            if  contrast != selection {
                count.toggle()
            }
        }
        
        return count as Magnitude
    }
    
    @inline(never) @inlinable public func count(_ selection: Bit.Ascending) -> Magnitude {
        let match = self.appendix == selection.bit
        var count = Magnitude()
        
        self.storage.withUnsafeBinaryIntegerBody {
            let ascending =  $0.count(selection)
            if  ascending == $0.size(), match {
                count = Magnitude.size
            }   else {
                count = Magnitude(load: ascending)
            }
        }
        
        return count as Magnitude
    }
    
    @inline(never) @inlinable public func count(_ selection: Bit.Descending) -> Magnitude {
        let match = self.appendix == selection.bit
        var count = Magnitude(repeating: Bit(match))
                
        if  match {
            self.withUnsafeBinaryIntegerBody {
                count -= Magnitude(load: $0.count(.nondescending(selection.bit)))
            }
        }
        
        return count as Magnitude
    }
}
