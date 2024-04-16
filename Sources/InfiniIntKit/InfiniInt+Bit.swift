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
        self.withUnsafeMutableBinaryIntegerBody {
            $0.toggle(carrying: &increment)
        }
        
        self.storage.appendix.toggle()
        
        // TODO: await ownership fixes
        if  copy increment {
            if  Bool(self.appendix) {
                self.storage.appendix.toggle()
                self.storage.normalize()
            }   else {
                self.storage.body.append(1)
                increment.toggle()
            }
        }
        
        return self.combine(!Self.isSigned && increment)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func count(_ bit: consuming Bit, where selection: BitSelection) -> Magnitude {
        var count = Magnitude()
        
        switch selection {
        case BitSelection.anywhere:
            let contrast = self.appendix.toggled()
            self.storage.withUnsafeBinaryIntegerBody {
                for index in $0.indices {
                    let subcount = $0[unchecked: index].count(contrast, where: selection)
                    count = count.plus(subcount).assert()
                }
                
                if  contrast != bit {
                    count.toggle()
                }
            }
            
        case BitSelection.ascending:
            self.storage.withUnsafeBinaryIntegerBody {
                var index = IX.zero
                
                while index < $0.count {
                    let subcount = $0[unchecked: index].count(bit, where: selection)
                    count = count.plus(subcount).assert()
                    guard subcount == Element.size else { break }
                    index = index.incremented( ).assert()
                }
                
                if  self.appendix == bit, index != 0 {
                    count.storage.appendix = Bit.one
                    count.storage.normalize()
                }
            }
            
        case BitSelection.descending:
            if  self.appendix == bit {
                self.storage.withUnsafeBinaryIntegerBody {
                    for index in $0.indices.reversed() {
                        let subcount = $0[unchecked: index].count(bit, where: selection)
                        count = count.plus(subcount).assert()
                        guard subcount == Element.size else { break }
                    }
                }
            }
        }
        
        return count as Magnitude
    }
}
