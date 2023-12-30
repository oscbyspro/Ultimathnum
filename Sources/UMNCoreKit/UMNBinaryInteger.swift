//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Binary Integer
//*============================================================================*

public protocol UMNBinaryInteger: Comparable, Hashable, ExpressibleByIntegerLiteral, Sendable {
        
    associatedtype Standard: Swift.BinaryInteger
    
    associatedtype Magnitude: UMNBinaryInteger where Magnitude.Magnitude == Magnitude
    
    associatedtype Words: RandomAccessCollection & Sendable where Words.Element == UX, Words.Index == SX
        
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable static var isSigned: Bool { get }
    
    @inlinable static var zero: Self { get }
    
    @inlinable static var one:  Self { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Complements
    //=------------------------------------------------------------------------=
        
    @inlinable consuming func standard() -> Standard
    
    @inlinable consuming func magnitude() -> Magnitude
    
    @inlinable consuming func onesComplement() -> Self
    
    @inlinable consuming func twosComplement() -> UMNOverflow<Self>
    
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

extension UMNBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() {
        self = Self.zero
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Complements
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func -(x: consuming Self) -> Self {
        x.twosComplement().unwrapped()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable public static func +(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.incremented(by: rhs).unwrapped()
    }
    
    @inlinable public static func &+(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.incremented(by: rhs).value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable public static func -(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.decremented(by: rhs).unwrapped()
    }
    
    @inlinable public static func &-(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.decremented(by: rhs).value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable public static func *(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.multiplied(by: rhs).unwrapped()
    }
    
    @inlinable public static func &*(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.multiplied(by: rhs).value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Division
    //=------------------------------------------------------------------------=
    
    @inlinable public static func /(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.quotient(dividingBy: rhs).unwrapped()
    }
    
    @inlinable public static func %(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.remainder(dividingBy: rhs).unwrapped()
    }
}
