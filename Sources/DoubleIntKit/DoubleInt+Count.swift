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
// MARK: * Double Int x Count
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func count(_ bit: Bit) -> Count {
        var count: IX

        count   = IX(raw: self.storage.low .count(bit))
        count &+= IX(raw: self.storage.high.count(bit))
        
        return Count(unchecked: count)
    }
    
    @inlinable public borrowing func ascending(_ bit: Bit) -> Count {
        var count: IX

        scope: do {
            count   = IX(raw: self.storage.low .ascending(bit))
            guard count == IX(size: Base.self) else { break scope }
            count &+= IX(raw: self.storage.high.ascending(bit))
        }
        
        return Count(unchecked: count)
    }
    
    @inlinable public borrowing func descending(_ bit: Bit) -> Count {
        var count: IX

        scope: do {
            count   = IX(raw: self.storage.high.descending(bit))
            guard count == IX(size: Base.self) else { break scope }
            count &+= IX(raw: self.storage.low .descending(bit))
        }
        
        return Count(unchecked: count)
    }
}
