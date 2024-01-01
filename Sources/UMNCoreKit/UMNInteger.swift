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
    
    associatedtype Magnitude: UMNBinaryInteger where Magnitude.Magnitude == Magnitude
    
    /// A representation that conforms to `Swift.BinaryInteger`.
    ///
    /// You may call `stdlib` to interoperate with code using the standard
    /// library's protocol hierarchy.
    ///
    /// ```swift
    /// let  int:  Int = SX().stdlib
    /// let uint: UInt = UX().stdlib
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
    /// You can use `UMNStdlibInt<Base>` with core integers too.
    ///
    associatedtype Stdlib: Swift.BinaryInteger
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var magnitude: Magnitude { consuming get }
    
    @inlinable var stdlib: Stdlib { consuming get }
    
    /// ### Development
    ///
    /// - TODO: Make this a buffer view at some point.
    ///
    @inlinable consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<UX>) -> T) -> T
    
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
