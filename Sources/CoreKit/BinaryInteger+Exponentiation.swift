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
    ///     Magnitude.size < UX.size: UX or
    ///     Magnitude.size ≤ IX.max.: Magnitude
    ///     Magnitude.size > IX.max.: UX
    ///
    /// - Note: The nonzero `coefficient` simplifies `error` reporting.
    ///
    @inlinable internal static func resolve(
        base: borrowing Self,
        power exponent: consuming  Natural<some UnsignedInteger>,
        coefficient: /*borrowing*/ Nonzero<Self>
    ) -> Fallible<Self> {
        
        Swift.assert(!exponent.value.isNegative)
        Swift.assert(!exponent.value.isInfinite)
        Swift.assert(!coefficient.value.isZero)
        
        var power = Fallible((copy coefficient).value)
        var multiplier = Fallible(copy base)
        var exponent = exponent.value
        
        exponentiation: while true {
            if  Bool(exponent.lsb) {
                power = power.times(multiplier.value)
            }
            
            exponent = exponent.down(Shift.one)
            
            if  exponent.isZero {
                return (power).veto(multiplier.error)
            }
            
            multiplier = multiplier.squared()
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns a `power` and an `error` indiactor.
    ///
    /// - Returns: `pow(self, exponent) * coefficient`
    ///
    /// ```swift
    /// U8(0).power(0, coefficient:  0) // value:   0, error: false
    /// U8(0).power(0, coefficient:  1) // value:   1, error: false
    /// U8(0).power(1, coefficient:  2) // value:   0, error: false
    /// U8(1).power(2, coefficient:  3) // value:   3, error: false
    /// U8(2).power(3, coefficient:  5) // value:  40, error: false
    /// U8(3).power(5, coefficient:  7) // value: 165, error: true
    /// U8(5).power(7, coefficient: 11) // value: 239, error: true
    /// ```
    ///
    /// - Note: The default `coefficient` is `1`.
    ///
    @inlinable public /*borrowing*/ func power(
        _  exponent: some UnsignedInteger,
        coefficient: borrowing Nonzero<Self>
    ) -> Fallible<Self> {
        
        if !Magnitude.isArbitrary {
            var (magic, error) = Magnitude.exactly(exponent).components()
            if  (error) {                
                switch Bool(self.lsb) {
                case  true: error = self.magnitude() > 1 //........ cycle
                case false: return  Self.zero.veto(!self.isZero) // zeros
                }
            }
            
            return Self.resolve(base: self, power: Natural(unchecked: magic), coefficient: coefficient).veto(error)
        }   else {
            var (magic) = UX(clamping:(((exponent)))) // the allocation limit is IX.max
            (((((magic)))))[Shift.min] = exponent.lsb // preserves the lsb to toggle ~0
            return Self.resolve(base: self, power: Natural(unchecked: magic), coefficient: coefficient)
        }
    }
    
    /// Returns a `power` and an `error` indiactor.
    ///
    /// - Returns: `pow(self, exponent) * coefficient`
    ///
    /// ```swift
    /// U8(0).power(0, coefficient:  0) // value:   0, error: false
    /// U8(0).power(0, coefficient:  1) // value:   1, error: false
    /// U8(0).power(1, coefficient:  2) // value:   0, error: false
    /// U8(1).power(2, coefficient:  3) // value:   3, error: false
    /// U8(2).power(3, coefficient:  5) // value:  40, error: false
    /// U8(3).power(5, coefficient:  7) // value: 165, error: true
    /// U8(5).power(7, coefficient: 11) // value: 239, error: true
    /// ```
    ///
    /// - Note: The default `coefficient` is `1`.
    ///
    @inlinable public borrowing func power(
        _  exponent: some UnsignedInteger,
        coefficient: borrowing Self = 1
    ) -> Fallible<Self> {

        if  let coefficient = Nonzero(exactly: copy  coefficient) {
            return self.power(exponent, coefficient: coefficient)
        }   else {
            return Fallible(copy coefficient)
        }
    }
    
    /// Returns a `power` and an `error` indiactor.
    ///
    /// - Returns: `pow(self, exponent) * coefficient`
    ///
    /// ```swift
    /// U8(0).power(0, coefficient:  0) // value:   0, error: false
    /// U8(0).power(0, coefficient:  1) // value:   1, error: false
    /// U8(0).power(1, coefficient:  2) // value:   0, error: false
    /// U8(1).power(2, coefficient:  3) // value:   3, error: false
    /// U8(2).power(3, coefficient:  5) // value:  40, error: false
    /// U8(3).power(5, coefficient:  7) // value: 165, error: true
    /// U8(5).power(7, coefficient: 11) // value: 239, error: true
    /// ```
    ///
    /// - Note: The default `coefficient` is `1`.
    ///
    @inlinable public borrowing func power(
        _ exponent:  borrowing Fallible<some UnsignedInteger>,
        coefficient: borrowing Nonzero<Self>
    ) -> Fallible<Self> {
        self.power(exponent.value, coefficient: coefficient).veto(exponent.error)
    }
    
    /// Returns a `power` and an `error` indiactor.
    ///
    /// - Returns: `pow(self, exponent) * coefficient`
    ///
    /// ```swift
    /// U8(0).power(0, coefficient:  0) // value:   0, error: false
    /// U8(0).power(0, coefficient:  1) // value:   1, error: false
    /// U8(0).power(1, coefficient:  2) // value:   0, error: false
    /// U8(1).power(2, coefficient:  3) // value:   3, error: false
    /// U8(2).power(3, coefficient:  5) // value:  40, error: false
    /// U8(3).power(5, coefficient:  7) // value: 165, error: true
    /// U8(5).power(7, coefficient: 11) // value: 239, error: true
    /// ```
    ///
    /// - Note: The default `coefficient` is `1`.
    ///
    @inlinable public borrowing func power(
        _  exponent: borrowing Fallible<some UnsignedInteger>,
        coefficient: borrowing Self = 1
    ) -> Fallible<Self> {
        self.power(exponent.value, coefficient: coefficient).veto(exponent.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension Fallible where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns a `power` and an `error` indiactor.
    ///
    /// - Returns: `pow(self, exponent) * coefficient`
    ///
    /// ```swift
    /// U8(0).power(0, coefficient:  0) // value:   0, error: false
    /// U8(0).power(0, coefficient:  1) // value:   1, error: false
    /// U8(0).power(1, coefficient:  2) // value:   0, error: false
    /// U8(1).power(2, coefficient:  3) // value:   3, error: false
    /// U8(2).power(3, coefficient:  5) // value:  40, error: false
    /// U8(3).power(5, coefficient:  7) // value: 165, error: true
    /// U8(5).power(7, coefficient: 11) // value: 239, error: true
    /// ```
    ///
    /// - Note: The default `coefficient` is `1`.
    ///
    @inlinable public borrowing func power(
        _  exponent: borrowing some UnsignedInteger,
        coefficient: borrowing Nonzero<Value>
    ) -> Fallible<Value> {
        self.value.power(exponent, coefficient: coefficient).veto(self.error)
    }
    
    /// Returns a `power` and an `error` indiactor.
    ///
    /// - Returns: `pow(self, exponent) * coefficient`
    ///
    /// ```swift
    /// U8(0).power(0, coefficient:  0) // value:   0, error: false
    /// U8(0).power(0, coefficient:  1) // value:   1, error: false
    /// U8(0).power(1, coefficient:  2) // value:   0, error: false
    /// U8(1).power(2, coefficient:  3) // value:   3, error: false
    /// U8(2).power(3, coefficient:  5) // value:  40, error: false
    /// U8(3).power(5, coefficient:  7) // value: 165, error: true
    /// U8(5).power(7, coefficient: 11) // value: 239, error: true
    /// ```
    ///
    /// - Note: The default `coefficient` is `1`.
    ///
    @inlinable public borrowing func power(
        _  exponent: borrowing some UnsignedInteger,
        coefficient: borrowing Value = 1
    ) -> Fallible<Value> {
        self.value.power(exponent, coefficient: coefficient).veto(self.error)
    }
    
    /// Returns a `power` and an `error` indiactor.
    ///
    /// - Returns: `pow(self, exponent) * coefficient`
    ///
    /// ```swift
    /// U8(0).power(0, coefficient:  0) // value:   0, error: false
    /// U8(0).power(0, coefficient:  1) // value:   1, error: false
    /// U8(0).power(1, coefficient:  2) // value:   0, error: false
    /// U8(1).power(2, coefficient:  3) // value:   3, error: false
    /// U8(2).power(3, coefficient:  5) // value:  40, error: false
    /// U8(3).power(5, coefficient:  7) // value: 165, error: true
    /// U8(5).power(7, coefficient: 11) // value: 239, error: true
    /// ```
    ///
    /// - Note: The default `coefficient` is `1`.
    ///
    @inlinable public borrowing func power(
        _  exponent: borrowing Fallible<some UnsignedInteger>,
        coefficient: borrowing Nonzero<Value>
    ) -> Fallible<Value> {
        self.power(exponent.value, coefficient: coefficient).veto(exponent.error)
    }
    
    /// Returns a `power` and an `error` indiactor.
    ///
    /// - Returns: `pow(self, exponent) * coefficient`
    ///
    /// ```swift
    /// U8(0).power(0, coefficient:  0) // value:   0, error: false
    /// U8(0).power(0, coefficient:  1) // value:   1, error: false
    /// U8(0).power(1, coefficient:  2) // value:   0, error: false
    /// U8(1).power(2, coefficient:  3) // value:   3, error: false
    /// U8(2).power(3, coefficient:  5) // value:  40, error: false
    /// U8(3).power(5, coefficient:  7) // value: 165, error: true
    /// U8(5).power(7, coefficient: 11) // value: 239, error: true
    /// ```
    ///
    /// - Note: The default `coefficient` is `1`.
    ///
    @inlinable public borrowing func power(
        _  exponent: borrowing Fallible<some UnsignedInteger>,
        coefficient: borrowing Value = 1
    ) -> Fallible<Value> {
        self.power(exponent.value, coefficient: coefficient).veto(exponent.error)
    }
}
