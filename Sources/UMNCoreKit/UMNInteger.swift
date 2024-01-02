//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Integer
//*============================================================================*

public protocol UMNInteger: Comparable, Hashable, ExpressibleByIntegerLiteral, Sendable {
    
    associatedtype Magnitude: UMNInteger where Magnitude.Magnitude == Magnitude
    
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
    @inlinable consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<UX>) -> T) -> T
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func incremented(by addend: borrowing Self) -> UMNOverflow<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func negated() -> UMNOverflow<Self>
    
    @inlinable consuming func decremented(by subtrahend: borrowing Self) -> UMNOverflow<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func squared() -> UMNOverflow<Self>
    
    @inlinable consuming func multiplied(by multiplier: borrowing Self) -> UMNOverflow<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Division
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func quotient ( divisor: borrowing Self) -> UMNOverflow<Self>
    
    @inlinable consuming func remainder( divisor: borrowing Self) -> UMNOverflow<Self>
    
    @inlinable consuming func divided(by divisor: borrowing Self) -> UMNOverflow<UMNQuoRem<Self, Self>>
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Comparisons
    //=------------------------------------------------------------------------=
        
    @inlinable borrowing func compared(to other: borrowing Self) -> UMNSignum
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension UMNInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() {
        self = 0
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
    // MARK: Utilities x Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable borrowing public func signum() -> UMNSignum {
        self.compared(to: 0)
    }
}
