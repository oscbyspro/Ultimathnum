//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Integer x Sub Sequence
//*============================================================================*

extension DataInteger {
    
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
// MARK: * Data Integer x Sub Sequence x Body
//*============================================================================*

extension BodyInteger {
    
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
    
    /// ### Development
    ///
    /// - TODO: Consider a `Doublet<Self>` return type.
    ///
    @inlinable public consuming func split(at index: IX) -> (low: Self, high: Self) {
        //=--------------------------------------=
        Swift.assert(index >= 0000000000, String.indexOutOfBounds())
        Swift.assert(index <= self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        return (low: (copy self)[unchecked: ..<index], high: (consume self)[unchecked: index...])
    }
}
