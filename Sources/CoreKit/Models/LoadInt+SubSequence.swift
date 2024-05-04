//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Load Int x Sub Sequence
//*============================================================================*

extension LoadInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func successor() -> Self {
        (consume self)[bytes: Self.ratio...]
    }
    
    @inlinable public subscript(bytes range: PartialRangeFrom<UX>) -> Self {
        consuming get {
            Self(self.data[range.lowerBound...])
        }
    }
}
