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
///                ┌───────────┬───────────┐
///                │  Systems  │ Arbitrary |
///     ┌──────────┼───────────┤───────────┤
///     │   Signed │     X     │           │
///     ├──────────┼───────────┤───────────┤
///     │ Unsigned │     X     │     X     │
///     └──────────┴───────────┴───────────┘
///
public protocol EdgyInteger: BinaryInteger { }
