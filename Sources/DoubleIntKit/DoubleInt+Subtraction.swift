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
// MARK: * Double Int x Subtraction
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    // TODO: consider composable aritmetic, like minus(Base.Magnitude) -> Self
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() throws -> Self {
        let overflow = Self.isSigned == Overflow.capture(&self) {
            try (~$0).plus(1)
        }
        
        return try Overflow.resolve(self, overflow: overflow)
    }
    
    @inlinable public consuming func minus(_ decrement: Self) throws -> Self {
        var overflow = Overflow.capture(&self.low) {
            try $0.minus(decrement.low)
        }
    
        overflow = overflow && Overflow.capture(&self.high) {
            try $0.decremented()
        }
        
        overflow = overflow != Overflow.capture(&self.high) {
            try $0.minus(decrement.high)
        }
        
        return try Overflow.resolve(self, overflow: overflow)
    }
}
