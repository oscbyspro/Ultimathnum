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
// MARK: * UMN x Signed Int x Addition
//*============================================================================*

extension UMNSignedInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func incremented(by increment: borrowing Self) -> UMNOverflow<Self> {
        var sign: UMNSign = self.sign, magnitude: UMNOverflow<Magnitude>
        
        
        if  self.sign == increment.sign {
            magnitude =  self.magnitude.incremented(by: increment.magnitude)
        }   else  {
            magnitude =  self.magnitude.decremented(by: increment.magnitude)
        }
        
        if  magnitude.overflow, sign != increment.sign {
            sign = sign.toggled()
            magnitude.value = magnitude.value.negated().value
        }
        
        return UMNOverflow(sign: sign, magnitude: magnitude)
    }
}
