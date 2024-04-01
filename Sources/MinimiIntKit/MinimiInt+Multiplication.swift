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
// MARK: * Minimi Int x Multiplication
//*============================================================================*

extension MinimiInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func squared() -> Fallible<Self> {
        Fallible(self, error: Self.isSigned && Bool(bitPattern: self))
    }
    
    @inlinable public func times(_ multiplier: Self) -> Fallible<Self> {
        Fallible(self & multiplier, error: Self.isSigned && Bool(bitPattern: self & multiplier))
    }
    
    @inlinable public func multiplication(_ multiplier: Self) -> DoubleIntLayout<Self> {
        DoubleIntLayout(low: Magnitude(bitPattern: self & multiplier), high: 0 as  Self)
    }
}
