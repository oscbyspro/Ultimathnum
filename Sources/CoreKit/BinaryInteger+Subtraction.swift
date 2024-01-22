//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Subtraction
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func -(instance: Self) -> Self {
        try! instance.negated()
    }
    
    @inlinable public static func -(lhs: Self, rhs: Self) -> Self {
        try! lhs.minus(rhs)
    }
    
    /// ### Development
    ///
    /// - FIXME: Consuming caues bad accesss (2024-01-13, Swift 5.9).
    ///
    @inlinable public static func &-(lhs: Self, rhs: Self) -> Self {
        Overflow.ignore({ try lhs.minus(rhs) })
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Stride by 1
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// The previous value in arithmetic progression.
    ///
    /// - Note: It works with **0-bit** and **1-bit** integers.
    ///
    @inlinable public consuming func decremented() throws -> Self {
        if  let positive = try? Self(literally:  1) {
            return try (consume self).minus(positive)
        }
        
        if  let negative = try? Self(literally: -1) {
            return try (consume self).plus (negative)
        }
        
        throw Overflow (consume self) // must be zero
    }
}
