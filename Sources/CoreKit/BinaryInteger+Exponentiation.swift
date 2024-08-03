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
    
    /// ### Development
    ///
    /// Use `1` systems integer `exponent` type per type of `Self`.
    ///
    @inlinable internal static func raise<T>(
        _  instance: borrowing Self,
        to exponent: /* borrowing */ Natural<T>
    ) -> Fallible<Self> {
        
        Swift.assert(!exponent.value.isNegative)
        Swift.assert(!exponent.value.isInfinite)
        
        var power = Fallible(1 as Self)
        var multiplier = Fallible(copy instance)
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
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `power` and `error` of `self` raised to `exponent`.
    ///
    /// ```swift
    /// U8(1).power(2) // value: 001, error: false
    /// U8(2).power(3) // value: 008, error: false
    /// U8(3).power(5) // value: 243, error: false
    /// U8(5).power(7) // value: 045, error: true
    /// ```
    ///
    @inlinable public borrowing func power(_ exponent: /* borrowing */ Magnitude) -> Fallible<Self> {
        if !Self.isArbitrary {
            return Self.raise(self, to: Natural(unchecked: exponent))
            
        }   else {
            var magic = UX(clamping: (((exponent)))) // the allocation limit is IX.max
            ((((magic))))[Shift.min] =  exponent.lsb // preserves the lsb to toggle ~0
            return Self.raise(self, to: Natural(unchecked: magic))
        }
    }
    
    /// Returns the `power` and `error` of `self` raised to `exponent`.
    ///
    /// ```swift
    /// U8(1).power(2) // value: 001, error: false
    /// U8(2).power(3) // value: 008, error: false
    /// U8(3).power(5) // value: 243, error: false
    /// U8(5).power(7) // value: 045, error: true
    /// ```
    ///
    @inlinable public borrowing func power(_ exponent: borrowing Fallible<Magnitude>) -> Fallible<Self> {
        self.power(exponent.value).veto(exponent.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension Fallible where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `power` and `error` of `self` raised to `exponent`.
    ///
    /// ```swift
    /// U8(1).power(2) // value: 001, error: false
    /// U8(2).power(3) // value: 008, error: false
    /// U8(3).power(5) // value: 243, error: false
    /// U8(5).power(7) // value: 045, error: true
    /// ```
    ///
    @inlinable public borrowing func power(_ exponent: borrowing Value.Magnitude) -> Fallible<Value> {
        self.value.power(exponent).veto(self.error)
    }
    
    /// Returns the `power` and `error` of `self` raised to `exponent`.
    ///
    /// ```swift
    /// U8(1).power(2) // value: 001, error: false
    /// U8(2).power(3) // value: 008, error: false
    /// U8(3).power(5) // value: 243, error: false
    /// U8(5).power(7) // value: 045, error: true
    /// ```
    ///
    @inlinable public borrowing func power(_ exponent: borrowing Fallible<Value.Magnitude>) -> Fallible<Value> {
        self.power(exponent.value).veto(exponent.error)
    }
}
