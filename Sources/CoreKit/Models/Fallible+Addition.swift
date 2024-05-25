//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible x Addition
//*============================================================================*

extension Fallible where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> Self {
        self.value.negated().veto(self.error)
    }
    
    @inlinable public consuming func plus(_ other: borrowing Value) -> Self {
        self.value.plus(other).veto(self.error)
    }
    
    @inlinable public consuming func minus(_ other: borrowing Value) -> Self {
        self.value.minus(other).veto(self.error)
    }
    
    @inlinable public consuming func plus(_ other: borrowing Fallible<Value>) -> Self {
        self.value.plus(other).veto(self.error)
    }
    
    @inlinable public consuming func minus(_ other: borrowing Fallible<Value>) -> Self {
        self.value.minus(other).veto(self.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Stride by 1
//=----------------------------------------------------------------------------=

extension Fallible where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the next value in arithmetic progression.
    @inlinable public consuming func incremented() -> Fallible<Value> {
        self.plus(true)
    }
    
    /// Returns the previous value in arithmetic progression.
    @inlinable public consuming func decremented() -> Fallible<Value> {
        self.minus(true)
    }
    
    /// Returns the result of `self + other`.
    @inlinable public consuming func plus(_ other: Bool) -> Fallible<Value> {
        self.value.plus(other).veto(self.error)
    }
    
    /// Returns the result of `self - other`.
    @inlinable public consuming func minus(_ other: Bool) -> Fallible<Value> {
        self.value.minus(other).veto(self.error)
    }
}
