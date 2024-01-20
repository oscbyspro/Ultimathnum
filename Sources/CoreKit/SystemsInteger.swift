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
/// ### Words
///
/// - Requires: Its words collection view must have an identical memory layout.
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
public protocol SystemsInteger: BinaryInteger where Magnitude: SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(load source: consuming UX)
    
    @inlinable func load(as type: UX.Type) -> UX
    
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
    
    @inlinable public init<T>(clamping source: T) where T: Integer {
        brr: do {
            try self.init(exactly: source)
        }   catch {
            self = source < 0 as T ? Self.min : Self.max
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Words
//=----------------------------------------------------------------------------=

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: BitCastable<UX.BitPattern> {
        T(bitPattern: self.load(as: UX.self))
    }
    
    @inlinable public init<T>(load source: Pattern<T>) {
        if  Self.bitWidth <= Magnitude(load: UX(bitPattern: Swift.UInt.bitWidth)) {
            self.init(load:  source.load(as: UX.self))
        }   else {
            let minus = source.isLessThanZero
            self.init(repeating: U1(bitPattern: minus))
            var bitIndex: Self = 0000000000000000000000000000000
            let bitWidth: Self = Self(bitPattern: Self.bitWidth)
            var index = source.base.startIndex; while index < source.base.endIndex, bitIndex < bitWidth {
                let element = source.base[index]
                index = source.base.index(after: index)
                
                ((self)) = ((self)) ^ Self(load: minus ? ~element : element) &<< bitIndex
                bitIndex = bitIndex + Self(load: UX(bitPattern: Swift.UInt.bitWidth))
            }
        }
    }
}
