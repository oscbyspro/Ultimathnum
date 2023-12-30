//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x System Integer
//*============================================================================*

/// Only the following types conform to this protocol:
///
/// - `Int`
/// - `Int8`
/// - `Int16`
/// - `Int32`
/// - `Int64`
///
/// - `UInt`
/// - `UInt8`
/// - `UInt16`
/// - `UInt32`
/// - `UInt64`
///
/// ### Existentials
///
/// ```swift
/// let integers: [any UMNSystemInteger] = [Int(), UInt()]
/// ```
///
public protocol UMNSystemInteger: UMNBitCastable, Swift.FixedWidthInteger, Sendable
where BitPattern == Magnitude.BitPattern, Magnitude: Swift.FixedWidthInteger & UMNSystemInteger { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension UMNSystemInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bit Pattern
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming BitPattern) {
        self = Swift.unsafeBitCast(bitPattern, to: Self.self)
    }
    
    @inlinable public consuming func bitPattern() -> BitPattern {
        Swift.unsafeBitCast(self, to: BitPattern.self)
    }
}

//*============================================================================*
// MARK: * UMN x System Integer x Models
//*============================================================================*

extension Int: UMNSystemInteger {
    public typealias BitPattern = Magnitude
}

extension Int8: UMNSystemInteger {
    public typealias BitPattern = Magnitude
}

extension Int16: UMNSystemInteger {
    public typealias BitPattern = Magnitude
}

extension Int32: UMNSystemInteger {
    public typealias BitPattern = Magnitude
}

extension Int64: UMNSystemInteger {
    public typealias BitPattern = Magnitude
}

extension UInt: UMNSystemInteger {
    public typealias BitPattern = Magnitude
}

extension UInt8: UMNSystemInteger {
    public typealias BitPattern = Magnitude
}

extension UInt16: UMNSystemInteger {
    public typealias BitPattern = Magnitude
}

extension UInt32: UMNSystemInteger {
    public typealias BitPattern = Magnitude
}

extension UInt64: UMNSystemInteger {
    public typealias BitPattern = Magnitude
}
