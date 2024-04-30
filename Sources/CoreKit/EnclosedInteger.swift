//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Enclosed
//*============================================================================*

/// An enclosed binary integer.
///
/// An enclosed binary integer has a `min` and `max` value.
///
/// ```
///            ┌───────────┬───────────┐
///            │ FINITE    │ INFINITE  |
/// ┌──────────┼───────────┤───────────┤
/// │ SIGNED   │ min / max │ --------- │
/// ├──────────┼───────────┤───────────┤
/// │ UNSIGNED │ min / max │ min / max │
/// └──────────┴───────────┴───────────┘
/// ```
///
public protocol EnclosedInteger: BinaryInteger { }
