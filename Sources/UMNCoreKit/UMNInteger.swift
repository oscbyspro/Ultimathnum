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
    
    /// A representation that conforms to `Swift.BinaryInteger`.
    ///
    /// You may call `standard()` when you need to interoperate with Swift
    /// code that uses the standard library's protocol hierarchy.
    ///
    /// ```swift
    /// let  int:  Int = SX().standard()
    /// let uint: UInt = UX().standard()
    /// ```
    ///
    /// ### Motivation
    ///
    /// This associated type let us return standard libary types when possible.
    /// As such, we don't bloat the binary with redundant models or specialize
    /// functions for those models.
    ///
    /// ### Alternatives
    ///
    /// You can use `UMNStandardInt<Base>` for core integers too.
    ///
    associatedtype Standard: Swift.BinaryInteger
    
    associatedtype Magnitude: UMNBinaryInteger where Magnitude.Magnitude == Magnitude
    
    associatedtype Words: RandomAccessCollection & Sendable where Words.Element == UX, Words.Index == SX
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Complements
    //=------------------------------------------------------------------------=
        
    @inlinable consuming func standard() -> Standard
    
    @inlinable consuming func magnitude() -> Magnitude
    
    @inlinable consuming func words() -> Words
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func incremented(by addend: borrowing Self) -> UMNOverflow<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func decremented(by subtrahend: borrowing Self) -> UMNOverflow<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func squared() -> UMNOverflow<Self>
    
    @inlinable consuming func multiplied(by multiplier: borrowing Self) -> UMNOverflow<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation x Division
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func quotient (dividingBy divisor: borrowing Self) -> UMNOverflow<Self>
    
    @inlinable consuming func remainder(dividingBy divisor: borrowing Self) -> UMNOverflow<Self>
    
    @inlinable consuming func divided(by divisor: borrowing Self) -> UMNOverflow<UMNQuoRem<Self, Self>>
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension UMNInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable public static func +(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.incremented(by: rhs).unwrapped()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable public static func -(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.decremented(by: rhs).unwrapped()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable public static func *(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.multiplied(by: rhs).unwrapped()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Division
    //=------------------------------------------------------------------------=
    
    @inlinable public static func /(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.quotient (dividingBy: rhs).unwrapped()
    }
    
    @inlinable public static func %(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.remainder(dividingBy: rhs).unwrapped()
    }
}
