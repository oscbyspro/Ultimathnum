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
    
    @inlinable public borrowing func count(_ bit: Bit) -> Magnitude {
        var count: UX

        count  = UX(load: self.storage.low .count(bit))
        count += UX(load: self.storage.high.count(bit))
        
        return Magnitude(load: count)
    }
    
    @inlinable public borrowing func ascending(_ bit: Bit) -> Magnitude {
        var count: UX

        always: do {
            count  = UX(load: self.storage.low .ascending(bit))
            guard count == UX(size: Base.self) else { break always }
            count += UX(load: self.storage.high.ascending(bit))
        }
        
        return Magnitude(load: count)
    }
    
    @inlinable public borrowing func descending(_ bit: Bit) -> Magnitude {
        var count: UX

        always: do {
            count  = UX(load: self.storage.high.descending(bit))
            guard count == UX(size: Base.self) else { break always }
            count += UX(load: self.storage.low .descending(bit))
        }
        
        return Magnitude(load: count)
    }
}
