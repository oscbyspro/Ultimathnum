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
    
    @inlinable public consuming func map<T, E>(_ map: (Value) throws(E) -> T) throws(E) -> Fallible<T> {
        Fallible<T>(try map(self.value), error: self.error)
    }
    
    @inlinable public consuming func map<T, E>(_ map: (Value) throws(E) -> Fallible<T>) throws(E) -> Fallible<T> {
        try map(self.value).veto(self.error)
    }
}
