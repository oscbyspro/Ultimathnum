//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Unsigned
//*============================================================================*

/// An unsigned binary integer.
///
/// ### Await: Generalized Opaque and Existential Type Constraints
///
/// This protocol is basically just a named type constraint. So it
/// might be possible to replace with the following, at some point:
///
/// ```swift
/// any  BinaryInteger<.Magnitude == .Self>
/// some BinaryInteger<.Magnitude == .Self>
/// ```
///
public protocol UnsignedInteger: BinaryInteger where Element: UnsignedInteger, Magnitude == Self, Mode == Unsigned { }
