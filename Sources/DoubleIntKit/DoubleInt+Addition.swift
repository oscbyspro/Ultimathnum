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
// MARK: * Double Int x Addition
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    // TODO: consider composable aritmetic, like plus(Base.Magnitude) -> Self
    //=------------------------------------------------------------------------=

    @inlinable public consuming func plus(_ increment: Self) throws -> Self {
        var overflow = Overflow.capture(&self.low) {
            try $0.plus(increment.low)
        }
        
        overflow = overflow && Overflow.capture(&self.high) {
            try $0.incremented()
        }
        
        overflow = overflow != Overflow.capture(&self.high) {
            try $0.plus(increment.high)
        }
        
        return try Overflow.resolve(self, overflow: overflow)
    }
}
