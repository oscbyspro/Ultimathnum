//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Sequence x Normalization
//*============================================================================*

extension BitSequence {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func normalized() throws -> Prefix<Self> {
        var count = self.base.normalized().body.count
                
        if  let index = UX(bitPattern: count).minus(1).optional() {
            let major = try index.times(8).get()
            let minor = UX(load: self.base[index].count(.nonappendix))
            count = try major.plus(minor).map(IX.exactly).get()
        }
        
        return self.prefix(count) as Prefix<Self>
    }
}
