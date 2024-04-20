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
// MARK: * Data Int x Bit x Body
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func size() -> IX {
        let count = self.count.times(IX(size: Element.self))
        return count.unwrap("binary integer body may store at most IX.max bits per protocol")
    }
    
    @inlinable public borrowing func count(_ bit: Bit, where selection: BitSelection) -> IX {
        var count = Fallible(IX.zero, error: false)
        
        switch selection {
        case BitSelection.anywhere:
            
            for index in self.indices {
                let subcount = self[unchecked: index].count(bit, where: selection)
                count = count.plus(IX(load: subcount))
            }
            
        case BitSelection.ascending:
            
            for index in self.indices {
                let subcount = self[unchecked: index].count(bit, where: selection)
                count = count.plus(IX(load: subcount))
                guard subcount == Element.size else { break }
            }
            
        case BitSelection.descending:
            
            for index in self.indices.reversed() {
                let subcount = self[unchecked: index].count(bit, where: selection)
                count = count.plus(IX(load: subcount))
                guard subcount == Element.size else { break }
            }
        }
        
        return count.unwrap("binary integer body may store at most IX.max bits per protocol")
    }
}

