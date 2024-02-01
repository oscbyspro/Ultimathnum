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

extension Namespace.TupleBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Magnitude
    //=------------------------------------------------------------------------=
    
    @inlinable package static func magnitude(of value: consuming X2) -> X2.Magnitude {
        var value = consume value
        
        if  value.high.isLessThanZero {
            var carry: Bool
            carry = Overflow.capture(&value.low,  map:{ try (~$0).plus(0000000000001) })
            carry = Overflow.capture(&value.high, map:{ try (~$0).plus(carry ? 1 : 0) })
        }
        
        return X2.Magnitude(low: value.low, high: Base.Magnitude(bitPattern: value.high))
    }
}
