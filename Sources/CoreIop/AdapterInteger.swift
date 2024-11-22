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
// MARK: * Adapter Integer
//*============================================================================*

/// A binary integer adapter.
public protocol AdapterInteger:
    BitCastable,
    Swift.BinaryInteger,
    Swift.LosslessStringConvertible,
    Swift.Sendable
where
    Base.Stdlib == Self,
    Base.BitPattern == BitPattern,
    Base.IntegerLiteralType == IntegerLiteralType,
    Magnitude: AdapterInteger,
    Magnitude: BitCastable,
    Magnitude.BitPattern == BitPattern,
    Stride == Swift.Int
{
    
    associatedtype Base: FiniteInteger & Interoperable
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var base: Base { get set } // TODO: read & modify
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ base: consuming Base)
}
