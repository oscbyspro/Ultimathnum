//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Core
//*============================================================================*

/// The stuff integers are made of.
///
/// ### Models
///
/// Only the following types conform to this protocol:
///
/// - `IX`
/// - `I8`
/// - `I16`
/// - `I32`
/// - `I64`
/// - `UX`
/// - `U8`
/// - `U16`
/// - `U32`
/// - `U64`
///
public protocol CoreInteger:
    Interoperable,
    SystemsInteger
where
    BitPattern == Stdlib.BitPattern,
    Element == Self,
    IntegerLiteralType == Stdlib,
    Magnitude: CoreInteger,
    Signitude: CoreInteger,
    Stdlib: BitCastable,
    Stdlib: Swift.FixedWidthInteger,
    Stdlib: Swift.Sendable,
    Stdlib.BitPattern == Stdlib.Magnitude,
    Stdlib.Magnitude  == Magnitude.Stdlib
{ }
