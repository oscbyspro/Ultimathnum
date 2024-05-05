//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Edgy
//*============================================================================*

/// An edgy binary integer.
///
/// An edgy binary integer has `min` and `max` values.
///
///
///                ┌───────────┬───────────┐
///                │ FINITE    │ INFINITE  |
///     ┌──────────┼───────────┤───────────┤
///     │ SIGNED   │ min / max │ --------- │
///     ├──────────┼───────────┤───────────┤
///     │ UNSIGNED │ min / max │ min / max │
///     └──────────┴───────────┴───────────┘
///
///
public protocol EdgyInteger: BinaryInteger { }
