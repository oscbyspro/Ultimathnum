//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Integer
//*============================================================================*

/// An integer type.
///
/// ### Zero
///
/// - Requires: Zero must be representable.
///
public protocol Integer: Comparable, ExpressibleByIntegerLiteral, Hashable, Sendable {
    
    associatedtype Words: RandomAccessCollection<Word>
    
    associatedtype Magnitude: Integer where Magnitude.Magnitude == Magnitude
    
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
    /// │ S1   │ true     │ -1  │   1 │
    /// │ U1   │ false    │  0  │  -1 │
    /// └──────┴──────────┴─────┴─────┘
    /// ```
    ///
    @inlinable static var isSigned: Bool { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(sign:  consuming Sign, magnitude: consuming Magnitude) throws
    
    @inlinable init(words: consuming some RandomAccessCollection<Word>, isSigned: consuming Bool) throws
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var magnitude: Magnitude { consuming get }
    
    @inlinable var words: Words { consuming get }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func plus(_ increment: borrowing Self) throws -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func negated() throws -> Self
    
    @inlinable consuming func minus(_ decrement: borrowing Self) throws -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func squared() throws -> Self
    
    @inlinable consuming func times(_ multiplier: borrowing Self) throws -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Division
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func quotient ( divisor: borrowing Self) throws -> Self
    
    @inlinable consuming func remainder( divisor: borrowing Self) throws -> Self
    
    @inlinable consuming func divided(by divisor: borrowing Self) throws -> Division<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Comparison
    //=------------------------------------------------------------------------=
        
    @inlinable borrowing func compared(to other: borrowing Self) -> Signum
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Integer {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() {
        self = 0
    }
        
    @inlinable public init(magnitude: consuming Magnitude) throws {
        try  self.init(sign: Sign.plus, magnitude: consume magnitude)
    }
    
    @inlinable public init(words: consuming some RandomAccessCollection<Word>) throws {
        try  self.init(words: consume words, isSigned: Self.isSigned)
    }
    
    @inlinable public init<T>(_ source: T) where T: Integer {
        try! self.init(exactly: source)
    }
    
    @inlinable public init<T>(exactly source: T) throws where T: Integer {
        try  self.init(words: source.words, isSigned: T.isSigned)
    }
    
    @inlinable public init(literally source: StaticBigInt) throws {
        try  self.init(words: BitCastSequence(StaticBigIntWords(source)), isSigned: true)
    }
    
    @inlinable public init(integerLiteral: IntegerLiteralType) where IntegerLiteralType == StaticBigInt {
        try! self.init(literally: integerLiteral)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable public static func +(lhs: consuming Self, rhs: borrowing Self) -> Self {
        try! lhs.plus(rhs)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func -(operand: Self) -> Self {
        try! operand.negated()
    }
    
    @inlinable public static func -(lhs: consuming Self, rhs: borrowing Self) -> Self {
        try! lhs.minus(rhs)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable public static func *(lhs: consuming Self, rhs: borrowing Self) -> Self {
        try! lhs.times(rhs)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Division
    //=------------------------------------------------------------------------=
    
    @inlinable public static func /(lhs: consuming Self, rhs: borrowing Self) -> Self {
        try! lhs.quotient (divisor: rhs)
    }
    
    @inlinable public static func %(lhs: consuming Self, rhs: borrowing Self) -> Self {
        try! lhs.remainder(divisor: rhs)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Comparison
    //=------------------------------------------------------------------------=
    
    /// Returns whether this value is less than zero.
    ///
    /// It checks `isSigned` first which is preferred in inlinable generic code.
    ///
    @inlinable public var isLessThanZero: Bool {
        Self.isSigned &&  self < 0
    }
    
    @inlinable public borrowing func signum() -> Signum {
        self.compared(to: 0)
    }
}
