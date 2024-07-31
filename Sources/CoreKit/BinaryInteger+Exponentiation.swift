//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Exponentiation
//*============================================================================*

extension BinaryInteger {
    
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
    @inlinable public borrowing func power(_ exponent: /* borrowing */ Natural<Self>) -> Fallible<Self> {
        Swift.assert(!exponent.value.isNegative)
        Swift.assert(!exponent.value.isInfinite)
        
        var power = Fallible(1 as Self)
        var multiplier = Fallible(copy self)
        var exponent = (copy exponent).value
        
        exponentiation: while true {
            if  Bool(exponent.lsb) {
                power = power.times(multiplier)
            }
            
            exponent = exponent.down(Shift(unchecked: Count(unchecked: 1)))
            if exponent.isZero { break }
            
            multiplier = multiplier.squared()
        }
        
        return power // as Fallible<Self>
    }
}

//*============================================================================*
// MARK: * Binary Integer x Exponentiation x Natural
//*============================================================================*

extension BinaryInteger where Self: SystemsInteger & UnsignedInteger {
    
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
    @inlinable public borrowing func power(_ exponent: /* borrowing */ Self) -> Fallible<Self> {
        self.power(Natural(unchecked: exponent))
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
    @inlinable public borrowing func power(_ exponent: /* borrowing */ Fallible<Self>) -> Fallible<Self> {
        self.power(exponent.value).veto(exponent.error)
    }
}
