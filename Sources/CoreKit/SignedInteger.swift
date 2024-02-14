//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Signed Integer
//*============================================================================*

/// A signed binary integer.
///
/// - Note: Its static `isSigned` value is `true`.
///
public protocol SignedInteger: BinaryInteger where Element: SignedInteger { }
