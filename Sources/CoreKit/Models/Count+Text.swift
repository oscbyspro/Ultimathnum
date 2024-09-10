//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Count x Text
//*============================================================================*

extension Count {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        if !self.base.isNegative {
            return self.base.description
        }
        
        var description = "log2(&0+1)"
        let incremented = self.base.incremented().value
        
        if !incremented.isZero {
            description.append(incremented.description)
        }
        
        return description
    }
}
