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
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Remove Count
    //=------------------------------------------------------------------------=
    
    /// Removes `count` prefixing elements.
    @inlinable package mutating func removePrefix(count: Int) -> Self where Self == SubSequence {
        let index  = self.index(self.startIndex, offsetBy: count)
        let prefix = self.prefix(upTo: index)
        self = self.suffix(from: index)
        return prefix as Self
    }
    
    /// Removes `count` suffixing elements.
    @inlinable package mutating func removeSuffix(count: Int) -> Self where Self == SubSequence {
        let index  = self.index(self.endIndex, offsetBy: -count)
        let suffix = self.suffix(from: index)
        self = self.prefix(upTo: index)
        return suffix as Self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Remove Max Length
    //=------------------------------------------------------------------------=
    
    /// Removes up to `maxLength` prefixing elements.
    @inlinable package mutating func removePrefix(maxLength: Int) -> Self where Self == SubSequence {
        let prefix = self.prefix(maxLength)
        self = self.suffix(from: prefix.endIndex)
        return prefix as Self
    }
    
    /// Removes up to `maxLength` suffixing elements.
    @inlinable package mutating func removeSuffix(maxLength: Int) -> Self where Self == SubSequence {
        let suffix = self.suffix(maxLength)
        self = self.prefix(upTo: suffix.startIndex)
        return suffix as Self
    }
}
