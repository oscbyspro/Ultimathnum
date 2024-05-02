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
    
    @inlinable public borrowing func count(_ selection: Bit) -> Magnitude {
        var count: UX

        count  = UX(load: self.storage.low .count(selection))
        count += UX(load: self.storage.high.count(selection))
        
        return Magnitude(load: count)
    }
    
    @inlinable public borrowing func count(_ selection: Bit.Ascending) -> Magnitude {
        var count: UX

        always: do {
            count  = UX(load: self.storage.low .count(selection))
            guard count == UX(size: Base.self) else { break always }
            count += UX(load: self.storage.high.count(selection))
        }
        
        return Magnitude(load: count)
    }
    
    @inlinable public borrowing func count(_ selection: Bit.Descending) -> Magnitude {
        var count: UX

        always: do {
            count  = UX(load: self.storage.high.count(selection))
            guard count == UX(size: Base.self) else { break always }
            count += UX(load: self.storage.low .count(selection))
        }
        
        return Magnitude(load: count)
    }
}
