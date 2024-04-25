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
// MARK: * Infini Int x Bit
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func complement(_ increment: consuming Bool) -> Fallible<Self> {
        self.storage.withUnsafeMutableBinaryIntegerBody {
            increment = $0.toggle(carrying: increment)
        }
        
        if !(copy increment) {
            self.storage.appendix.toggle()
            self.storage.normalize()
        }   else if Bool(self.appendix) {
            increment.toggle()
            self.storage.body.append(1)
            self.storage.appendix.toggle()
        }
        
        Swift.assert(self.storage.isNormal, String.brokenInvariant())
        return self.combine(!Self.isSigned && increment)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func count(_ bit: Bit, where selection: Bit.Selection) -> Magnitude {
        var count = Magnitude()
        
        switch selection {
        case Bit.Selection.anywhere:
            let contrast = self.appendix.toggled()
            self.storage.withUnsafeBinaryIntegerBody {
                count = Magnitude(load: $0.count(contrast, where: selection))
                if  contrast != bit {
                    count.toggle()
                }
            }
            
        case Bit.Selection.ascending:
            let bitIsAppendix = self.appendix == bit
            self.storage.withUnsafeBinaryIntegerBody {
                let ascending =  $0.count(bit,where: selection)                
                if  ascending == $0.count(Bit.self), bitIsAppendix {
                    count = Magnitude.size
                }   else {
                    count = Magnitude(load: ascending)
                }
            }
            
        case Bit.Selection.descending:
            if  self.appendix == bit {
                self.withUnsafeBinaryIntegerBody {
                    count = Self.size - Magnitude(load: $0.count(.nondescending(bit)))
                }
            }
        }
        
        return count as Magnitude
    }
}
