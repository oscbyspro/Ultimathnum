//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Double Int
//*============================================================================*

@frozen public struct DoubleInt<Base: SystemsInteger>: SystemsInteger {
    
    public typealias Storage = Doublet<Base>
    
    public typealias High = Base
    
    public typealias Low  = Base.Magnitude
    
    public typealias Element = Base.Element
    
    public typealias IntegerLiteralType = StaticBigInt
    
    public typealias Magnitude = DoubleInt<Base.Magnitude>
        
    public typealias BitPattern = Storage.BitPattern
            
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        Base.isSigned
    }
    
    @inlinable public static var bitWidth: Magnitude {
        Magnitude(Storage.bitWidth)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ storage: consuming Storage) {
        self.storage = storage
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(low: consuming Low, high: consuming High = 0) {
        self.init(Doublet(low: low, high: high))
    }
    
    @inlinable public init(high: consuming High, low: consuming Low = 0) {
        self.init(Doublet(high: high, low: low))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var low: Low {
        get {
            self.storage.low
        }
        mutating set {
            self.storage.low = newValue
        }
    }
    
    @inlinable public var high: High {
        get {
            self.storage.high
        }
        mutating set {
            self.storage.high = newValue
        }
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
