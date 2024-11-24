//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntIop
import DoubleIntKit

//*============================================================================*
// MARK: * Utilities x Double Int Stdlib
//*============================================================================*

/// ### Development
///
/// - Note: We need this protocol absent existential generic types.
///
protocol DoubleIntStdlib:
    BitCastable,
    Swift.LosslessStringConvertible,
    Swift.Sendable,
    Swift.FixedWidthInteger
where
    Base.Stdlib == Self,
    Base.BitPattern == Self.BitPattern,
    Base.Magnitude: Interoperable,
    Base.Magnitude.Stdlib == Self.Magnitude,
    Self.Magnitude: DoubleIntStdlib,
    Self.Magnitude.BitPattern == Base.BitPattern,
    Self.Stride == Swift.Int
{
    
    associatedtype Base: SystemsInteger & Interoperable
}

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

typealias DoubleIntStdlibAsSigned   = DoubleIntStdlib & Swift  .SignedInteger
typealias DoubleIntStdlibAsUnsigned = DoubleIntStdlib & Swift.UnsignedInteger

//=----------------------------------------------------------------------------=
// MARK: + Models
//=----------------------------------------------------------------------------=

extension DoubleInt.Stdlib: DoubleIntStdlib { }

//=----------------------------------------------------------------------------=
// MARK: + Workarounds
//=----------------------------------------------------------------------------=

/// -  Note: Parameterized tests crash if duplicate descriptions.
struct AnyDoubleIntStdlibType: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let base: any DoubleIntStdlib.Type
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    var description: String {
        String(reflecting: self.base)
    }
}

/// -  Note: Parameterized tests crash if duplicate descriptions.
struct AnyDoubleIntStdlibTypeAsSigned: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let base: any (DoubleIntStdlib & Swift.SignedInteger).Type
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    var description: String {
        String(reflecting: self.base)
    }
}
