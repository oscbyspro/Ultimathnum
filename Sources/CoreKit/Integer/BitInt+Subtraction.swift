//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Int x Subtraction x Signed
//*============================================================================*

extension BitInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func negated() throws -> Self {
        try Overflow.resolve(self, overflow: self != 0)
    }
    
    @inlinable public func minus( _ decrement: Self) throws -> Self {
        try Overflow.resolve(self ^ decrement, overflow: self > decrement)
    }
}

//*============================================================================*
// MARK: * Bit Int x Subtraction x Unsigned
//*============================================================================*

extension BitInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func negated() throws -> Self {
        try Overflow.resolve(self, overflow: self != 0)
    }
    
    @inlinable public func minus( _ decrement: Self) throws -> Self {
        try Overflow.resolve(self ^ decrement, overflow: self < decrement)
    }
}
