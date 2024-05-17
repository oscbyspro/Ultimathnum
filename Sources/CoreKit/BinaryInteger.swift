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
/// Its magnitude may be signed to accommodate lone big integers.
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
    BitOperable,
    Comparable,
    ExpressibleByIntegerLiteral,
    Hashable,
    Recoverable,
    Sendable,
    Strideable,
    MaybeLosslessStringConvertible
where
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
        
    /// The stuff this binary integer type is made of.
    ///
    /// - Important: `Self` must be properly aligned for accessing `Element`.
    ///
    associatedtype Element: SystemsInteger where Element.Element == Element
    
    /// A signed binary integer type of equal size.
    associatedtype Signitude: SignedInteger where Signitude.Signitude == Signitude
    
    /// An unsigned binary integer type of equal size.
    associatedtype Magnitude: UnsignedInteger where Magnitude.Magnitude == Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// Indicates whether this type uses the signed two's complement format.
    ///
    /// ```
    /// ┌──────┬──────────┬──────┬──────┐
    /// │ type │     mode │  min │  max │
    /// ├──────┼──────────┼──────┼──────┤
    /// │ I8   │   signed │ -128 │  127 │
    /// │ U8   │ unsigned │    0 │  255 │
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
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    @inlinable init(load source: consuming  UX.Signitude)
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    @inlinable init(load source: consuming  UX.Magnitude)
    
    /// Returns instance of `type` from the bit pattern of `self` that fits.
    @inlinable borrowing func load(as type: UX.BitPattern.Type) -> UX.BitPattern
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    @inlinable init(load source: consuming  Element.Signitude)
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    @inlinable init(load source: consuming  Element.Magnitude)
    
    /// Returns instance of `type` from the bit pattern of `self` that fits.
    @inlinable borrowing func load(as type: Element.BitPattern.Type) -> Element.BitPattern
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    @inlinable init(load source: DataInt<U8>)
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    @inlinable init(load source: DataInt<Element.Magnitude>)
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the 1's or 2's complement of `self`.
    ///
    /// - Note: The carry from addition is stored in the `error` field.
    ///
    @inlinable consuming func complement(_ increment: consuming Bool) -> Fallible<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the validated result of `self + increment`.
    @inlinable consuming func plus (_ increment:  borrowing Self) -> Fallible<Self>
    
    /// Returns the validated result of `self - increment`.
    @inlinable consuming func minus(_ decrement:  borrowing Self) -> Fallible<Self>
    
    /// Returns the validated result of `self * increment`.
    @inlinable borrowing func times(_ multiplier: borrowing Self) -> Fallible<Self>
    
    /// Returns the validated result of `self ^ 2`.
    @inlinable borrowing func squared() -> Fallible<Self>
    
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
    
    /// Returns the result that fits of a so-called smart left shift.
    ///
    ///  - Note: The `0` bit fills the void.
    ///
    @inlinable static func  <<(instance: consuming Self, distance: borrowing Self) -> Self
    
    /// Returns the result that fits of a so-called exact left shift.
    ///
    ///  - Note: The `0` bit fills the void.
    ///
    @inlinable static func &<<(instance: consuming Self, distance: borrowing Shift<Self>) -> Self
    
    /// Returns the result that fits of a so-called un/signed smart right shift.
    ///
    /// - Note: The `appendix` fills the void.
    ///
    @inlinable static func  >>(instance: consuming Self, distance: borrowing Self) -> Self
    
    /// Returns the result that fits of a so-called un/signed exact right shift.
    ///
    /// - Note: The `appendix` fills the void.
    ///
    @inlinable static func &>>(instance: consuming Self, distance: borrowing Shift<Self>) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable borrowing func compared(to other: borrowing Self) -> Signum
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The number of bits in `self` that match the `selection`.
    ///
    /// ```swift
    /// I8(11).count(0) // 5
    /// I8(11).count(1) // 3
    /// ```
    ///
    @inlinable borrowing func count(_ selection: Bit) -> Magnitude
    
    /// The number of bits in `self` that match the `selection`.
    ///
    /// ```swift
    /// I8(11).count(.ascending(0)) // 0
    /// I8(11).count(.ascending(1)) // 2
    /// I8(22).count(.ascending(0)) // 1
    /// I8(22).count(.ascending(1)) // 0
    /// ```
    ///
    @inlinable borrowing func count(_ selection: Bit.Ascending) -> Magnitude
    
    /// The number of bits in `self` that match the `selection`.
    ///
    /// ```swift
    /// I8(11).count(.descending(0)) // 4
    /// I8(11).count(.descending(1)) // 0
    /// I8(22).count(.descending(0)) // 3
    /// I8(22).count(.descending(1)) // 0
    /// ```
    ///
    @inlinable borrowing func count(_ selection: Bit.Descending) -> Magnitude
    
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
    
    /// Executes the `action` with the `body` of `self`.
    @inlinable borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (DataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T
    
    /// Executes the `action` with the mutable `body` of `self`.
    @inlinable mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (MutableDataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T
}
