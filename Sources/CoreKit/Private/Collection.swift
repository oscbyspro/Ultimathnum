//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Collection
//*============================================================================*

package extension BidirectionalCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Drops elements that satisfy the predicate from the end of the given `collection`.
    @inlinable func dropLast(while predicate: (Element) -> Bool) -> SubSequence {
        var subsequenceEndIndex = self.endIndex
        
        backwards: while subsequenceEndIndex > self.startIndex {
            let subsequenceLastIndex = self.index(before: subsequenceEndIndex)
            guard predicate(self[subsequenceLastIndex]) else { break }
            subsequenceEndIndex = subsequenceLastIndex
        }
        
        return self.prefix(upTo: subsequenceEndIndex)
    }
}
