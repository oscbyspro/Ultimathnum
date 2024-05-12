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
    
    @inlinable public subscript(unchecked range: PartialRangeFrom<IX>) -> Self {
        consuming get {
            //=----------------------------------=
            Swift.assert(range.lowerBound >= 0000000000, String.indexOutOfBounds())
            Swift.assert(range.lowerBound <= self.count, String.indexOutOfBounds())
            //=----------------------------------=
            let start = self.start.advanced(by: Int(range.lowerBound))
            let count = self.count.minus(range.lowerBound).assert()
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
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func split(at index: IX) -> (low: Self, high: Self) {
        //=--------------------------------------=
        Swift.assert(index >= 0000000000, String.indexOutOfBounds())
        Swift.assert(index <= self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        return (low: (copy self)[unchecked: ..<index], high: (consume self)[unchecked: index...])
    }
}

//*============================================================================*
// MARK: * Data Integer x Partition x Read|Write|Body
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
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
    
    @inlinable public subscript(unchecked range: Range<IX>) -> Self {
        consuming get {
            Self(mutating: Immutable(self)[unchecked: range])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func split(at index: IX) -> (low: Self, high: Self) {
        let (low, high) = Immutable(self).split(at: index)
        return (low: Self(mutating: low), high: Self(mutating: high))
    }
}
