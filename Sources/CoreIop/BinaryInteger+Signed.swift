//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Binary Integer x Signed
//*============================================================================*

/// An interoperable, signed, binary integer.
///
///                ┌───────────┬───────────┐
///                │  Systems  │ Arbitrary |
///     ┌──────────┼───────────┤───────────┤
///     │   Signed │     X     │     X     │
///     ├──────────┼───────────┤───────────┤
///     │ Unsigned │           │           │
///     └──────────┴───────────┴───────────┘
///
public protocol SignedIntegerInteroperable:
                                                
    FiniteIntegerInteroperable,
    SignedInteger

where

    Stdlib: Swift.SignedInteger

{ }
