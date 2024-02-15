//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Minimi Int x Subtraction
//*============================================================================*

extension MinimiInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func negated() throws -> Self {
        try Overflow.resolve(self, overflow: Bool(bitPattern: self))
    }
    
    @inlinable public func minus( _ decrement: Self) throws -> Self {
        try Overflow.resolve(self ^ decrement, overflow: Bool(bitPattern: self.base < decrement.base))
    }
}
