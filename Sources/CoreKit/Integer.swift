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

public protocol Integer: Comparable, ExpressibleByIntegerLiteral, Hashable, Sendable {
    
    associatedtype Magnitude: Integer where Magnitude.Magnitude == Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable static var isSigned: Bool { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var magnitude: Magnitude { consuming get }
        
    /// Its un/signed two's complement words.
    ///
    /// The format is indicated by `isSigned`.
    ///
    /// ### Development
    ///
    /// - TODO: Make this a buffer view at some point.
    ///
    @inlinable consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<Word>) throws -> T) rethrows -> T
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func incremented(by increment: borrowing Self) -> Overflow<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func negated() -> Overflow<Self>
    
    @inlinable consuming func decremented(by decrement: borrowing Self) -> Overflow<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func squared() -> Overflow<Self>
    
    @inlinable consuming func multiplied(by multiplier: borrowing Self) -> Overflow<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Division
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func quotient ( divisor: borrowing Self) -> Overflow<Self>
    
    @inlinable consuming func remainder( divisor: borrowing Self) -> Overflow<Self>
    
    @inlinable consuming func divided(by divisor: borrowing Self) -> Overflow<Division<Self>>
    
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
    
    @inlinable public init(_ source: some Integer) {
        fatalError("TODO")
    }
    
    @inlinable public init(exactly source: some Integer) throws {
        fatalError("TODO")
    }
    
    @inlinable public init(clamping source: some Integer) {
        fatalError("TODO")
    }
    
    @inlinable public init(truncating source: some Integer) {
        fatalError("TODO")
    }
    
    @inlinable public init(stdlib source: some Swift.BinaryInteger) {
        fatalError("TODO")
    }
    
    @inlinable public init(sign: Sign, magnitude: Magnitude) throws {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable public static func +(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.incremented(by: rhs).unwrapped()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func -(operand: Self) -> Self {
        operand.negated().unwrapped()
    }
    
    @inlinable public static func -(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.decremented(by: rhs).unwrapped()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable public static func *(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.multiplied(by: rhs).unwrapped()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Division
    //=------------------------------------------------------------------------=
    
    @inlinable public static func /(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.quotient (divisor: rhs).unwrapped()
    }
    
    @inlinable public static func %(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.remainder(divisor: rhs).unwrapped()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Comparison
    //=------------------------------------------------------------------------=
    
    @inlinable borrowing public func signum() -> Signum {
        self.compared(to: 0)
    }
}
