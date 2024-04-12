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
public protocol BaseInteger<BitPattern>: 
    BitCastable,
    Swift.FixedWidthInteger,
    Swift.Sendable
where
    Signitude.Mode == Signed,
    Signitude: BaseInteger<BitPattern>,
    Signitude: Swift.SignedInteger, 
    Signitude.Magnitude == Magnitude,
    Signitude.Signitude == Signitude,
    Magnitude.Mode == Unsigned,
    Magnitude: BaseInteger<BitPattern>,
    Magnitude: Swift.UnsignedInteger,
    Magnitude.Magnitude == Magnitude,
    Magnitude.Signitude == Signitude
{
    
    associatedtype Magnitude

    associatedtype Signitude
    
    associatedtype Mode: Signedness
    
    @inlinable static var mode: Mode { get }
}
