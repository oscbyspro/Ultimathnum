//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Finite Integer
//*============================================================================*

/// A finite binary integer.
///
/// A finite binary integer represents a value in the countable domain.
///
///
///                ┌───────────┬───────────┐
///                │  Systems  │ Arbitrary |
///     ┌──────────┼───────────┤───────────┤
///     │   Signed │     X     │     X     │
///     ├──────────┼───────────┤───────────┤
///     │ Unsigned │     X     │           │
///     └──────────┴───────────┴───────────┘
///
///
public protocol FiniteInteger: BinaryInteger { }
