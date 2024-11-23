//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntIop
import InfiniIntKit

//*============================================================================*
// MARK: * Utilities x Infini Int Stdlib
//*============================================================================*

/// ### Development
///
/// - Note: We need this protocol absent existential generic types.
///
protocol InfiniIntStdlib:
    BitCastable,
    Swift.SignedInteger,
    Swift.LosslessStringConvertible,
    Swift.Sendable
where
    Base.Stdlib == Self,
    Base.BitPattern == Self.BitPattern,
    Base.IntegerLiteralType == StaticBigInt,
    Self.Magnitude == Self,
    Self.Stride == Swift.Int,
    Self.IntegerLiteralType == StaticBigInt
{
    
    associatedtype Base: FiniteInteger & Interoperable
}

//=----------------------------------------------------------------------------=
// MARK: + Models
//=----------------------------------------------------------------------------=

extension InfiniInt.Stdlib: InfiniIntStdlib { }
