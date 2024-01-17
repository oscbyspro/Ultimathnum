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

extension BidirectionalCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Drops elements that satisfy the predicate from the end of the given `collection`.
    @inlinable package func dropLast(while predicate: (Element) -> Bool) -> SubSequence {
        var nextEndIndex = self.endIndex
        
        backwards: while nextEndIndex > self.startIndex {
            let nextLastIndex = self.index(before: nextEndIndex)
            guard predicate(self[nextLastIndex]) else { break }
            nextEndIndex = nextLastIndex
        }
        
        return self.prefix(upTo: nextEndIndex)
    }
}
