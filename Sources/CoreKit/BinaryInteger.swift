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
/// ### Development
///
/// - TODO: Check whether `incrementAtEndIndex(_:)` composes well.
/// - TODO: Check whether `decrementAtEndIndex(_:)` composes well.
///
public protocol BinaryInteger<BitPattern>:
    BitCastable,
    BitOperable,
    Comparable,
    ExpressibleByIntegerLiteral,
    Functional,
    Hashable,
    Sendable,
    Strideable,
    MaybeLosslessStringConvertible
where
    Stride == Swift.Int,
    Element.Mode == Mode,
    Magnitude.BitPattern == BitPattern,
    Magnitude.Element    == Element.Magnitude,
    Magnitude.Signitude  == Signitude,
    Signitude.BitPattern == BitPattern,
    Signitude.Element    == Element.Signitude,
    Signitude.Magnitude  == Magnitude
{
    
    associatedtype Mode: Signedness
        
    associatedtype Element:    SystemsInteger where Element.Element == Element
    
    associatedtype Signitude:   SignedInteger where Signitude.Signitude == Signitude
    
    associatedtype Magnitude: UnsignedInteger where Magnitude.Magnitude == Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
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
    
    @inlinable init(load source: DataInt<U8.Magnitude>)
    
    @inlinable init(load source: DataInt<Element.Magnitude>)
        
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
    
    @inlinable static func  <<(instance: consuming Self, distance: borrowing Self) -> Self
    
    @inlinable static func &<<(instance: consuming Self, distance: borrowing Shift<Self>) -> Self
    
    @inlinable static func  >>(instance: consuming Self, distance: borrowing Self) -> Self
    
    @inlinable static func &>>(instance: consuming Self, distance: borrowing Shift<Self>) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func complement(_ increment: consuming Bool) -> Fallible<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable borrowing func compared(to other: borrowing Self) -> Signum
        
    @inlinable borrowing func count(_ bit: Bit, where selection: Bit.Selection) -> Magnitude
        
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
    @inlinable var appendix: Bit { get }
    
    @inlinable borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (DataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T
    
    @inlinable mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (MutableDataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T
}
