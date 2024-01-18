//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Int x Multiplication x Signed
//*============================================================================*

extension BitInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func squared() throws -> Self {
        try Overflow.resolve(copy self, overflow: self == -1)
    }
    
    @inlinable public consuming func times(_ multiplier: borrowing Self) throws -> Self {
        try Overflow.resolve(copy self & multiplier, overflow: self & multiplier == -1)
    }
    
    @inlinable public static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> Doublet<Self> {
        Doublet(low: Magnitude(bitPattern: multiplicand & multiplier), high: 0)
    }
}

//*============================================================================*
// MARK: * Bit Int x Multiplication x Unsigned
//*============================================================================*

extension BitInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func squared() throws -> Self {
        try Overflow.resolve(self, overflow: false)
    }
    
    @inlinable public consuming func times(_ multiplier: borrowing Self) throws -> Self {
        try Overflow.resolve(self & multiplier, overflow: false)
    }
    
    @inlinable public static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> Doublet<Self> {
        Doublet(low: Magnitude(bitPattern: multiplicand & multiplier), high: 0)
    }
}
