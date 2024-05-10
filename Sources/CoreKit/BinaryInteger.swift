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
/// - Requires: Its body may store at most `IX.max` number of bits.
///
/// - Requires: `Infinite` values must use binary two's complement form.
///
/// - Requires: `Negative` values must use binary two's complement form.
///
/// ### Magnitude
///
/// Its magnitude may be signed to accomodate lone big integers.
///
/// ### Stride
///
/// Its stride is Swift.Int which is used to step through Swift's ranges.
///
/// ### Infinity
///
/// The binary integer domain now includes infinite values! This lets you
/// bit cast all kinds of binary integers and recover from bitwise negation.
///
/// ```swift
/// IXL(repeating: 0).toggled() == IXL(repeating: 1)
/// UXL(repeating: 0).toggled() == UXL(repeating: 1)
/// ```
///
/// Keep in mind that infinite values take on the order of their host type.
/// You may intuit that the size of an infinite integer is smaller than its
/// upper bound. If you are interested in infinite values then you need to
/// track where they came from.
///
/// ```swift
/// UXL(repeating: 0).count(0) // log2(x) -> UXL(repeating: 1)
/// ```
///
/// In most cases, however, you should view infinite values as bit patterns.
///
/// - Important: Infinite values take on the order of their host type.
///
public protocol BinaryInteger<BitPattern>:
    BitCastable,
    BitCountable,
    BitOperable,
    Comparable,
    ExpressibleByIntegerLiteral,
    Hashable,
    Sendable,
    Strideable,
    MaybeLosslessStringConvertible
where
    BitCount == Magnitude,
    Element.Mode == Mode,
    Magnitude.BitPattern == BitPattern,
    Magnitude.Element    == Element.Magnitude,
    Magnitude.Signitude  == Signitude,
    Signitude.BitPattern == BitPattern,
    Signitude.Element    == Element.Signitude,
    Signitude.Magnitude  == Magnitude,
    Stride == Swift.Int
{
    
    associatedtype Mode: Signedness
        
    associatedtype Element:    SystemsInteger where Element.Element == Element
    
    associatedtype Signitude:   SignedInteger where Signitude.Signitude == Signitude
    
    associatedtype Magnitude: UnsignedInteger where Magnitude.Magnitude == Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// Indicates whether this integer type can represent negative values.
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
    @inlinable static var mode: Mode { get }
    
    /// The maximum number of bits that fit in the body of this integer type.
    ///
    /// ```
    /// ┌──────┬───────────────────┐
    /// │ type │ size              │
    /// ├──────┼───────────────────┤
    /// │ I64  │ 64                │
    /// │ IXL  │ UXL(repeating: 1) │
    /// └──────┴───────────────────┘
    /// ```
    ///
    /// - Invariant: `Self.size == self.count(0) + self.count(1)`.
    ///
    @inlinable static var size: Magnitude { get }
    
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
    
    @inlinable init(load source: LoadInt<Element.Magnitude>)
    
    @inlinable init(load source: DataInt<Element.Magnitude>)
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func complement(_ increment: consuming Bool) -> Fallible<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func plus (_ increment:  borrowing Self) -> Fallible<Self>
    
    @inlinable consuming func minus(_ decrement:  borrowing Self) -> Fallible<Self>
            
    @inlinable consuming func times(_ multiplier: borrowing Self) -> Fallible<Self>
    
    @inlinable consuming func squared() -> Fallible<Self>
    
    /// Returns the `quotient` and `error` of dividing `self` by the `divisor`.
    ///
    /// ### Rules
    ///
    /// ```
    /// ┌──────────┬──────── → ─────────┬───────────┬───────┐
    /// │ dividend │ divisor │ quotient | remainder │ error │
    /// ├──────────┼──────── → ─────────┤───────────┤───────┤
    /// │ I32( 7)  │ I32( 3) │ I32( 2)  │ I32( 1)   │ false │
    /// │ I32( 7)  │ I32(-3) │ I32(-2)  │ I32( 1)   │ false │
    /// │ I32(-7)  │ I32( 3) │ I32(-2)  │ I32(-1)   │ false │
    /// │ I32(-7)  │ I32(-3) │ I32( 2)  │ I32(-1)   │ false │
    /// ├──────────┤──────── → ─────────┤───────────┤───────┤
    /// │ I32.min  │ I32(-1) │ I32.min  │ I32( 0)   │ true  │
    /// │ I32( 7)  │ I32( 0) │ -------  │ -------   │ ----- │ // invalid
    /// └──────────┴──────── → ─────────┴───────────┴───────┘
    /// ```
    ///
    /// ```
    /// ┌──────────┬──────── → ─────────┬───────────┬───────┐
    /// │ dividend │ divisor │ quotient | remainder │ error │
    /// ├──────────┼──────── → ─────────┤───────────┤───────┤
    /// │ UXL(~2)  │ UXL(~0) │ UXL( 0)  │ UXL(~2)   │ false │
    /// │ UXL(~2)  │ UXL(~1) │ UXL( 0)  │ UXL(~2)   │ false │
    /// │ UXL(~2)  │ UXL(~2) │ UXL( 1)  │ UXL( 0)   │ false │
    /// │ UXL(~2)  │ UXL(~3) │ UXL( 1)  │ UXL( 1)   │ false │
    /// ├──────────┤──────── → ─────────┤───────────┤───────┤
    /// │ UXL(~2)  │ UXL( 1) │ UXL(~2)  │ UXL( 0)   │ false │
    /// │ UXL(~2)  │ UXL( 2) │ UXL(~0)  │ UXL(~0)   │ true  │
    /// │ UXL(~2)  │ UXL( 3) │ UXL(~0)  │ UXL( 0)   │ true  │
    /// │ UXL(~2)  │ UXL( 4) │ UXL( 0)  │ UXL(~2)   │ true  │
    /// └──────────┴──────── → ─────────┴───────────┴───────┘
    /// ```
    ///
    /// - Note: Infinite by finite reinterprets infinite as negative.
    ///
    /// ### Invariants
    ///
    /// ```
    /// dividend == divisor &* quotient &+ remainder
    /// ```
    ///
    @inlinable consuming func quotient(_ divisor: borrowing Divisor<Self>) -> Fallible<Self>
    
    /// Returns the `remainder` of dividing `self` by the `divisor`.
    ///
    /// ### Rules
    ///
    /// ```
    /// ┌──────────┬──────── → ─────────┬───────────┬───────┐
    /// │ dividend │ divisor │ quotient | remainder │ error │
    /// ├──────────┼──────── → ─────────┤───────────┤───────┤
    /// │ I32( 7)  │ I32( 3) │ I32( 2)  │ I32( 1)   │ false │
    /// │ I32( 7)  │ I32(-3) │ I32(-2)  │ I32( 1)   │ false │
    /// │ I32(-7)  │ I32( 3) │ I32(-2)  │ I32(-1)   │ false │
    /// │ I32(-7)  │ I32(-3) │ I32( 2)  │ I32(-1)   │ false │
    /// ├──────────┤──────── → ─────────┤───────────┤───────┤
    /// │ I32.min  │ I32(-1) │ I32.min  │ I32( 0)   │ true  │
    /// │ I32( 7)  │ I32( 0) │ -------  │ -------   │ ----- │ // invalid
    /// └──────────┴──────── → ─────────┴───────────┴───────┘
    /// ```
    ///
    /// ```
    /// ┌──────────┬──────── → ─────────┬───────────┬───────┐
    /// │ dividend │ divisor │ quotient | remainder │ error │
    /// ├──────────┼──────── → ─────────┤───────────┤───────┤
    /// │ UXL(~2)  │ UXL(~0) │ UXL( 0)  │ UXL(~2)   │ false │
    /// │ UXL(~2)  │ UXL(~1) │ UXL( 0)  │ UXL(~2)   │ false │
    /// │ UXL(~2)  │ UXL(~2) │ UXL( 1)  │ UXL( 0)   │ false │
    /// │ UXL(~2)  │ UXL(~3) │ UXL( 1)  │ UXL( 1)   │ false │
    /// ├──────────┤──────── → ─────────┤───────────┤───────┤
    /// │ UXL(~2)  │ UXL( 1) │ UXL(~2)  │ UXL( 0)   │ false │
    /// │ UXL(~2)  │ UXL( 2) │ UXL(~0)  │ UXL(~0)   │ true  │
    /// │ UXL(~2)  │ UXL( 3) │ UXL(~0)  │ UXL( 0)   │ true  │
    /// │ UXL(~2)  │ UXL( 4) │ UXL( 0)  │ UXL(~2)   │ true  │
    /// └──────────┴──────── → ─────────┴───────────┴───────┘
    /// ```
    ///
    /// - Note: Infinite by finite reinterprets infinite as negative.
    ///
    /// ### Invariants
    ///
    /// ```
    /// dividend == divisor &* quotient &+ remainder
    /// ```
    ///
    @inlinable consuming func remainder(_ divisor: borrowing Divisor<Self>) -> Self
    
    /// Returns the result of dividing `self` by the `divisor`.
    ///
    /// ### Rules
    ///
    /// ```
    /// ┌──────────┬──────── → ─────────┬───────────┬───────┐
    /// │ dividend │ divisor │ quotient | remainder │ error │
    /// ├──────────┼──────── → ─────────┤───────────┤───────┤
    /// │ I32( 7)  │ I32( 3) │ I32( 2)  │ I32( 1)   │ false │
    /// │ I32( 7)  │ I32(-3) │ I32(-2)  │ I32( 1)   │ false │
    /// │ I32(-7)  │ I32( 3) │ I32(-2)  │ I32(-1)   │ false │
    /// │ I32(-7)  │ I32(-3) │ I32( 2)  │ I32(-1)   │ false │
    /// ├──────────┤──────── → ─────────┤───────────┤───────┤
    /// │ I32.min  │ I32(-1) │ I32.min  │ I32( 0)   │ true  │
    /// │ I32( 7)  │ I32( 0) │ -------  │ -------   │ ----- │ // invalid
    /// └──────────┴──────── → ─────────┴───────────┴───────┘
    /// ```
    ///
    /// ```
    /// ┌──────────┬──────── → ─────────┬───────────┬───────┐
    /// │ dividend │ divisor │ quotient | remainder │ error │
    /// ├──────────┼──────── → ─────────┤───────────┤───────┤
    /// │ UXL(~2)  │ UXL(~0) │ UXL( 0)  │ UXL(~2)   │ false │
    /// │ UXL(~2)  │ UXL(~1) │ UXL( 0)  │ UXL(~2)   │ false │
    /// │ UXL(~2)  │ UXL(~2) │ UXL( 1)  │ UXL( 0)   │ false │
    /// │ UXL(~2)  │ UXL(~3) │ UXL( 1)  │ UXL( 1)   │ false │
    /// ├──────────┤──────── → ─────────┤───────────┤───────┤
    /// │ UXL(~2)  │ UXL( 1) │ UXL(~2)  │ UXL( 0)   │ false │
    /// │ UXL(~2)  │ UXL( 2) │ UXL(~0)  │ UXL(~0)   │ true  │
    /// │ UXL(~2)  │ UXL( 3) │ UXL(~0)  │ UXL( 0)   │ true  │
    /// │ UXL(~2)  │ UXL( 4) │ UXL( 0)  │ UXL(~2)   │ true  │
    /// └──────────┴──────── → ─────────┴───────────┴───────┘
    /// ```
    ///
    /// - Note: Infinite by finite reinterprets infinite as negative.
    ///
    /// ### Invariants
    ///
    /// ```
    /// dividend == divisor &* quotient &+ remainder
    /// ```
    ///
    @inlinable consuming func division(_ divisor: borrowing Divisor<Self>) -> Fallible<Division<Self, Self>>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable static func  <<(instance: consuming Self, distance: borrowing Self) -> Self
    
    @inlinable static func &<<(instance: consuming Self, distance: borrowing Shift<Self>) -> Self
    
    @inlinable static func  >>(instance: consuming Self, distance: borrowing Self) -> Self
    
    @inlinable static func &>>(instance: consuming Self, distance: borrowing Shift<Self>) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable borrowing func compared(to other: borrowing Self) -> Signum
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The bit that extends the integer's `body`.
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
    @inlinable var appendix: Bit { borrowing get }
    
    @inlinable borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (DataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T
    
    @inlinable mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (MutableDataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T
}
