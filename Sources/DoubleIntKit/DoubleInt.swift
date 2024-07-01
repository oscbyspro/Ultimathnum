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

/// A double-width un/signed binary integer type.
///
/// ```
///  DoubleInt<I128>           DoubleInt<U128>
/// ┌───────────────────────┐┌───────────────────────┐
/// │ I256                  ││ U256                  │
/// ├───────────┬───────────┤├───────────┬───────────┤
/// │ U128      │ I128      ││ U128      │ U128      │
/// ├─────┬─────┼─────┬─────┤├─────┬─────┼─────┬─────┤
/// │ U64 │ U64 │ U64 │ I64 ││ U64 │ U64 │ U64 │ U64 │
/// └─────┴─────┴─────┴─────┘└─────┴─────┴─────┴─────┘
/// ```
///
@frozen public struct DoubleInt<Base: SystemsInteger>: SystemsInteger {
    
    public typealias Storage = Doublet<Base>
    
    public typealias High = Base
    
    public typealias Low  = Base.Magnitude
            
    public typealias BitPattern = Storage.BitPattern
    
    public typealias Element = Base.Element
    
    public typealias Magnitude = DoubleInt<Base.Magnitude>
    
    public typealias Signitude = DoubleInt<Base.Signitude>
    
    public typealias IntegerLiteralType = StaticBigInt
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var mode: Signedness {
        Base.mode
    }
    
    @inlinable public static var size: Magnitude {
        Magnitude(Base.size.multiplication(2))
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
    
    @inlinable public init(integerLiteral: RootInt.IntegerLiteralType) {
        self = Self.exactly(RootInt(integerLiteral: integerLiteral)).unwrap()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given components.
    @inlinable public init() {
        self.init(Storage())
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Low) {
        self.init(Storage(low: low))
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Low, high: consuming High) {
        self.init(Storage(low: low, high: high))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming Storage.BitPattern) {
        self.init(Storage(raw: source))
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        self.storage.load(as: BitPattern.self)
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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns its components in ascending order.
    @inlinable public consuming func components() -> (low: Low, high: High) {
        self.storage.components()
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
