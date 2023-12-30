//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Core Integer
//*============================================================================*

/// Only the following types conform to this protocol:
///
/// - `SX`
/// - `S8`
/// - `S16`
/// - `S32`
/// - `S64`
///
/// - `UX`
/// - `U8`
/// - `U16`
/// - `U32`
/// - `U64`
///
/// ### Existentials
///
/// ```swift
/// let integers: [any UMNCoreInteger] = [SX(), UX()]
/// ```
///
public protocol UMNCoreInteger: UMNTrivialInteger { }
