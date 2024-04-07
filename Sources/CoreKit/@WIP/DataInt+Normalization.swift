//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Normalization
//*============================================================================*

extension DataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func normalized() -> Self {
        self.normalized(downTo: 0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Private
    //=------------------------------------------------------------------------=
    
    @inlinable internal consuming func normalized(downTo limit: IX) -> Self {
        let appendix = Element(repeating: self.appendix)
        
        trimming: while self.count > limit {
            let lastIndex = self.count - 1
            guard self[unchecked: lastIndex] == appendix else { break }
            self.storage.count =  lastIndex
        }
        
        return self as Self as Self as Self as Self
    }
}
