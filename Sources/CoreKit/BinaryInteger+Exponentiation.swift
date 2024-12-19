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
// TODO: We need default generic parameter types <T = Magnitude> to deduplicate.
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// A square-and-multiply exponentiation algorithm.
    ///
    /// - Note: All operations on `base` are `borrowing`.
    ///
    /// ### Development
    ///
    /// Use `1` systems integer `exponent` type per type of `Self`.
    ///
    ///     Magnitude.size < UX.size: UX or
    ///     Magnitude.size ≤ IX.max.: Magnitude
    ///     Magnitude.size > IX.max.: UX
    ///
    /// - Todo: Small arbitrary integer optimization (#44) (#153).
    ///
    @inlinable internal static func perform(
        _         base: consuming Self,
        power exponent: consuming Natural<some UnsignedInteger>
    )   -> Fallible<Self> {
        
        var error: Bool = false
        var power: Self = Self(load: Element.lsb)
        
        exponentiation: while true {
            if  Bool(exponent.value.lsb) {
                power = power.times(base).sink(&error)
            }
            
            exponent = Natural(unchecked: exponent.value.down(Shift.one))
            
            if  exponent.value.isZero {
                return (power).veto(error)
            }
            
            base = base.squared().sink(&error)
        }
    }
    
    @inlinable internal static func resolve(
        _         base: borrowing Self,
        power exponent: borrowing some UnsignedInteger
    )   -> Fallible<Self> {
        
        if !Self.isArbitrary {
            var (magic, error) = Magnitude.exactly(exponent).components()
            if  (error) {
                switch Bool(base.lsb) {
                case  true: error = (copy base).magnitude() != 1 // cycle
                case false: return  Self.zero.veto(!base.isZero) // zeros
                }
            }
            
            return Self.perform(copy base, power: Natural(unchecked: magic)).veto(error)
        }   else {
            var (magic) = UX(clamping:(((exponent)))) // the allocation limit is IX.max
            (((((magic)))))[Shift.min] = exponent.lsb // preserves the lsb to toggle ~0
            return Self.perform(copy base, power: Natural(unchecked: magic))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns `self` to the power of `exponent` and an `error` indiactor.
    ///
    /// ```swift
    /// I8(0).power(U8(1), coefficient: I8(2)) // I8.exactly(   0)
    /// I8(1).power(U8(2), coefficient: I8(3)) // I8.exactly(   3)
    /// I8(2).power(U8(3), coefficient: I8(5)) // I8.exactly(  40)
    /// I8(3).power(U8(5), coefficient: I8(7)) // I8.exactly(1701)
    /// ```
    ///
    /// ### Exponentiation
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public borrowing func power(_ exponent: borrowing Magnitude) -> Fallible<Self> {
        Self.resolve(self, power: exponent)
    }
    
    /// Returns `self` to the power of `exponent` and an `error` indiactor.
    ///
    /// ```swift
    /// I8(0).power(U8(1), coefficient: I8(2)) // I8.exactly(   0)
    /// I8(1).power(U8(2), coefficient: I8(3)) // I8.exactly(   3)
    /// I8(2).power(U8(3), coefficient: I8(5)) // I8.exactly(  40)
    /// I8(3).power(U8(5), coefficient: I8(7)) // I8.exactly(1701)
    /// ```
    ///
    /// ### Exponentiation
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public borrowing func power(_ exponent: borrowing some UnsignedInteger) -> Fallible<Self> {
        Self.resolve(self, power: exponent)
    }
}

//*============================================================================*
// MARK: * Binary Integer x Exponentiation x Lenient
//*============================================================================*

extension BinaryInteger where Self: ArbitraryInteger & SignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns `self` to the power of `exponent`.
    ///
    /// ```swift
    /// I8(0).power(U8(1), coefficient: I8(2)) // I8.exactly(   0)
    /// I8(1).power(U8(2), coefficient: I8(3)) // I8.exactly(   3)
    /// I8(2).power(U8(3), coefficient: I8(5)) // I8.exactly(  40)
    /// I8(3).power(U8(5), coefficient: I8(7)) // I8.exactly(1701)
    /// ```
    ///
    /// ### Exponentiation
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public borrowing func power(_ exponent: borrowing Magnitude) -> Self {
        self.power(exponent).unchecked()
    }
    
    /// Returns `self` to the power of `exponent`.
    ///
    /// ```swift
    /// I8(0).power(U8(1), coefficient: I8(2)) // I8.exactly(   0)
    /// I8(1).power(U8(2), coefficient: I8(3)) // I8.exactly(   3)
    /// I8(2).power(U8(3), coefficient: I8(5)) // I8.exactly(  40)
    /// I8(3).power(U8(5), coefficient: I8(7)) // I8.exactly(1701)
    /// ```
    ///
    /// ### Exponentiation
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public borrowing func power(_ exponent: borrowing some UnsignedInteger) -> Self {
        self.power(exponent).unchecked()
    }
}
