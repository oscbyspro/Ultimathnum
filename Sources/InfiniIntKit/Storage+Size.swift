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
    
    @inlinable internal mutating func resize(_ count: IX) {
        self.resize(minCount: count)
        self.resize(maxCount: count)
    }
    
    @inlinable internal mutating func resize(minCount: IX) {
        if minCount <= self.count { return }
        
        self.body.reserveCapacity(Int(minCount))
        
        let element = Element(repeating: self.appendix)
        
        while minCount > self.count {
            self.body.append(element)
        }
    }
    
    @inlinable internal mutating func resize(maxCount: IX) {
        Swift.assert(maxCount >= 0, String.brokenInvariant())
        
        if maxCount >= self.count { return }
        
        self.body.removeSubrange(Int(maxCount)...)
    }
}
