//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Unsigned Integer
//*============================================================================*

/// An unsigned binary integer.
///
/// - Note: Its static `isSigned` value is `false`.
///
/// ### Magnitude
///
/// An unsigned integer can by definition represent its magnitude. As such, the
/// magnitude should be of the same type. While alternative designs are possible,
/// this design makes generic code simpler.
///
/// - Requires: The magnitude must be of the same type.
///
public protocol UnsignedInteger: BinaryInteger where Element: UnsignedInteger, Magnitude == Self, Mode == Unsigned { }
