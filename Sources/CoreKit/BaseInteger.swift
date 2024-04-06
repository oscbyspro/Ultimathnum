//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Base Integer
//*============================================================================*
//=----------------------------------------------------------------------------=
// TODO: * Rename this protocol because it looks too much like BinaryInteger.
//=----------------------------------------------------------------------------=

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
public protocol BaseInteger<BitPattern>: BitCastable, Swift.FixedWidthInteger, Swift.Sendable
where BitPattern == Magnitude.BitPattern, Magnitude: BaseInteger {
    
    associatedtype Mode: Signedness where Magnitude.Mode == IsUnsigned
}
