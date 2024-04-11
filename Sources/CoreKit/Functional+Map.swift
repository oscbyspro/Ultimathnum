//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Functional x Map
//*============================================================================*

extension Functional {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func map<T>(_ map: (Self) throws -> T) rethrows -> T {
        try map(self)
    }
    
    @inlinable public consuming func map<T>(_ map: (Self) throws -> Fallible<T>) rethrows -> Fallible<T> {
        try map(self)
    }
    
    @inlinable public consuming func map<T, U>(_ input: borrowing U, map: (Self, U) throws -> T) rethrows -> T {
        try map(self, input)
    }
    
    @inlinable public consuming func map<T, U>(_ input: borrowing U, map: (Self, U) throws -> Fallible<T>) rethrows -> Fallible<T> {
        try map(self, input)
    }
}
