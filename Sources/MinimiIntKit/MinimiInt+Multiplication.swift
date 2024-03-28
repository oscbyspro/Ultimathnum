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
    
    @inlinable public func squared() throws -> Self {
        try Overflow.resolve(self, overflow: Self.isSigned && Bool(bitPattern: self))
    }
    
    @inlinable public func times(_ multiplier: Self) throws -> Self {
        try Overflow.resolve(self & multiplier, overflow: Self.isSigned && Bool(bitPattern: self & multiplier))
    }
    
    @inlinable public static func multiplying(_ multiplicand: Self, by multiplier: Self) -> DoubleIntLayout<Self> {
        DoubleIntLayout(low: Magnitude(bitPattern: multiplicand & multiplier), high: 0 as  Self)
    }
}
