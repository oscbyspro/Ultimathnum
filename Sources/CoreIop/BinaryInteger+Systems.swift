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
// MARK: * Binary Integer x Systems
//*============================================================================*

/// An interoperable, systems, binary integer.
///
///                ┌───────────┬───────────┐
///                │  Systems  │ Arbitrary |
///     ┌──────────┼───────────┤───────────┤
///     │   Signed │     X     │           │
///     ├──────────┼───────────┤───────────┤
///     │ Unsigned │     X     │           │
///     └──────────┴───────────┴───────────┘
///
public protocol SystemsIntegerInteroperable:
                                                
    FiniteIntegerInteroperable,
    SystemsInteger

where

    Magnitude: NaturalIntegerInteroperable,
    Signitude: CompactIntegerInteroperable,
    Stdlib:    Swift.FixedWidthInteger,
    Stdlib.Magnitude == Magnitude.Stdlib

{ }
