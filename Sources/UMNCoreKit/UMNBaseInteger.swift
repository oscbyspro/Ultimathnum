//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Base Integer
//*============================================================================*

/// The stuff integers are made of.
///
/// - Note: Swift's integers are close enough to built-in.
///
/// ### Models
///
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
/// let integers: [any UMNBaseInteger] = [Int(), UInt()]
/// ```
///
public protocol UMNBaseInteger: UMNBitCastable, Swift.FixedWidthInteger, Sendable
where BitPattern == Magnitude.BitPattern, Magnitude: Swift.FixedWidthInteger & UMNBaseInteger { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension UMNBaseInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bit Pattern
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming BitPattern) {
        self = Swift.unsafeBitCast(bitPattern, to: Self.self)
    }
    
    @inlinable public var bitPattern: BitPattern {
        consuming get { Swift.unsafeBitCast(self, to: BitPattern.self) }
    }
}

//*============================================================================*
// MARK: * UMN x Base Integer x Models
//*============================================================================*

extension Int: UMNBaseInteger {
    public typealias BitPattern = Magnitude
}

extension Int8: UMNBaseInteger {
    public typealias BitPattern = Magnitude
}

extension Int16: UMNBaseInteger {
    public typealias BitPattern = Magnitude
}

extension Int32: UMNBaseInteger {
    public typealias BitPattern = Magnitude
}

extension Int64: UMNBaseInteger {
    public typealias BitPattern = Magnitude
}

extension UInt: UMNBaseInteger {
    public typealias BitPattern = Magnitude
}

extension UInt8: UMNBaseInteger {
    public typealias BitPattern = Magnitude
}

extension UInt16: UMNBaseInteger {
    public typealias BitPattern = Magnitude
}

extension UInt32: UMNBaseInteger {
    public typealias BitPattern = Magnitude
}

extension UInt64: UMNBaseInteger {
    public typealias BitPattern = Magnitude
}
