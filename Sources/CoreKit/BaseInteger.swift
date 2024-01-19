//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Base Integer
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
/// let integers: [any BaseInteger] = [Int(), UInt()]
/// ```
///
public protocol BaseInteger: BitCastable, BitOperable, Swift.FixedWidthInteger, Swift.Sendable
where BitPattern == Magnitude.BitPattern, Magnitude: Swift.FixedWidthInteger & BaseInteger { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension BaseInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming BitPattern) {
        self = Swift.unsafeBitCast(bitPattern, to: Self.self)
    }
    
    @inlinable public var bitPattern: BitPattern {
        consuming get {
            Swift.unsafeBitCast(self, to: BitPattern.self)
        }
    }
}

//*============================================================================*
// MARK: * Base Integer x Models
//*============================================================================*

extension Int:    BaseInteger { }
extension Int8:   BaseInteger { }
extension Int16:  BaseInteger { }
extension Int32:  BaseInteger { }
extension Int64:  BaseInteger { }
extension UInt:   BaseInteger { }
extension UInt8:  BaseInteger { }
extension UInt16: BaseInteger { }
extension UInt32: BaseInteger { }
extension UInt64: BaseInteger { }
