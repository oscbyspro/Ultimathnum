//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Capture
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func capture(_ map: (Self) throws -> Self) rethrows {
        self = try map(self)
    }
    
    @inlinable public mutating func capture(_ map: (Self) throws -> ArithmeticResult<Self>) rethrows -> Bool {
        let overflow: Bool
        (self, overflow) = try map(self).components
        return overflow
    }
}
