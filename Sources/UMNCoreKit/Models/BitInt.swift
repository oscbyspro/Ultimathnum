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
@frozen public struct BitInt: SystemInteger & UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var bitWidth: Self {
        1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Bit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Bit) {
        self.base = base
    }
    
    @inlinable public init(integerLiteral: UInt.IntegerLiteralType) {
        if  integerLiteral == 0 {
            self.base = 0
        }   else if integerLiteral == 1 {
            self.base = 1
        }   else {
            fatalError(UMN.callsiteOverflowInfo())
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public func count(_ bit: Bit, option: Bit.Selection) -> Self {
        if bit == 0 { ~self } else { self }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func incremented(by increment: borrowing Self) -> Overflow<Self> {
        Overflow(Self(self.base ^ increment.base), overflow: self & increment == 1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> Overflow<Self> {
        (0 as Self).decremented(by: 1)
    }
    
    @inlinable public consuming func decremented(by decrement: borrowing Self) -> Overflow<Self> {
        Overflow(Self(self.base ^ decrement.base), overflow: self < decrement)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func squared() -> Overflow<Self> {
        Overflow(self, overflow: false)
    }
    
    @inlinable public consuming func multiplied(by multiplier: borrowing Self) -> Overflow<Self> {
        Overflow(self & multiplier, overflow: false)
    }
    
    @inlinable public static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> FullWidth<Self, Magnitude> {
        FullWidth(low: multiplicand & multiplier, high: 0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Division
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(divisor: borrowing Self) -> Overflow<Self> {
        Overflow(self, overflow: divisor == 0)
    }
    
    @inlinable public consuming func remainder(divisor: borrowing Self) -> Overflow<Self> {
        Overflow(Self(Bit(self > divisor)), overflow: divisor == 0)
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Self) -> Overflow<QuoRem<Self, Self>> {
        Overflow(QuoRem(quotient: self, remainder: Self(Bit(self > divisor))), overflow: divisor == 0)
    }
    
    @inlinable public static func dividing(_ dividend: consuming FullWidth<Self, Magnitude>, by divisor: borrowing Self) -> Overflow<QuoRem<Self, Self>> {
        Overflow(QuoRem(quotient: dividend.low, remainder: dividend.low & divisor), overflow: divisor == 0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Logic
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(operand: consuming Self) -> Self {
        Self(~operand.base)
    }
    
    @inlinable public static func &(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base & rhs.base)
    }
    
    @inlinable public static func |(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base | rhs.base)
    }
    
    @inlinable public static func ^(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base ^ rhs.base)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Shifts
    //=------------------------------------------------------------------------=
    
    @inlinable static public func  <<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        rhs == 0 ? 0 : lhs
    }
    
    @inlinable static public func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs
    }
    
    @inlinable static public func  >>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        rhs == 0 ? 0 : lhs
    }
    
    @inlinable static public func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable public func compared(to other: Self) -> Signum {
        self == other ? 0 : self < other ? -1 : 1
    }
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.base == rhs.base
    }
    
    @inlinable public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        (lhs, rhs) == (0, 1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Words
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<UX>) -> T) -> T {
        UMN.withUnsafeTemporaryAllocation(of: UX.self) { pointer in
            pointer.initialize(to: UX(self.base))
            
            defer {
                pointer.deinitialize(count: 1)
            }
            
            return body(UnsafeBufferPointer(start: pointer, count: 1))
        }
    }
}
