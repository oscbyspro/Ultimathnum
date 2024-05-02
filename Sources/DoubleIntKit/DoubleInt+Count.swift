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
    
    @inlinable public func count(_ bit: Bit, where selection: Bit.Anywhere<Self>.Type) -> Magnitude {
        var count: UX

        count  = UX(load: self.storage.low .count(.anywhere(bit)))
        count += UX(load: self.storage.high.count(.anywhere(bit)))
        
        return Magnitude(load: count)
    }
    
    @inlinable public func count(_ bit: Bit, where selection: Bit.Ascending<Self>.Type) -> Magnitude {
        var count: UX

        always: do {
            count  = UX(load: self.storage.low .count(.ascending(bit)))
            guard count == UX(size: Base.self) else { break always }
            count += UX(load: self.storage.high.count(.ascending(bit)))
        }
        
        return Magnitude(load: count)
    }
    
    @inlinable public func count(_ bit: Bit, where selection: Bit.Descending<Self>.Type) -> Magnitude {
        var count: UX

        always: do {
            count  = UX(load: self.storage.high.count(.descending(bit)))
            guard count == UX(size: Base.self) else { break always }
            count += UX(load: self.storage.low .count(.descending(bit)))
        }
        
        return Magnitude(load: count)
    }
}
