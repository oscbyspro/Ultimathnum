//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Bit Int
//*============================================================================*

/// An unsigned `1-bit` integer that can represent the values `0` and `1`.
@frozen public struct UMNBitInt: UMNSystemInteger & UMNUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var bitWidth: Self {
        1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(booleanLiteral: Bool.BooleanLiteralType) {
        switch booleanLiteral {
        case  true: self.base = true
        case false: self.base = false
        }
    }
    
    @inlinable public init(integerLiteral: consuming Int.IntegerLiteralType) {
        switch integerLiteral {
        case 01: self.base = true
        case 00: self.base = false
        default: fatalError("invalid bit integer literal value")
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<UX>) -> T) -> T {
        UMN.withUnsafeTemporaryAllocation(of: UX.self, count: 1) {
            body(UnsafeBufferPointer($0))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public func count(_ bit: Bool, option: UMNBitOption) -> Self {
        switch bit { case true: self; case false: ~self }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func incremented(by increment: borrowing Self) -> UMNOverflow<Self> {
        UMNOverflow(Self(self != increment), overflow:(self & increment).base)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> UMNOverflow<Self> {
        (0 as Self).decremented(by: 1)
    }
    
    @inlinable public consuming func decremented(by decrement: borrowing Self) -> UMNOverflow<Self> {
        UMNOverflow(Self(self != decrement), overflow: self < decrement)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func squared() -> UMNOverflow<Self> {
        UMNOverflow(self, overflow: false)
    }
    
    @inlinable public consuming func multiplied(by multiplier: borrowing Self) -> UMNOverflow<Self> {
        UMNOverflow(self & multiplier, overflow: false)
    }
    
    @inlinable public static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> UMNFullWidth<Self, Magnitude> {
        UMNFullWidth(low: multiplicand & multiplier, high: 0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Division
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(divisor: borrowing Self) -> UMNOverflow<Self> {
        UMNOverflow(self, overflow: !divisor.base)
    }
    
    @inlinable public consuming func remainder(divisor: borrowing Self) -> UMNOverflow<Self> {
        UMNOverflow(Self(self > divisor), overflow: !divisor.base)
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Self) -> UMNOverflow<UMNQuoRem<Self, Self>> {
        UMNOverflow(UMNQuoRem(quotient: self, remainder: Self(self > divisor)), overflow: !divisor.base)
    }
    
    @inlinable public static func dividing(_ dividend: consuming UMNFullWidth<Self, Magnitude>, by divisor: borrowing Self) -> UMNOverflow<UMNQuoRem<Self, Self>> {
        UMNOverflow(UMNQuoRem(quotient: dividend.low, remainder: dividend.low & divisor), overflow: !divisor.base)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Logic
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(operand: consuming Self) -> Self {
        switch operand.base { case true: 0; case false: 1 }
    }
    
    @inlinable public static func &(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs == rhs ? lhs : 0
    }
    
    @inlinable public static func |(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs == 0 ? rhs : lhs
    }
    
    @inlinable public static func ^(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs == rhs ? 0 : 1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Shifts
    //=------------------------------------------------------------------------=
    
    @inlinable static public func  <<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        rhs.base ? 0 : lhs
    }
    
    @inlinable static public func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs
    }
    
    @inlinable static public func  >>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        rhs.base ? 0 : lhs
    }
    
    @inlinable static public func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable public func compared(to other: Self) -> UMNSignum {
        self == other ? 0 : self < other ? -1 : 1
    }
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.base == rhs.base
    }
    
    @inlinable public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        (lhs, rhs) == (0, 1)
    }
}
