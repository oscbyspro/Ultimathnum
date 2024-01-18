//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Systems Integer
//*============================================================================*

/// A binary systems integer.
///
/// ### Trivial
///
/// Its bit pattern must represent its value. It may not use indirection.
///
/// - Requires: It must be bitwise copyable.
///
/// ### Bit Width
///
/// Non-power-of-two-bit-width integers are banned. Keep it simple.
///
/// - Requires: Its bit width must be a power of two.
///
/// - Requires: Its bit width must fit in a signed word (e.g. Swift.Int).
///
/// ### Magnitude
///
/// The magnitude must have the same bit width as this type. It then follows that
/// the magnitude must also be unsigned. This ensures that the type can represent
/// the minimum signed value's magnitude.
///
/// - Requires: Its magnitude must be unsigned and the same size as this type.
///
/// ### Development
///
/// Consider primitive static base methods that match stdlib operations:
///
/// ```swift
/// static func addition(_:_:) -> Overflow<Self>.Result
/// static func multiplication112(_:_:) -> Doublet<Self>
/// static func division2111(_:_:) -> Optional<Division<Self>>
/// ```
///
/// - Note: It is an alternative in case typed throws don't perform well.
///
public protocol SystemsInteger: BinaryInteger where Magnitude: UnsignedInteger & SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    /// The bit width of this type.
    ///
    /// ```
    /// ┌──────┬──────────┐
    /// │ type │ bitWidth │
    /// ├──────┼──────────┤
    /// │ I64  │ 64       │
    /// │ IXL  │ IX.max   │
    /// └──────┴──────────┘
    /// ```
    ///
    /// ### Development
    ///
    /// - TODO: Consider moving this to binary integer with typed throws.
    ///
    @inlinable static var bitWidth: Magnitude { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(load source: consuming UX)
    
    @inlinable init(load source: consuming Pattern<some RandomAccessCollection<UX>>)
    
    @inlinable func load(as type: UX.Type) -> UX
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - TODO: Consider moving this to binary integer with typed throws.
    ///
    @inlinable func count(_ bit: BitInt.Magnitude, option: BitInt.Selection) -> Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable static func  <<(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func  >>(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> Doublet<Self>
    
    /// ### Development
    ///
    /// - Consider throwing `Overflow<Void>`.
    ///
    @inlinable static func dividing(_ dividend: consuming Doublet<Self>, by multiplier: borrowing Self) throws -> Division<Self>
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var min: Self {
        isSigned ? msb : 0
    }
    
    @inlinable public static var max: Self {
        ~(min)
    }
    
    @inlinable public static var lsb: Self {
        Self(bitPattern: 1 as Magnitude)
    }
    
    @inlinable public static var msb: Self {
        Self(bitPattern: 1 as Magnitude &<< (bitWidth &- 1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - TODo: Consider adding this every binary integer.
    ///
    /// - TODo: Consider adding this every bit invertible integer.
    ///
    @inlinable public init(repeating bit: U1) {
        self = Bool(bitPattern: bit) ? ~0 : 0
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(clamping source: T) where T: Integer {
        let minus =  source < (0 as T)
        self = (try? Self(exactly: source)) ?? (minus ? Self.min : Self.max)
    }
    
    @inlinable public init<T>(truncating source: T) where T: Integer {
        self.init(load: Pattern(source.words, isSigned: T.isSigned))
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: BitCastable<UX.BitPattern> {
        T(bitPattern: self.load(as: UX.self))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(sign: consuming Sign, magnitude: consuming Magnitude) throws {
        var bitPattern = consume magnitude
        var isLessThanZero = sign == Sign.minus
        if  isLessThanZero {
            isLessThanZero = !Overflow.capture(&bitPattern, map:{ try (~$0).plus(1) })
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
}
