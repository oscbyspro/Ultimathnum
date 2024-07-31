//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible x Exponentiation
//*============================================================================*

extension Fallible where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `power` and `error` of `self` raised to `exponent`.
    ///
    /// ```swift
    /// U8(1).power(Natural(2)) // value: 001, error: false
    /// U8(2).power(Natural(3)) // value: 008, error: false
    /// U8(3).power(Natural(5)) // value: 243, error: false
    /// U8(5).power(Natural(7)) // value: 045, error: true
    /// U8.exactly(00000078125) // value: 045, error: true
    /// ```
    ///
    /// - Note: Unsigned systems integers are always natural.
    ///
    @inlinable public borrowing func power(_ exponent: /* borrowing */ Natural<Value>) -> Fallible<Value> {
        self.value.power(exponent).veto(self.error)
    }
}

//*============================================================================*
// MARK: * Fallible x Exponentiation x Natural
//*============================================================================*

extension Fallible where Value: SystemsInteger & UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `power` and `error` of `self` raised to `exponent`.
    ///
    /// ```swift
    /// U8(1).power(Natural(2)) // value: 001, error: false
    /// U8(2).power(Natural(3)) // value: 008, error: false
    /// U8(3).power(Natural(5)) // value: 243, error: false
    /// U8(5).power(Natural(7)) // value: 045, error: true
    /// U8.exactly(00000078125) // value: 045, error: true
    /// ```
    ///
    /// - Note: Unsigned systems integers are always natural.
    ///
    @inlinable public borrowing func power(_ exponent: /* borrowing */ Value) -> Fallible<Value> {
        self.value.power(exponent).veto(self.error)
    }
    
    /// Returns the `power` and `error` of `self` raised to `exponent`.
    ///
    /// ```swift
    /// U8(1).power(Natural(2)) // value: 001, error: false
    /// U8(2).power(Natural(3)) // value: 008, error: false
    /// U8(3).power(Natural(5)) // value: 243, error: false
    /// U8(5).power(Natural(7)) // value: 045, error: true
    /// U8.exactly(00000078125) // value: 045, error: true
    /// ```
    ///
    /// - Note: Unsigned systems integers are always natural.
    ///
    @inlinable public borrowing func power(_ exponent: /* borrowing */ Fallible<Value>) -> Fallible<Value> {
        self.power(exponent.value).veto(exponent.error)
    }
}
