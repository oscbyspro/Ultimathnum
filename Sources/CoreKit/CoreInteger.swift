//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Integer
//*============================================================================*

/// The stuff integers are made of.
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
public protocol CoreInteger<BitPattern>: 
    BitCastable,
    Swift.FixedWidthInteger,
    Swift.Sendable
where
    Signitude.Mode == Signed,
    Signitude: CoreInteger<BitPattern>,
    Signitude: Swift.SignedInteger, 
    Signitude.Magnitude == Magnitude,
    Signitude.Signitude == Signitude,
    Magnitude.Mode == Unsigned,
    Magnitude: CoreInteger<BitPattern>,
    Magnitude: Swift.UnsignedInteger,
    Magnitude.Magnitude == Magnitude,
    Magnitude.Signitude == Signitude
{
    
    associatedtype Magnitude

    associatedtype Signitude
    
    associatedtype Mode: Signedness
    
    @inlinable static var mode: Mode { get }
}
