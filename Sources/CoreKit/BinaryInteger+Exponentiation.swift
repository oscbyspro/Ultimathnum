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
        _ base: borrowing Self,
        power exponent: borrowing Natural<some UnsignedInteger>,
        coefficient: borrowing Nonzero<Self>
    ) -> Fallible<Self> {
        
        var error: Bool = false
        var power: Self = (copy coefficient).value
        var multiplier: Self = copy base
        var exponent: some UnsignedInteger = (copy exponent).value
        
        exponentiation: while true {
            if  Bool(exponent.lsb) {
                power = power.times(multiplier).sink(&error)
            }
            
            exponent = exponent.down(Shift.one)
            
            if  exponent.isZero {
                return (power).veto(error)
            }
            
            multiplier = multiplier.squared().sink(&error)
        }
    }
    
    @inlinable internal static func resolve(
        _ base: borrowing Self,
        power exponent: borrowing some UnsignedInteger,
        coefficient: borrowing Self
    ) -> Fallible<Self> {
        
        guard let coefficient = Nonzero(exactly: copy coefficient) else {
            return Fallible(Self.zero)
        }
        
        if !Self.isArbitrary {
            var (magic, error) = Magnitude.exactly(exponent).components()
            if  (error) {
                switch Bool(base.lsb) {
                case  true: error = (copy base).magnitude() != 1 // cycle
                case false: return  Self.zero.veto(!base.isZero) // zeros
                }
            }
            
            return Self.resolve(base, power: Natural(unchecked: magic), coefficient: coefficient).veto(error)
        }   else {
            var (magic) = UX(clamping:(((exponent)))) // the allocation limit is IX.max
            (((((magic)))))[Shift.min] = exponent.lsb // preserves the lsb to toggle ~0
            return Self.resolve(base, power: Natural(unchecked: magic), coefficient: coefficient)
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
    /// I8(0).power(U8(1), coefficient: I8(2)) // I8.exactly(   0)
    /// I8(1).power(U8(2), coefficient: I8(3)) // I8.exactly(   3)
    /// I8(2).power(U8(3), coefficient: I8(5)) // I8.exactly(  40)
    /// I8(3).power(U8(5), coefficient: I8(7)) // I8.exactly(1701)
    /// ```
    ///
    /// - Note: The default `coefficient` is `1`.
    ///
    @inlinable public borrowing func power(_ exponent: borrowing Magnitude, coefficient: borrowing Self = 1) -> Fallible<Self> {
        Self.resolve(self, power: exponent, coefficient: coefficient)
    }
    
    /// Returns a `power` and an `error` indiactor.
    ///
    /// - Returns: `pow(self, exponent) * coefficient`
    ///
    /// ```swift
    /// I8(0).power(U8(1), coefficient: I8(2)) // I8.exactly(   0)
    /// I8(1).power(U8(2), coefficient: I8(3)) // I8.exactly(   3)
    /// I8(2).power(U8(3), coefficient: I8(5)) // I8.exactly(  40)
    /// I8(3).power(U8(5), coefficient: I8(7)) // I8.exactly(1701)
    /// ```
    ///
    /// - Note: The default `coefficient` is `1`.
    ///
    @inlinable public borrowing func power(_ exponent: borrowing some UnsignedInteger, coefficient: borrowing Self = 1) -> Fallible<Self> {
        Self.resolve(self, power: exponent, coefficient: coefficient)
    }
}
