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
        let result = try map(self)
        self = result.value
        return result.error
    }
    
    @inlinable public mutating func capture<Input>(_ input: borrowing Input, map: (Self, Input) throws -> Self) rethrows {
        self = try map(self, input)
    }
    
    @inlinable public mutating func capture<Input>(_ input: borrowing Input, map: (Self, Input) throws -> Fallible<Self>) rethrows -> Bool {
        let result = try map(self, input)
        self = result.value
        return result.error
    }
}
