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
// MARK: * Binary Integer x Natural
//*============================================================================*

/// An interoperable, natural, binary integer.
///
///                ┌───────────┬───────────┐
///                │  Systems  │ Arbitrary |
///     ┌──────────┼───────────┤───────────┤
///     │   Signed │           │           │
///     ├──────────┼───────────┤───────────┤
///     │ Unsigned │     X     │           │
///     └──────────┴───────────┴───────────┘
///
public protocol NaturalIntegerInteroperable:
                                                
    SystemsIntegerInteroperable,
    UnsignedInteger

where

    Stdlib: Swift.UnsignedInteger

{ }
