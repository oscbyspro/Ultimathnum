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
/// ### Infinity
///
/// The binary integer domain now includes infinite values! This lets you
/// bit cast all kinds of binary integers and recover from bitwise negation.
///
/// ```swift
/// UXL(repeating: 0).toggled() == UXL(repeating: 1)
/// ```
///
/// Keep in mind that infinite values take on the order of their host type.
/// You may intuit that the size of an infinite integer is smaller than its
/// upper bound. If you are interested in infinite values then you need to
/// track where they came from. In most cases, however, it is enough to view
/// infinite values as well-behaved bit patterns.
///
/// ```swift
/// IXL.size // log2(UXL.max + 1) gets promoted to UXL.max
/// ```
/// 
/// - Important: Infinite values take on the order of their host type.
///
/// ### Stride
///
/// Its stride type is Swift.Int so that you may use Swift's range models.
///
/// ### Requirements
///
/// - Requires: Its `body` and `appendix` must fit in `IX.max` bits.
///
/// - Requires: `Infinite` values must use binary two's complement form.
///
/// - Requires: `Negative` values must use binary two's complement form.
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
    
    /// The 2's complement signedness of this type.
    associatedtype Mode: Signedness
    
    /// The stuff this binary integer type is made of.
    ///
    /// - Important: `Self`'s body must be properly aligned for accessing `Element`.
    ///
    associatedtype Element: SystemsInteger where Element.Element == Element
    
    /// A signed binary integer type of equal size.
    associatedtype Signitude: SignedInteger where Signitude.Signitude == Signitude
    
    /// An unsigned binary integer type of equal size.
    associatedtype Magnitude: UnsignedInteger where Magnitude.Magnitude == Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// Indicates whether this type uses the signed 2's complement format.
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
    
    /// The number of bits that fit in the `body` of this binary integer type.
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
    /// - Note: `log2(UXL.max + 1)` gets promoted to `UXL.max`.
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
    /// - Note: The 1's complement is defined as `self.toggled()`.
    ///
    /// - Note: The 2's complement is defined as `self.toggled() &+ 1`.
    ///
    /// - Note: The overflow of addition is stored in the `error`.
    ///
    /// ### Well-behaved arbitrary unsigned integers
    ///
    /// The notion of infinity keeps arbitrary unsigned integers well-behaved.
    ///
    /// ```swift
    /// UXL(repeating: 0) //  x
    /// UXL(repeating: 1) // ~x
    /// UXL(repeating: 0) // ~x &+ 1 == y
    /// UXL(repeating: 1) // ~y
    /// UXL(repeating: 0) // ~y &+ 1 == x
    /// ```
    ///
    /// ```swift
    /// UXL([~0] as [UX], repeating: 0) //  x
    /// UXL([ 0] as [UX], repeating: 1) // ~x
    /// UXL([ 1] as [UX], repeating: 1) // ~x &+ 1 == y
    /// UXL([~1] as [UX], repeating: 0) // ~y
    /// UXL([~0] as [UX], repeating: 0) // ~y &+ 1 == x
    /// ```
    ///
    /// ```swift
    /// UXL([ 0    ] as [UX], repeating: 1) //  x
    /// UXL([~0    ] as [UX], repeating: 0) // ~x
    /// UXL([ 0,  1] as [UX], repeating: 0) // ~x &+ 1 == y
    /// UXL([~0, ~1] as [UX], repeating: 1) // ~y
    /// UXL([ 0    ] as [UX], repeating: 1) // ~y &+ 1 == x
    /// ```
    ///
    @inlinable consuming func complement(_ increment: consuming Bool) -> Fallible<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the validated result of `self + increment`.
    @inlinable consuming func plus (_ increment:  borrowing Self) -> Fallible<Self>
    
    /// Returns the validated result of `self - decrement`.
    @inlinable consuming func minus(_ decrement:  borrowing Self) -> Fallible<Self>
    
    /// Returns the validated result of `self * multiplier`.
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
    /// │ I32( 7)  │ I32( 0) │ %%%%%%%  │ %%%%%%%   │ %%%%% │
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
    /// │ UXL(~2)  │ UXL( 0) │ %%%%%%%  │ %%%%%%%   │ %%%%% │
    /// │ UXL(~2)  │ UXL( 1) │ UXL(~2)  │ UXL( 0)   │ true  │
    /// │ UXL(~2)  │ UXL( 2) │ UXL(~0)  │ UXL(~0)   │ true  │
    /// │ UXL(~2)  │ UXL( 3) │ UXL(~0)  │ UXL( 0)   │ true  │
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
    /// │ I32( 7)  │ I32( 0) │ %%%%%%%  │ %%%%%%%   │ %%%%% │
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
    /// │ UXL(~2)  │ UXL( 0) │ %%%%%%%  │ %%%%%%%   │ %%%%% │
    /// │ UXL(~2)  │ UXL( 1) │ UXL(~2)  │ UXL( 0)   │ true  │
    /// │ UXL(~2)  │ UXL( 2) │ UXL(~0)  │ UXL(~0)   │ true  │
    /// │ UXL(~2)  │ UXL( 3) │ UXL(~0)  │ UXL( 0)   │ true  │
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
    /// │ I32( 7)  │ I32( 0) │ %%%%%%%  │ %%%%%%%   │ %%%%% │
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
    /// │ UXL(~2)  │ UXL( 0) │ %%%%%%%  │ %%%%%%%   │ %%%%% │
    /// │ UXL(~2)  │ UXL( 1) │ UXL(~2)  │ UXL( 0)   │ true  │
    /// │ UXL(~2)  │ UXL( 2) │ UXL(~0)  │ UXL(~0)   │ true  │
    /// │ UXL(~2)  │ UXL( 3) │ UXL(~0)  │ UXL( 0)   │ true  │
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
    
    /// Performs an ascending shift.
    ///
    /// - Parameter distance: A shift in the range of `0 ..< Self.size`.
    ///
    /// - Note: The `0` bit fills the void.
    ///
    @inlinable consuming func up(_ distance: Shift<Self>) -> Self
    
    /// Performs a decending shift.
    ///
    /// - Parameter distance: A shift in the range of `0 ..< Self.size`.
    ///
    /// - Note: The `appendix` fills the void.
    ///
    @inlinable consuming func down(_ distance: Shift<Self>) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Performs a three-way comparison of `self` versus `other`.
    @inlinable borrowing func compared(to other: borrowing Self) -> Signum
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The `bit` count in `self`.
    ///
    /// ```swift
    /// I8(11).count(0) // 5
    /// I8(11).count(1) // 3
    /// ```
    ///
    @inlinable borrowing func count(_ bit: Bit) -> Magnitude
    
    /// The ascending `bit` count in `self`.
    ///
    /// ```swift
    /// I8(11).ascending(0) // 0
    /// I8(11).ascending(1) // 2
    /// I8(22).ascending(0) // 1
    /// I8(22).ascending(1) // 0
    /// ```
    ///
    @inlinable borrowing func ascending(_ bit: Bit) -> Magnitude
    
    /// The descending `bit` count in `self`.
    ///
    /// ```swift
    /// I8(11).descending(0) // 4
    /// I8(11).descending(1) // 0
    /// I8(22).descending(0) // 3
    /// I8(22).descending(1) // 0
    /// ```
    ///
    @inlinable borrowing func descending(_ bit: Bit) -> Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The bit that extends the integer's `body`.
    ///
    /// ```
    ///            ┌───────────────┬───────────────┐
    ///            │ appendix == 0 │ appendix == 1 |
    /// ┌──────────┼───────────────┤───────────────┤
    /// │   Signed │ self >= 0     │ self <  0     │
    /// ├──────────┼───────────────┤───────────────┤
    /// │ Unsigned │ self <  ∞     │ self >= ∞     │
    /// └──────────┴───────────────┴───────────────┘
    /// ```
    ///
    @inlinable var appendix: Bit { borrowing get }
    
    /// Performs the `action` on the `body` of `self`.
    ///
    /// ### Development
    ///
    /// - TODO: Rework this when buffer views are added to Swift.
    ///
    @inlinable borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (DataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T
    
    /// Performs the `action` on the mutable `body` of `self`.
    ///
    /// ### Development
    ///
    /// - TODO: Rework this when buffer views are added to Swift.
    ///
    @inlinable mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (MutableDataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T
}
