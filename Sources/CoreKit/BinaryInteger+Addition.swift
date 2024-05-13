//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Addition
//*============================================================================*

extension BinaryInteger {
 
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func +(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.plus(rhs).unwrap()
    }
    
    @inlinable public static func &+(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.plus(rhs).value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    @inlinable public static func +=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs + rhs
    }
    
    @inlinable public static func &+=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs &+ rhs
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Fallible
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: borrowing Fallible<Self>) -> Fallible<Self> {
        self.plus(increment.value).veto(increment.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Stride by 1
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// The next value in arithmetic progression.
    @inlinable public consuming func incremented(_ condition: consuming Bool = true) -> Fallible<Self> {
        switch Self.isSigned {
        case true : self.minus(Self(repeating: Bit(condition)))
        case false: self.plus (Self(/*------*/ Bit(condition)))
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Addition x Systems
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    /// Returns the result of `self` + (`other` + `bit`).
    ///
    /// ```
    /// min: +(low:  0, high: 0)
    /// max: +(low: ~0, high: 1)
    /// ```
    ///
    @inlinable public consuming func plus(_ other: borrowing Self, plus bit: Bool) -> Fallible<Self> {
        let a: Bool, b: Bool
        
        (self, a) = self.plus(other).components()
        (self, b) = self.plus(Self(Bit(bit))).components()
        
        return self.veto(a != b)
    }
}
