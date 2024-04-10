//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer
//*============================================================================*

/// A binary integer.
///
/// ### Binary
///
/// Its signedness is with respect to un/signed two's complement.
///
/// - Requires: Negative values must use binary two's complement form.
///
/// ### Magnitude
///
/// Its magnitude may be signed to accomodate lone big integers.
///
/// ### Stride
///
/// Its stride is Swift.Int which is used to step through Swift's ranges.
///
public protocol BinaryInteger<BitPattern>:
    Arithmetic,
    BitCastable,
    BitOperable,
    Comparable,
    ExpressibleByIntegerLiteral,
    Hashable,
    Sendable,
    Strideable,
    _MaybeLosslessStringConvertible
where
    Stride == Swift.Int,
    Magnitude.BitPattern == BitPattern,
    Magnitude.Element    == Element.Magnitude,
    Magnitude.Signitude  == Signitude,
    Signitude.BitPattern == BitPattern,
    Signitude.Element    == Element.Signitude,
    Signitude.Magnitude  == Magnitude
{
        
    associatedtype Element: SystemsInteger where Element.Element == Element
    
    associatedtype Signitude:   SignedInteger where Signitude.Signitude == Signitude
    
    associatedtype Magnitude: UnsignedInteger where Magnitude.Magnitude == Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    /// Indicates whether this type can represent negative values.
    ///
    /// ```
    /// ┌──────┬──────────┬──────┬──────┐
    /// │ type │ isSigned │  min │  max │
    /// ├──────┼──────────┼──────┼──────┤
    /// │ I8   │ true     │ -128 │  127 │
    /// │ U8   │ false    │    0 │  255 │
    /// └──────┴──────────┴──────┴──────┘
    /// ```
    ///
    @inlinable static var isSigned: Bool { get }
    
    /// The bit width of this type.
    ///
    /// ```
    /// ┌──────┬───────────────────┐
    /// │ type │ bitWidth          │
    /// ├──────┼───────────────────┤
    /// │ I64  │ 64                │
    /// │ IXL  │ UXL(repeating: 1) │
    /// └──────┴───────────────────┘
    /// ```
    ///
    @inlinable static var bitWidth: Magnitude { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(load source: consuming  UX.Signitude)
    
    @inlinable init(load source: consuming  UX.Magnitude)
    
    @inlinable borrowing func load(as type: UX.BitPattern.Type) -> UX.BitPattern
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(load source: consuming  Element.Signitude)
    
    @inlinable init(load source: consuming  Element.Magnitude)
    
    @inlinable borrowing func load(as type: Element.BitPattern.Type) -> Element.BitPattern
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(load source: inout MemoryInt<U8.Magnitude>.Iterator)
    
    @inlinable init(load source: inout MemoryInt<Element.Magnitude>.Iterator)
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func plus (_ increment:  borrowing Self) -> Fallible<Self>
    
    @inlinable consuming func minus(_ decrement:  borrowing Self) -> Fallible<Self>
            
    @inlinable consuming func times(_ multiplier: borrowing Self) -> Fallible<Self>
    
    @inlinable consuming func squared() -> Fallible<Self>
    
    /// ### Examples
    ///
    /// ```
    /// ┌──────────┬──────── → ─────────┬───────────┬──────────┐
    /// │ dividend │ divisor │ quotient | remainder │ error    │
    /// ├──────────┼──────── → ─────────┤───────────┤──────────┤
    /// │ I8( 7)   │ I8( 3)  │ I8( 2)   │ I8( 0)    │ false    │
    /// │ I8( 7)   │ I8(-3)  │ I8(-2)   │ I8(-1)    │ false    │
    /// │ I8(-7)   │ I8( 3)  │ I8(-2)   │ I8(-1)    │ false    │
    /// │ I8(-7)   │ I8(-3)  │ I8( 2)   │ I8( 0)    │ false    │
    /// │──────────┤──────── → ─────────┤───────────┤──────────┤
    /// │ I8( 7)   │ I8( 0)  │ I8( 0)   │ I8( 7)    │ true     │
    /// │ I8.min   │ I8(-1)  │ I8.min   │ I8( 0)    │ true     │
    /// └──────────┴──────── → ─────────┴───────────┴──────────┘
    /// ```
    ///
    @inlinable consuming func quotient (_ divisor: borrowing Self) -> Fallible<Self>
    
    /// ### Examples
    ///
    /// ```
    /// ┌──────────┬──────── → ─────────┬───────────┬──────────┐
    /// │ dividend │ divisor │ quotient | remainder │ error    │
    /// ├──────────┼──────── → ─────────┤───────────┤──────────┤
    /// │ I8( 7)   │ I8( 3)  │ I8( 2)   │ I8( 0)    │ false    │
    /// │ I8( 7)   │ I8(-3)  │ I8(-2)   │ I8(-1)    │ false    │
    /// │ I8(-7)   │ I8( 3)  │ I8(-2)   │ I8(-1)    │ false    │
    /// │ I8(-7)   │ I8(-3)  │ I8( 2)   │ I8( 0)    │ false    │
    /// │──────────┤──────── → ─────────┤───────────┤──────────┤
    /// │ I8( 7)   │ I8( 0)  │ I8( 0)   │ I8( 7)    │ true     │
    /// │ I8.min   │ I8(-1)  │ I8.min   │ I8( 0)    │ true     │
    /// └──────────┴──────── → ─────────┴───────────┴──────────┘
    /// ```
    ///
    @inlinable consuming func remainder(_ divisor: borrowing Self) -> Fallible<Self>
    
    /// ### Examples
    ///
    /// ```
    /// ┌──────────┬──────── → ─────────┬───────────┬──────────┐
    /// │ dividend │ divisor │ quotient | remainder │ error    │
    /// ├──────────┼──────── → ─────────┤───────────┤──────────┤
    /// │ I8( 7)   │ I8( 3)  │ I8( 2)   │ I8( 0)    │ false    │
    /// │ I8( 7)   │ I8(-3)  │ I8(-2)   │ I8(-1)    │ false    │
    /// │ I8(-7)   │ I8( 3)  │ I8(-2)   │ I8(-1)    │ false    │
    /// │ I8(-7)   │ I8(-3)  │ I8( 2)   │ I8( 0)    │ false    │
    /// ├──────────┤──────── → ─────────┤───────────┤──────────┤
    /// │ I8( 7)   │ I8( 0)  │ I8( 0)   │ I8( 7)    │ true     │
    /// │ I8.min   │ I8(-1)  │ I8.min   │ I8( 0)    │ true     │
    /// └──────────┴──────── → ─────────┴───────────┴──────────┘
    /// ```
    ///
    @inlinable consuming func division (_ divisor: borrowing Self) -> Fallible<Division<Self, Self>>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload
    @inlinable consuming func plus (_ increment: consuming Element) -> Fallible<Self>
    
    @_disfavoredOverload
    @inlinable consuming func minus(_ decrement: consuming Element) -> Fallible<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable static func  <<(instance: consuming Self, shift: borrowing Self) -> Self
    
    @inlinable static func &<<(instance: consuming Self, shift: borrowing Self) -> Self
    
    @inlinable static func  >>(instance: consuming Self, shift: borrowing Self) -> Self
    
    @inlinable static func &>>(instance: consuming Self, shift: borrowing Self) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The bit that extends the integer's ``body``.
    ///
    /// ```
    ///            ┌───────────┬───────────┐
    ///            │ 0x00      │ 0x01      |
    /// ┌──────────┼───────────┤───────────┤
    /// │ SIGNED   │ self >= 0 │ self <  0 │
    /// ├──────────┼───────────┤───────────┤
    /// │ UNSIGNED │ self >= ∞ │ self <  ∞ │ // let ∞ be 0s then 1
    /// └──────────┴───────────┴───────────┘
    /// ```
    ///
    @inlinable var appendix: Bit { get }
    
    @inlinable borrowing func withUnsafeBinaryIntegerBody<T>(_ action: (MemoryIntBody<Element.Magnitude>) throws -> T) rethrows -> T
    
    @inlinable borrowing func compared(to other: borrowing Self) -> Signum
    
    @inlinable borrowing func count(_ bit: Bit, where selection: BitSelection) -> Magnitude
    
    @inlinable consuming func complement(_ increment: consuming Bool) -> Fallible<Self>
}
