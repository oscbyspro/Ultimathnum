//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Collection
//*============================================================================*

extension BidirectionalCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Drop While
    //=------------------------------------------------------------------------=
    
    /// Drops elements that satisfy the predicate from the end of the given `collection`.
    @inlinable package func dropLast(while predicate: (Element) -> Bool) -> SubSequence {
        var lastIndex = self.endIndex
        
        backwards: while lastIndex > self.startIndex {
            let nextLastIndex = self.index(before: lastIndex)
            guard predicate(self[nextLastIndex]) else { break }
            lastIndex = nextLastIndex
        }
        
        return self.prefix(upTo: lastIndex)
    }
}
