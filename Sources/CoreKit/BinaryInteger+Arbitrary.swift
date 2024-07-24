//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Arbitrary
//*============================================================================*

/// An arbitrary binary integer.
///
/// An arbitrary binary integer is more lenient than systems integer types.
/// Its `size` is infinite, and its `body` and `appendix` are only bounded by
/// the `entropy` limit of `IX.max` bits.
///
///                ┌───────────┬───────────┐
///                │  Systems  │ Arbitrary │
///     ┌──────────┼───────────┤───────────┤
///     │   Signed │           │     X     │
///     ├──────────┼───────────┤───────────┤
///     │ Unsigned │           │     X     │
///     └──────────┴───────────┴───────────┘
///
/// - Note: The `size` of an arbitrary binary integer is infinite.
///
/// - Note: An arbitrary binary integer is typically heap-allocated.
///
public protocol ArbitraryInteger: BinaryInteger where Magnitude: ArbitraryInteger, Signitude: ArbitraryInteger { }
