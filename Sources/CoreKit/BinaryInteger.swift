//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
public protocol BinaryInteger: BitCastable, BitOperable, Integer where Magnitude: UnsignedInteger, Magnitude.BitPattern == BitPattern {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    /// Indicates whether this type can represent negative values.
    ///
    /// ```
    /// ┌──────┬──────────┬─────┬─────┐
    /// │ type │ isSigned │ min │ max │
    /// ├──────┼──────────┼─────┼─────┤
    /// │ I1   │ true     │ -1  │   0 │
    /// │ U1   │ false    │  0  │  -1 │
    /// └──────┴──────────┴─────┴─────┘
    /// ```
    ///
    @inlinable static var isSigned: Bool { get }
    
    /// The bit width of this type.
    ///
    /// ```
    /// ┌──────┬───────────────────┐
    /// │ type │ bitWidth          │
    /// ├──────┼───────────────────┤
    /// │ I64  │ U64(repeating: 1) │ // 64
    /// │ IXL  │ UXL(repeating: 1) │ // infinite
    /// └──────┴───────────────────┘
    /// ```
    ///
    @inlinable static var bitWidth: Magnitude { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(load source: consuming Pattern<some RandomAccessCollection<UX>>)
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable static func  <<(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func  >>(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func count(_ bit: BitInt.Magnitude, option: BitInt.Selection) -> Magnitude
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - Note: This method is **important** for performance.
    ///
    @inlinable public init(_ bit: U1) {
        self = Bool(bitPattern: bit) ?  1 : 0 // TODO: 0 and 1-bit
    }
    
    @inlinable public init(repeating bit: U1) {
        self = Bool(bitPattern: bit) ? ~0 : 0
    }
    
    @inlinable public init<T>(truncating source: T) where T: Integer {
        self.init(load: Pattern(source.words, isSigned: T.isSigned))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(sign: consuming Sign, magnitude: consuming Magnitude) throws {
        var bitPattern = consume magnitude
        var isLessThanZero = sign == Sign.minus
        if  isLessThanZero {
            isLessThanZero = Overflow.capture(&bitPattern, map:{ try $0.negated() })
        }
        
        self.init(bitPattern: consume bitPattern)
        if  self.isLessThanZero != isLessThanZero {
            throw Overflow(consume self)
        }
    }
    
    @inlinable public init(words: consuming some RandomAccessCollection<UX>, isSigned: consuming Bool) throws {
        let pattern = Pattern(words, isSigned: isSigned)
        self.init(load: pattern)
        
        let current = self.words as Words
        let success = self.isLessThanZero == pattern.isLessThanZero as Bool as Bool
        && (current.last ?? 0) == (pattern.base.dropFirst(Swift.max(0, current.count - 1 )).first ?? 0)
        &&  pattern.base.dropFirst(current.count).allSatisfy({ $0 == pattern.sign })
        
        if !success {
            throw Overflow(consume self)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - FIXME: Consuming caues bad accesss (2024-01-13, Swift 5.9).
    ///
    @inlinable public static func &+(lhs: Self, rhs: Self) -> Self {
        Overflow.ignore({ try lhs.plus(rhs) })
    }
    
    /// ### Development
    ///
    /// - FIXME: Consuming caues bad accesss (2024-01-13, Swift 5.9).
    ///
    @inlinable public static func &-(lhs: Self, rhs: Self) -> Self {
        Overflow.ignore({ try lhs.minus(rhs) })
    }
    
    /// ### Development
    ///
    /// - FIXME: Consuming caues bad accesss (2024-01-13, Swift 5.9).
    ///
    @inlinable public static func &*(lhs: Self, rhs: Self) -> Self {
        Overflow.ignore({ try lhs.times(rhs) })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns whether this value is less than zero.
    ///
    /// It checks `isSigned` first which is preferred in inlinable generic code.
    ///
    @inlinable public var isLessThanZero: Bool {
        borrowing get { if Self.isSigned { self < 0 } else { false } }
    }
}
