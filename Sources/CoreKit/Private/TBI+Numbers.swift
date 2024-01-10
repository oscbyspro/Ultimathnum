//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Tuple Binary Integer x Numbers
//*============================================================================*

extension UMN.TupleBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Magnitude
    //=------------------------------------------------------------------------=
    
    @inlinable package static func magnitude(of value: consuming X2) -> X2.Magnitude {
        var value = consume value
        
        if  value.high.isLessThanZero {
            var carry:   Bool
            (value.low,  carry) = Overflow.capture({ try (~value.low ).incremented(by: 0000000000001) }).components
            (value.high, carry) = Overflow.capture({ try (~value.high).incremented(by: carry ? 1 : 0) }).components
        }
        
        return X2.Magnitude(high: High.Magnitude(bitPattern: value.high), low: High.Magnitude(bitPattern: value.low))
    }
}
