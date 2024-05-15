//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Normalization x Read
//*============================================================================*

extension DataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func normalized() -> Self {
        Self(self.body.normalized(repeating: self.appendix), repeating: self.appendix)
    }
}

//*============================================================================*
// MARK: * Data Int x Normalization x Read|Write
//*============================================================================*

extension MutableDataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func normalized() -> Self {
        Self(mutating: Immutable(self).normalized())
    }
}

//*============================================================================*
// MARK: * Data Integer x Normalization x Read|Body
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
}

//*============================================================================*
// MARK: * Data Integer x Normalization x Read|Write|Body
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func normalized(repeating appendix: Bit = .zero) -> Self {
        Self(mutating: Immutable(self).normalized(repeating: appendix))
    }
}
