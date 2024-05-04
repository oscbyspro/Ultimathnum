//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible x Map
//*============================================================================*

extension Fallible {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func map<T>(_ map: (Value) throws -> T) rethrows -> Fallible<T> {
        Fallible<T>(try map(self.value), error: self.error)
    }
    
    @inlinable public consuming func map<T>(_ map: (Value) throws -> Fallible<T>) rethrows -> Fallible<T> {
        try map(self.value).veto(self.error)
    }
}
