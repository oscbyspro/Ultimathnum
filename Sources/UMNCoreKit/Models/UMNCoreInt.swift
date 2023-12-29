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

@frozen public struct UMNCoreInt<Base: UMNCoreInteger>: UMNFixedWidthInteger {
    
    public typealias Words = [UInt]
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        Base.isSigned
    }
    
    @inlinable public static var zero: Self {
        0 as Self
    }
    
    @inlinable public static var one:  Self {
        1 as Self
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
    // MARK: Transformations x Complements
    //=------------------------------------------------------------------------=
    
    @inlinable consuming public func bitPattern() -> Base.BitPattern {
        self.base.bitPattern()
    }
    
    @inlinable consuming public func magnitude() -> UMNCoreInt<Base.Magnitude> {
        fatalError("TODO")
    }
    
    @inlinable consuming public func onesComplement() -> Self {
        fatalError("TODO")
    }
    
    @inlinable consuming public func twosComplement() -> UMNOverflow<Self> {
        fatalError("TODO")
    }
    
    @inlinable consuming public func standard() -> Base {
        self.base
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable consuming public func incremented(by addend: borrowing Self) -> UMNOverflow<Self> {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable consuming public func decremented(by subtrahend: borrowing Self) -> UMNOverflow<Self> {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable consuming public func multiplied(by multiplier: borrowing Self) -> UMNOverflow<Self> {
        fatalError("TODO")
    }
    
    @inlinable consuming public func squared() -> UMNOverflow<Self> {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Division
    //=------------------------------------------------------------------------=
    
    @inlinable consuming public func quotient(dividingBy divisor: borrowing Self) -> UMNOverflow<Self> {
        fatalError("TODO")
    }
    
    @inlinable consuming public func remainder(dividingBy divisor: borrowing Self) -> UMNOverflow<Self> {
        fatalError("TODO")
    }
    
    @inlinable consuming public func divided(by divisor: borrowing Self) -> UMNOverflow<UMNQuoRem<Self, Self>> {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Fixed Width
    //=------------------------------------------------------------------------=
    
    @inlinable public static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> UMNFullWidth<Self, Magnitude> {
        fatalError("TODO")
    }
    
    @inlinable public static func dividing(_ dividend: consuming UMNFullWidth<Self, Magnitude>, by divisor: borrowing Self) -> UMNOverflow<UMNQuoRem<Self, Self>> {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        fatalError("TODO")
    }
    
    @inlinable public static func <  (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        fatalError("TODO")
    }
}

//*============================================================================*
// MARK: * UMN x Core Int x Conditional Conformances
//*============================================================================*

extension UMNCoreInt:   UMNSigned where Base: Swift  .SignedInteger { }
extension UMNCoreInt: UMNUnsigned where Base: Swift.UnsignedInteger { }
