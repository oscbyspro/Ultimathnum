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
public protocol Integer: Comparable, ExpressibleByIntegerLiteral, Hashable, Sendable, _MaybeLosslessStringConvertible {
    
    associatedtype Words: RandomAccessCollection<UX>
    
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
    
    @inlinable init(words: consuming some RandomAccessCollection<UX>, isSigned: consuming Bool) throws
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func plus(_ increment: borrowing Self) throws -> Self
    
    @inlinable consuming func negated() throws -> Self
    
    @inlinable consuming func minus(_ decrement: borrowing Self) throws -> Self
    
    @inlinable consuming func squared() throws -> Self
    
    @inlinable consuming func times(_ multiplier: borrowing Self) throws -> Self
    
    @inlinable consuming func quotient ( divisor: borrowing Self) throws -> Self
    
    @inlinable consuming func remainder( divisor: borrowing Self) throws -> Self
    
    @inlinable consuming func divided(by divisor: borrowing Self) throws -> Division<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable var magnitude: Magnitude { consuming get }
    
    @inlinable var words: Words { consuming get }
    
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
    
    @inlinable public init(words: consuming some RandomAccessCollection<UX>) throws {
        try  self.init(words: consume words, isSigned: Self.isSigned)
    }
    
    @inlinable public init<T>(_ source: T) where T: Integer {
        try! self.init(exactly: source)
    }
    
    @inlinable public init<T>(exactly source: T) throws where T: Integer {
        try  self.init(words: source.words, isSigned: T.isSigned)
    }
    
    @inlinable public init(literally source: StaticBigInt) throws {
        try  self.init(words: BigIntLiteral(source), isSigned: true)
    }
    
    @inlinable public init(integerLiteral: IntegerLiteralType) where IntegerLiteralType == StaticBigInt {
        try! self.init(literally: integerLiteral)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func +(lhs: consuming Self, rhs: borrowing Self) -> Self {
        try! lhs.plus(rhs)
    }
    
    @inlinable public static prefix func -(instance: Self) -> Self {
        try! instance.negated()
    }
    
    @inlinable public static func -(lhs: consuming Self, rhs: borrowing Self) -> Self {
        try! lhs.minus(rhs)
    }
    
    @inlinable public static func *(lhs: consuming Self, rhs: borrowing Self) -> Self {
        try! lhs.times(rhs)
    }
    
    @inlinable public static func /(lhs: consuming Self, rhs: borrowing Self) -> Self {
        try! lhs.quotient (divisor: rhs)
    }
    
    @inlinable public static func %(lhs: consuming Self, rhs: borrowing Self) -> Self {
        try! lhs.remainder(divisor: rhs)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func signum() -> Signum {
        self.compared(to: 0)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Lossless String Convertible
//=----------------------------------------------------------------------------=
// TODO: @_unavailableInEmbedded is not a known attribute in Swift 5.9
//=----------------------------------------------------------------------------=

/* @_unavailableInEmbedded */ extension Integer {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ description: String) {
        if let value: Self = try? IDF.Decoder().decode(description) { self = value } else { return nil }
    }
    
    @inlinable public var description: String {
        IDF.Encoder().encode(self)
    }
}
