//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Int
//*============================================================================*

/// A signed `1-bit` integer that can represent the values `0` and `-1`.
@frozen public struct BitInt: SystemInteger & SignedInteger {
    
    public typealias BitPattern = Bit
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var bitWidth: Magnitude {
        1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let bitPattern: Bit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Bit) {
        self.bitPattern = (bitPattern)
    }
    
    @inlinable public init(integerLiteral: Int.IntegerLiteralType) {
        if  integerLiteral == 0 {
            self.bitPattern = 0
        }   else if integerLiteral == -1 {
            self.bitPattern = 1
        }   else {
            fatalError(.overflow())
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var magnitude: Magnitude {
        consuming get {
            Magnitude(bitPattern: self.bitPattern)
        }
    }
    
    //*========================================================================*
    // MARK: * Magnitude
    //*========================================================================*
    
    /// An unsigned `1-bit` integer that can represent the values `0` and `1`.
    @frozen public struct Magnitude: SystemInteger & UnsignedInteger {
        
        //=--------------------------------------------------------------------=
        // MARK: Meta Data
        //=--------------------------------------------------------------------=
        
        @inlinable public static var bitWidth: Magnitude {
            1
        }
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let bitPattern: Bit
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(bitPattern: Bit) {
            self.bitPattern = (bitPattern)
        }
        
        @inlinable public init(integerLiteral: UInt.IntegerLiteralType) {
            if  integerLiteral == 0 {
                self.bitPattern = 0
            }   else if integerLiteral == 1 {
                self.bitPattern = 1
            }   else {
                fatalError(.overflow())
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Signed
//=----------------------------------------------------------------------------=

extension BitInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public func count(_ bit: Bit, option: Bit.Selection) -> Magnitude {
        self.magnitude.count(bit, option: option)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func incremented(by increment: borrowing Self) -> Overflow<Self> {
        Overflow(Self(bitPattern: (copy self).bitPattern ^ increment.bitPattern), overflow: self & increment != 0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> Overflow<Self> {
        Overflow(self, overflow: self != 0)
    }
    
    @inlinable public consuming func decremented(by decrement: borrowing Self) -> Overflow<Self> {
        Overflow(Self(bitPattern: (copy self).bitPattern ^ decrement.bitPattern), overflow: self > decrement)
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
        FullWidth(low: Magnitude(bitPattern: multiplicand & multiplier), high: 0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Division
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(divisor: borrowing Self) -> Overflow<Self> {
        Overflow(self, overflow: divisor == 0)
    }
    
    @inlinable public consuming func remainder(divisor: borrowing Self) -> Overflow<Self> {
        Overflow(Self(bitPattern: Bit(self > divisor)), overflow: divisor == 0)
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Self) -> Overflow<Division<Self>> {
        Overflow(Division(quotient: self, remainder: Self(bitPattern: Bit(self > divisor))), overflow: divisor == 0)
    }
    
    @inlinable public static func dividing(_ dividend: consuming FullWidth<Self, Magnitude>, by divisor: borrowing Self) -> Overflow<Division<Self>> {
        Overflow(Division(quotient: Self(bitPattern: dividend.low), remainder: Self(bitPattern: dividend.low) & divisor), overflow: divisor == 0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Logic
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(operand: consuming Self) -> Self {
        Self(bitPattern: ~operand.bitPattern)
    }
    
    @inlinable public static func &(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(bitPattern: lhs.bitPattern & rhs.bitPattern)
    }
    
    @inlinable public static func |(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(bitPattern: lhs.bitPattern | rhs.bitPattern)
    }
    
    @inlinable public static func ^(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(bitPattern: lhs.bitPattern ^ rhs.bitPattern)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Shift
    //=------------------------------------------------------------------------=
    
    @inlinable public static func  <<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        rhs == 0 ? lhs : 0
    }
    
    @inlinable public static func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs
    }
    
    @inlinable public static func  >>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs
    }
    
    @inlinable public static func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Comparison
    //=------------------------------------------------------------------------=
    
    @inlinable public func compared(to other: Self) -> Signum {
        self == other ? 0 : self < other ? -1 : 1
    }
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.bitPattern == rhs.bitPattern
    }
    
    @inlinable public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        (lhs.bitPattern, rhs.bitPattern) == (1, 0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Words
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<UX>) -> T) -> T {
        UMN.withUnsafeTemporaryAllocation(of: UX.self) { pointer in
            pointer.initialize(to: UX(repeating: self.bitPattern))
            
            defer {
                pointer.deinitialize(count: 1)
            }
            
            return body(UnsafeBufferPointer(start: pointer, count: 1))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension BitInt.Magnitude {
        
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
        Overflow(Self(bitPattern: (copy self).bitPattern ^ increment.bitPattern), overflow: self & increment != 0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> Overflow<Self> {
        Overflow(self, overflow: self != 0)
    }
    
    @inlinable public consuming func decremented(by decrement: borrowing Self) -> Overflow<Self> {
        Overflow(Self(bitPattern: (copy self).bitPattern ^ decrement.bitPattern), overflow: self < decrement)
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
        FullWidth(low: Magnitude(bitPattern: multiplicand & multiplier), high: 0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Division
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(divisor: borrowing Self) -> Overflow<Self> {
        Overflow(self, overflow: divisor == 0)
    }
    
    @inlinable public consuming func remainder(divisor: borrowing Self) -> Overflow<Self> {
        Overflow(Self(bitPattern: Bit(self > divisor)), overflow: divisor == 0)
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Self) -> Overflow<Division<Self>> {
        Overflow(Division(quotient: self, remainder: Self(bitPattern: Bit(self > divisor))), overflow: divisor == 0)
    }
    
    @inlinable public static func dividing(_ dividend: consuming FullWidth<Self, Magnitude>, by divisor: borrowing Self) -> Overflow<Division<Self>> {
        Overflow(Division(quotient: Self(bitPattern: dividend.low), remainder: Self(bitPattern: dividend.low) & divisor), overflow: divisor == 0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Logic
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(operand: consuming Self) -> Self {
        Self(bitPattern: ~operand.bitPattern)
    }
    
    @inlinable public static func &(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(bitPattern: lhs.bitPattern & rhs.bitPattern)
    }
    
    @inlinable public static func |(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(bitPattern: lhs.bitPattern | rhs.bitPattern)
    }
    
    @inlinable public static func ^(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(bitPattern: lhs.bitPattern ^ rhs.bitPattern)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Shift
    //=------------------------------------------------------------------------=
    
    @inlinable public static func  <<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        rhs == 0 ? lhs : 0
    }
    
    @inlinable public static func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs
    }
    
    @inlinable public static func  >>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        rhs == 0 ? lhs : 0
    }
    
    @inlinable public static func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Comparison
    //=------------------------------------------------------------------------=
    
    @inlinable public func compared(to other: Self) -> Signum {
        self == other ? 0 : self < other ? -1 : 1
    }
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.bitPattern == rhs.bitPattern
    }
    
    @inlinable public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        (lhs.bitPattern, rhs.bitPattern) == (0, 1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Words
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<UX>) -> T) -> T {
        UMN.withUnsafeTemporaryAllocation(of: UX.self) { pointer in
            pointer.initialize(to: self.bitPattern == 0 ? 0 : 1)
            
            defer {
                pointer.deinitialize(count: 1)
            }
            
            return body(UnsafeBufferPointer(start: pointer, count: 1))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

public typealias I1 = BitInt
public typealias U1 = BitInt.Magnitude
