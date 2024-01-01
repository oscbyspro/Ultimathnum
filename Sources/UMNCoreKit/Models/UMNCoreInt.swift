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

@frozen public struct UMNCoreInt<Base: UMNBaseInteger>: UMNCoreInteger {
    
    public typealias Base = Base
    
    public typealias BitPattern = Base.BitPattern
    
    public typealias Magnitude = UMNCoreInt<Base.Magnitude>
    
    public typealias Stdlib = Base
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        Base.isSigned
    }
    
    @inlinable public static var bitWidth: Self {
        fatalError("TODO")
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
        self.base = Base(integerLiteral: integerLiteral)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var bitPattern: BitPattern {
        consuming get { self.base.bitPattern }
    }
    
    @inlinable public var magnitude: Magnitude {
        consuming get { Magnitude(self.base.magnitude) }
    }
    
    @inlinable public var stdlib: Stdlib {
        consuming get { self.base }
    }
    
    @inlinable public consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<UX>) -> T) -> T {
        self.base.words.withContiguousStorageIfAvailable({ $0.withMemoryRebound(to: UX.self, body) })!
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Complements
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func onesComplement() -> Self {
        Self(~self.base)
    }
    
    @inlinable public consuming func twosComplement() -> UMNOverflow<Self> {
        self.onesComplement().incremented(by: 1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func incremented(by addend: borrowing Self) -> UMNOverflow<Self> {
        let result = self.base.addingReportingOverflow(addend.base)
        return UMNOverflow(Self(result.partialValue), overflow: result.overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> UMNOverflow<Self> where Self: UMNSigned {
        self.twosComplement() // this works because the integer is signed
    }
    
    @inlinable public consuming func decremented(by subtrahend: borrowing Self) -> UMNOverflow<Self> {
        let result = self.base.subtractingReportingOverflow(subtrahend.base)
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
    
    @inlinable public consuming func quotient(dividingBy divisor: borrowing Self) -> UMNOverflow<Self> {
        let result = self.base.dividedReportingOverflow(by: divisor.base)
        return UMNOverflow(Self(result.partialValue), overflow: result.overflow)
    }
    
    @inlinable public consuming func remainder(dividingBy divisor: borrowing Self) -> UMNOverflow<Self> {
        let result = self.base.remainderReportingOverflow(dividingBy: divisor.base)
        return UMNOverflow(Self(result.partialValue), overflow: result.overflow)
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Self) -> UMNOverflow<UMNQuoRem<Self, Self>> {
        let quotient  = (copy    self).quotient (dividingBy: divisor)
        let remainder = (consume self).remainder(dividingBy: divisor)
        let overflow  = quotient.overflow || remainder.overflow
        return UMNOverflow(UMNQuoRem(quotient: quotient.value, remainder: remainder.value), overflow: overflow)
    }
    
    @inlinable public static func dividing(_ dividend: consuming UMNFullWidth<Self, Magnitude>, by divisor: borrowing Self) -> UMNOverflow<UMNQuoRem<Self, Self>> {
        fatalError("TOOD")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
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

extension UMNCoreInt:   UMNSigned where Base: Swift  .SignedInteger { }
extension UMNCoreInt: UMNUnsigned where Base: Swift.UnsignedInteger { }

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

public typealias SX  = UMNCoreInt<Swift.Int>
public typealias S8  = UMNCoreInt<Swift.Int8>
public typealias S16 = UMNCoreInt<Swift.Int16>
public typealias S32 = UMNCoreInt<Swift.Int32>
public typealias S64 = UMNCoreInt<Swift.Int64>

public typealias UX  = UMNCoreInt<Swift.UInt>
public typealias U8  = UMNCoreInt<Swift.UInt8>
public typealias U16 = UMNCoreInt<Swift.UInt16>
public typealias U32 = UMNCoreInt<Swift.UInt32>
public typealias U64 = UMNCoreInt<Swift.UInt64>
