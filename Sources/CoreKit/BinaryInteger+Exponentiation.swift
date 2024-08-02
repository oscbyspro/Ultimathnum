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
    /// Use exactly `1` type of `exponent` per type of `Self`.
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
    /// U8(1).power(Natural(2)) // value: 001, error: false
    /// U8(2).power(Natural(3)) // value: 008, error: false
    /// U8(3).power(Natural(5)) // value: 243, error: false
    /// U8(5).power(Natural(7)) // value: 045, error: true 
    /// U8.exactly((000078125)) // value: 045, error: true
    /// ```
    ///
    /// - Note: Unsigned systems integers are always natural.
    ///
    @inlinable public borrowing func power(_ exponent: borrowing Natural<Self>) -> Fallible<Self> {
        if !Self.isArbitrary {
            return Self.raise(self, to: exponent)
            
        }   else {
            //  note: the allocation limit is IX.max
            //  note: preserves the lsb to toggle ~0
            var magic = UX(clamping: exponent.value)
            magic  &= UX(00000001).toggled()
            magic  |= UX(exponent.value.lsb)
            return Self.raise(self, to: Natural(unchecked: magic))
        }
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
    /// U8(1).power(Natural(2)) // value: 001, error: false
    /// U8(2).power(Natural(3)) // value: 008, error: false
    /// U8(3).power(Natural(5)) // value: 243, error: false
    /// U8(5).power(Natural(7)) // value: 045, error: true
    /// U8.exactly((000078125)) // value: 045, error: true
    /// ```
    ///
    /// - Note: Unsigned systems integers are always natural.
    ///
    @inlinable public borrowing func power(_ exponent: /* borrowing */ Natural<Value>) -> Fallible<Value> {
        self.value.power(exponent).veto(self.error)
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
    /// U8.exactly((000078125)) // value: 045, error: true
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
    /// U8.exactly((000078125)) // value: 045, error: true
    /// ```
    ///
    /// - Note: Unsigned systems integers are always natural.
    ///
    @inlinable public borrowing func power(_ exponent: /* borrowing */ Fallible<Self>) -> Fallible<Self> {
        self.power(exponent.value).veto(exponent.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

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
    /// U8.exactly((000078125)) // value: 045, error: true
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
    /// U8.exactly((000078125)) // value: 045, error: true
    /// ```
    ///
    /// - Note: Unsigned systems integers are always natural.
    ///
    @inlinable public borrowing func power(_ exponent: /* borrowing */ Fallible<Value>) -> Fallible<Value> {
        self.power(exponent.value).veto(exponent.error)
    }
}
