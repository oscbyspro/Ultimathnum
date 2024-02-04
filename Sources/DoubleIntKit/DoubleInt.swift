//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Double Int
//*============================================================================*

@frozen public struct DoubleInt<Base: SystemsInteger>: SystemsInteger {    
    
    public typealias High = Base
    
    public typealias Low  = Base.Magnitude
    
    public typealias Element = Base.Element
    
    public typealias IntegerLiteralType = StaticBigInt
    
    public typealias Magnitude = DoubleInt<Base.Magnitude>
    
    public typealias BitPattern = Doublet<Base>.BitPattern
    
    @usableFromInline typealias Storage = Doublet<Base>
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        Base.isSigned
    }
    
    /// The bit width of this type.
    ///
    /// - Note: Values in `0 ..< bitWidth` always fit in Base.Magnitude.
    ///
    @inlinable public static var bitWidth: Magnitude {
        Magnitude(low: Base.bitWidth) + Magnitude(low: Base.bitWidth)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from two halves.
    @inlinable public init(_ storage: consuming Doublet<Base>) {
        self.storage = storage
    }
    
    /// ### Development
    ///
    /// - TODO: Consider using storage as bit pattern type.
    ///
    @inlinable public init(bitPattern: consuming Doublet<Base>.BitPattern) {
        self.init(low: bitPattern.low, high: Base(bitPattern: bitPattern.high))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var bitPattern: BitPattern {
        BitPattern(low: self.low, high: Base.Magnitude(bitPattern: self.high))
    }
    
    @inlinable public var magnitude: Magnitude {
        Magnitude(bitPattern: self.isLessThanZero ? ~self &+ 1 : self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Un/signed
//=----------------------------------------------------------------------------=

extension DoubleInt:   SignedInteger where Base:   SignedInteger { }
extension DoubleInt: UnsignedInteger where Base: UnsignedInteger { }

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

/// A signed, 128-bit, integer.
public typealias I128  = DoubleInt<I64>

/// An unsigned, 128-bit, integer.
public typealias U128  = DoubleInt<U64>

/// A signed, 256-bit, integer.
public typealias I256  = DoubleInt<I128>

/// An unsigned, 256-bit, integer.
public typealias U256  = DoubleInt<U128>

/// A signed, 512-bit, integer.
public typealias I512  = DoubleInt<I256>

/// An unsigned, 512-bit, integer.
public typealias U512  = DoubleInt<U256>

/// A signed, 1024-bit, integer.
public typealias I1024 = DoubleInt<I512>

/// An unsigned, 1024-bit, integer.
public typealias U1024 = DoubleInt<U512>

/// A signed, 2048-bit, integer.
public typealias I2048 = DoubleInt<I1024>

/// An unsigned, 2048-bit, integer.
public typealias U2048 = DoubleInt<U1024>

/// A signed, 4096-bit, integer.
public typealias I4096 = DoubleInt<I2048>

/// An unsigned, 4096-bit, integer.
public typealias U4096 = DoubleInt<U2048>
