//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Partition x Read
//*============================================================================*

extension DataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func normalized() -> Self {
        Self(self.body.normalized(repeating: self.appendix), repeating: self.appendix)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(range: PartialRangeFrom<UX>) -> Self {
        consuming get {
            let start = Swift.min(range.lowerBound, UX(raw: self.body.count))
            return Self(self.body[unchecked: IX(raw: start)...], repeating: self.appendix)
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Partition x Read|Write
//*============================================================================*

extension MutableDataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func normalized() -> Self {
        Self(mutating: Immutable(self).normalized())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(range: PartialRangeFrom<UX>) -> Self {
        consuming get {
            Self(mutating: Immutable(self)[range])
        }
    }
}

//*============================================================================*
// MARK: * Data Integer x Partition x Read|Body
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func normalized(repeating appendix: Bit = .zero) -> Self {
        let appendix = Element(repeating: appendix)
        var endIndex = self.count
        
        while endIndex > 0 {
            let lastIndex = endIndex.minus(1).unchecked()
            guard self[unchecked: lastIndex] == appendix else { break }
            endIndex = lastIndex
        }
        
        return Self(self.start, count: endIndex)
    }
    
    @inlinable public consuming func split(unchecked index: IX) -> (low: Self, high: Self) {
        //=--------------------------------------=
        Swift.assert(index >= 0000000000, String.indexOutOfBounds())
        Swift.assert(index <= self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        return (low: (copy self)[unchecked: ..<index], high: (consume self)[unchecked: index...])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(unchecked range: Range<IX>) -> Self {
        consuming get {
            //=----------------------------------=
            Swift.assert(range.lowerBound >= 0000000000, String.indexOutOfBounds())
            Swift.assert(range.upperBound <= self.count, String.indexOutOfBounds())
            //=----------------------------------=
            let start = self.start.advanced(by: Int(range.lowerBound))
            return Self(start, count: IX(range.count))
        }
    }
    
    @inlinable public subscript(unchecked range: PartialRangeFrom<IX>) -> Self {
        consuming get {
            //=----------------------------------=
            Swift.assert(range.lowerBound >= 0000000000, String.indexOutOfBounds())
            Swift.assert(range.lowerBound <= self.count, String.indexOutOfBounds())
            //=----------------------------------=
            let start = self.start.advanced(by: Int(range.lowerBound))
            let count = self.count.minus(range.lowerBound).unchecked()
            return Self(start, count: count)
        }
    }
    
    @inlinable public subscript(unchecked range: PartialRangeUpTo<IX>) -> Self {
        consuming get {
            //=----------------------------------=
            Swift.assert(range.upperBound >= 0000000000, String.indexOutOfBounds())
            Swift.assert(range.upperBound <= self.count, String.indexOutOfBounds())
            //=----------------------------------=
            return Self(self.start, count: range.upperBound)
        }
    }
}

//*============================================================================*
// MARK: * Data Integer x Partition x Read|Write|Body
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func normalized(repeating appendix: Bit = .zero) -> Self {
        Self(mutating: Immutable(self).normalized(repeating: appendix))
    }
    
    @inlinable public consuming func split(unchecked index: IX) -> (low: Self, high: Self) {
        let (low, high) = Immutable(self).split(unchecked: index)
        return (low: Self(mutating: low), high: Self(mutating: high))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(unchecked range: Range<IX>) -> Self {
        consuming get {
            Self(mutating: Immutable(self)[unchecked: range])
        }
    }
    
    @inlinable public subscript(unchecked range: PartialRangeFrom<IX>) -> Self {
        consuming get {
            Self(mutating: Immutable(self)[unchecked: range])
        }
    }
    
    @inlinable public subscript(unchecked range: PartialRangeUpTo<IX>) -> Self {
        consuming get {
            Self(mutating: Immutable(self)[unchecked: range])
        }
    }
}
