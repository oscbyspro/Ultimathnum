//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * System Integer
//*============================================================================*

/// A binary system integer.
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
public protocol SystemInteger: BinaryInteger, BitCastable, BitOperable where
Magnitude: UnsignedInteger & SystemInteger, Magnitude.BitPattern == BitPattern {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable static var bitWidth: Magnitude { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(load source: consuming Word)
    
    @inlinable init(load source: consuming Pattern<some RandomAccessCollection<Word>>)
    
    @inlinable func load(as type: Word.Type) -> Word
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable func count(_ bit: Bit, option: Bit.Selection) -> Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Shift
    //=------------------------------------------------------------------------=
    
    @inlinable static func  <<(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func  >>(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    @inlinable static func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Multiplication, Division
    //=------------------------------------------------------------------------=
    
    @inlinable static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> Doublet<Self>
    
    @inlinable static func dividing(_ dividend: consuming Doublet<Self>, by multiplier: borrowing Self) throws -> Division<Self>
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension SystemInteger {
    
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
    
    @inlinable public init<T>(clamping source: T) where T: Integer {
        let minus =  source.isLessThanZero
        self = (try? Self(exactly: source)) ?? (minus ? Self.min : Self.max)
    }
    
    @inlinable public init<T>(truncating source: T) where T: Integer {
        self.init(load: Pattern(source.words, isSigned: T.isSigned))
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: BitCastable<Word.BitPattern> {
        T(bitPattern: self.load(as: Word.self))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(sign: consuming Sign, magnitude: consuming Magnitude) throws {
        var bitPattern = consume magnitude
        var isLessThanZero = sign == Sign.minus
        if  isLessThanZero {
            (bitPattern, isLessThanZero) = Overflow.capture({ try bitPattern.negated() }).components
        }
                
        self.init(bitPattern: consume bitPattern)
        if  self.isLessThanZero != isLessThanZero {
            throw Overflow(consume self)
        }
    }
    
    @inlinable public init(words: consuming some RandomAccessCollection<Word>, isSigned: consuming Bool) throws {
        let pattern = Pattern(words, isSigned: isSigned)
        self.init(load: pattern)
        
        // TODO: clean up and add a comprehensive test suite
        
        let value   = self.words
        let success = self.isLessThanZero == pattern.isLessThanZero &&
        value.last == pattern.base.dropFirst(value.count - 1).first &&
        pattern.base.dropFirst(value.count).allSatisfy({ $0 == pattern.sign })
        
        if !success {
            throw Overflow(consume self)
        }
    }
}
