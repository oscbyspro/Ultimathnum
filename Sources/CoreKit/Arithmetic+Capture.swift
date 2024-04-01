//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Arithmetic x Capture
//*============================================================================*

extension Arithmetic {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func capture(_ map: (Self) throws -> Self) rethrows {
        self = try map(self)
    }
    
    @inlinable public mutating func capture(_ map: (Self) throws -> Fallible<Self>) rethrows -> Bool {
        let overflow: Bool
        (self, overflow) = try map(self).components
        return overflow
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func capture<T>(_ input: borrowing T, _ map: (Self, T) throws -> Self) rethrows {
        self = try map(self, input)
    }
    
    @inlinable public mutating func capture<T>(_ input: borrowing T, _ map: (Self, T) throws -> Fallible<Self>) rethrows -> Bool {
        let overflow: Bool
        (self, overflow) = try map(self, input).components
        return overflow
    }
}
