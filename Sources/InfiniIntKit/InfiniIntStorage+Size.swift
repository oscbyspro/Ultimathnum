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
// MARK: * Infini Int Storage x Size
//*============================================================================*

extension InfiniIntStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func resize(minCount: IX) {
        guard minCount > self.count else { return }
        
        self.body.reserveCapacity(Int(minCount))
        
        let element = Element(repeating: self.appendix)
        while minCount > self.count {
            self.body.append(element)
        }
    }
}
