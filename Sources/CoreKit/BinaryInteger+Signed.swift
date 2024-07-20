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
/// A signed binary integer represents a finite value. The appendix bit of
/// a signed binary integer indicates whether it is natural (`0`) or negative (`1`).
///
///
///                ┌───────────┬───────────┐
///                │  Systems  │ Arbitrary │
///     ┌──────────┼───────────┤───────────┤
///     │   Signed │     X     │     X     │
///     ├──────────┼───────────┤───────────┤
///     │ Unsigned │           │           │
///     └──────────┴───────────┴───────────┘
///
///
public protocol SignedInteger: FiniteInteger where Element: SignedInteger, Signitude == Self { }
