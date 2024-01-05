//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import UMNCoreKit

//*============================================================================*
// MARK: * Signed Int x Addition
//*============================================================================*

extension SignedInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func incremented(by increment: borrowing Self) -> Overflow<Self> {
        var sign: Sign = self.sign; var magnitude: Overflow<Magnitude> = if self.sign == increment.sign {
            self.magnitude.incremented(by: increment.magnitude)
        }   else  {
            self.magnitude.decremented(by: increment.magnitude)
        }
        
        if  magnitude.overflow, sign != increment.sign {
            sign = sign.toggled()
            magnitude.value = magnitude.value.negated().value
        }
        
        return Overflow(sign: sign, magnitude: magnitude)
    }
}
