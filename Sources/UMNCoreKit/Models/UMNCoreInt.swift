//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Core Int
//*============================================================================*

@frozen public struct UMNCoreInt<Base: UMNBaseInteger>: UMNSystemInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        Base.isSigned
    }
    
    @inlinable public static var bitWidth: Self {
        Self(Base(Base.bitWidth))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Base
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: consuming Base) {
        self.base = base
    }
        
    @inlinable public init(integerLiteral: consuming Base.IntegerLiteralType) {
        self.base =  .init(integerLiteral: integerLiteral)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var stdlib: Base {
        consuming get { self.base }
    }
    
    @inlinable public var bitPattern: Base.BitPattern {
        consuming get { self.base.bitPattern }
    }
    
    @inlinable public var magnitude: UMNCoreInt<Base.Magnitude> {
        consuming get { Magnitude(self.base.magnitude) }
    }
    
    @inlinable public consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<UX>) -> T) -> T {
        self.base.words.withContiguousStorageIfAvailable({ $0.withMemoryRebound(to: UX.self, body) })!
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public func count(_ bit: UMNBit, option: UMNBit.Selection) -> Self {
        switch (Bool(bit), option) {
        case (true,          .all): Self(Base(truncatingIfNeeded: ( self).base     .nonzeroBitCount))
        case (false,         .all): Self(Base(truncatingIfNeeded: (~self).base     .nonzeroBitCount))
        case (true,    .ascending): Self(Base(truncatingIfNeeded: (~self).base.trailingZeroBitCount))
        case (false,   .ascending): Self(Base(truncatingIfNeeded: ( self).base.trailingZeroBitCount))
        case (true,   .descending): Self(Base(truncatingIfNeeded: (~self).base .leadingZeroBitCount))
        case (false,  .descending): Self(Base(truncatingIfNeeded: ( self).base .leadingZeroBitCount))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func incremented(by increment: borrowing Self) -> UMNOverflow<Self> {
        let result = self.base.addingReportingOverflow(increment.base)
        return UMNOverflow(Self(result.partialValue), overflow: result.overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> UMNOverflow<Self> {
        let result = (~self).incremented(by: 1)
        return UMNOverflow(result.value, overflow: result.overflow != Self.isSigned)
    }
    
    @inlinable public consuming func decremented(by decrement: borrowing Self) -> UMNOverflow<Self> {
        let result = self.base.subtractingReportingOverflow(decrement.base)
        return UMNOverflow(Self(result.partialValue), overflow: result.overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func squared() -> UMNOverflow<Self> {
        self.multiplied(by: copy self)
    }
    
    @inlinable public consuming func multiplied(by multiplier: borrowing Self) -> UMNOverflow<Self> {
        let result = self.base.multipliedReportingOverflow(by: multiplier.base)
        return UMNOverflow(Self(result.partialValue), overflow: result.overflow)
    }
    
    @inlinable public static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> UMNFullWidth<Self, Magnitude> {
        let result = multiplicand.base.multipliedFullWidth(by: multiplier.base)
        return UMNFullWidth(high: Self(result.high), low: Magnitude(result.low))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Division
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(divisor: borrowing Self) -> UMNOverflow<Self> {
        let result = self.base.dividedReportingOverflow(by: divisor.base)
        return UMNOverflow(Self(result.partialValue), overflow: result.overflow)
    }
    
    @inlinable public consuming func remainder(divisor: borrowing Self) -> UMNOverflow<Self> {
        let result = self.base.remainderReportingOverflow(dividingBy: divisor.base)
        return UMNOverflow(Self(result.partialValue), overflow: result.overflow)
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Self) -> UMNOverflow<UMNQuoRem<Self, Self>> {
        let quotient  = (copy    self).quotient (divisor: divisor)
        let remainder = (consume self).remainder(divisor: divisor)
        let overflow  = quotient.overflow || remainder.overflow
        return UMNOverflow(UMNQuoRem(quotient: quotient.value, remainder: remainder.value), overflow: overflow)
    }
    
    @inlinable public static func dividing(_ dividend: consuming UMNFullWidth<Self, Magnitude>, by divisor: borrowing Self) -> UMNOverflow<UMNQuoRem<Self, Self>> {
        fatalError("TOOD")
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
        Self(lhs.base  << rhs.base)
    }
    
    @inlinable static public func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base &<< rhs.base)
    }
    
    @inlinable static public func  >>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base  >> rhs.base)
    }
    
    @inlinable static public func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base &>> rhs.base)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable public func compared(to other: Self) -> UMNSignum {
        self < other ? .less : self == other ? .same : .more
    }
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.base == rhs.base
    }
    
    @inlinable public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.base <  rhs.base
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conditional Conformances
//=----------------------------------------------------------------------------=

extension UMNCoreInt:   UMNSignedInteger where Base: Swift  .SignedInteger  { }
extension UMNCoreInt: UMNUnsignedInteger where Base: Swift.UnsignedInteger, Base.Magnitude == Base { }

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

public typealias IX  = UMNCoreInt<Swift.Int>
public typealias I8  = UMNCoreInt<Swift.Int8>
public typealias I16 = UMNCoreInt<Swift.Int16>
public typealias I32 = UMNCoreInt<Swift.Int32>
public typealias I64 = UMNCoreInt<Swift.Int64>

public typealias UX  = UMNCoreInt<Swift.UInt>
public typealias U8  = UMNCoreInt<Swift.UInt8>
public typealias U16 = UMNCoreInt<Swift.UInt16>
public typealias U32 = UMNCoreInt<Swift.UInt32>
public typealias U64 = UMNCoreInt<Swift.UInt64>
