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
// MARK: * Binary Integer x Finite
//*============================================================================*

/// An interoperable, finite, binary integer.
///
///                ┌───────────┬───────────┐
///                │  Systems  │ Arbitrary |
///     ┌──────────┼───────────┤───────────┤
///     │   Signed │     X     │     X     │
///     ├──────────┼───────────┤───────────┤
///     │ Unsigned │     X     │           │
///     └──────────┴───────────┴───────────┘
///
public protocol FiniteIntegerInteroperable:
                                                
    FiniteInteger,
    Interoperable

where

    Element:  SystemsIntegerInteroperable,
    Signitude: SignedIntegerInteroperable,
    
    Stdlib: BitCastable<BitPattern>,
    Stdlib: Swift.BinaryInteger,
    Stdlib: Swift.LosslessStringConvertible,
    Stdlib: Swift.Sendable,
    
    Stdlib.Magnitude: BitCastable<BitPattern>,
    Stdlib.Magnitude: Swift.BinaryInteger,
    Stdlib.Magnitude: Swift.LosslessStringConvertible,
    Stdlib.Magnitude: Swift.Sendable,

    Stdlib.Stride == Swift.Int,
    Stdlib.Magnitude.Stride == Swift.Int

{ }
