//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Signed
//*============================================================================*

/// A signed binary integer.
///
/// ### Await: Generalized Opaque and Existential Type Constraints
///
/// This protocol is really just a named associated type constraint. So it might
/// be possible to replace with the following, at some point:
///
/// ```swift
/// any  BinaryInteger<.Signitude == .Self>
/// some BinaryInteger<.Signitude == .Self>
/// ```
///
public protocol SignedInteger: BinaryInteger where Element: SignedInteger, Signitude == Self, Mode == Signed { }
