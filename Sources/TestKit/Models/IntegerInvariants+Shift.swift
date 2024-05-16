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
// MARK: * Integer Invariants x Shift
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utiliteis
    //=------------------------------------------------------------------------=
    
    public func upshiftRepeatingBit() {
        test.shift(T(repeating: 0), ~1, T(repeating: 0), .left, .smart)
        test.shift(T(repeating: 0), ~0, T(repeating: 0), .left, .smart)
        test.shift(T(repeating: 0),  0, T(repeating: 0), .left, .smart)
        test.shift(T(repeating: 0),  1, T(repeating: 0), .left, .smart)
        test.shift(T(repeating: 0),  2, T(repeating: 0), .left, .smart)
        
        if  T.isSigned {
            test.shift(T(repeating: 1), ~1, T(repeating: 1),     .left, .smart)
            test.shift(T(repeating: 1), ~0, T(repeating: 1),     .left, .smart)
            test.shift(T(repeating: 1),  0, T(repeating: 1),     .left, .smart)
            test.shift(T(repeating: 1),  1, T(repeating: 1) * 2, .left, .smart)
            test.shift(T(repeating: 1),  2, T(repeating: 1) * 4, .left, .smart)
        }   else {
            test.shift(T(repeating: 1), ~1, T(repeating: 0),     .left, .smart)
            test.shift(T(repeating: 1), ~0, T(repeating: 0),     .left, .smart)
            test.shift(T(repeating: 1),  0, T(repeating: 1),     .left, .smart)
            test.shift(T(repeating: 1),  1, T(repeating: 1) - 1, .left, .smart)
            test.shift(T(repeating: 1),  2, T(repeating: 1) - 3, .left, .smart)
        }
    }
    
    public func downshiftRepeatingBit() {
        test.shift(T(repeating: 0), ~1, T(repeating: 0), .right, .smart)
        test.shift(T(repeating: 0), ~0, T(repeating: 0), .right, .smart)
        test.shift(T(repeating: 0),  0, T(repeating: 0), .right, .smart)
        test.shift(T(repeating: 0),  1, T(repeating: 0), .right, .smart)
        test.shift(T(repeating: 0),  2, T(repeating: 0), .right, .smart)
        
        if  T.isSigned {
            test.shift(T(repeating: 1), ~1, T(repeating: 1) * 4, .right, .smart)
            test.shift(T(repeating: 1), ~0, T(repeating: 1) * 2, .right, .smart)
            test.shift(T(repeating: 1),  0, T(repeating: 1),     .right, .smart)
            test.shift(T(repeating: 1),  1, T(repeating: 1),     .right, .smart)
            test.shift(T(repeating: 1),  2, T(repeating: 1),     .right, .smart)
        }   else if T.size.isInfinite {
            test.shift(T(repeating: 1), ~1, T(repeating: 1),     .right, .smart)
            test.shift(T(repeating: 1), ~0, T(repeating: 1),     .right, .smart)
            test.shift(T(repeating: 1),  0, T(repeating: 1),     .right, .smart)
            test.shift(T(repeating: 1),  1, T(repeating: 1),     .right, .smart)
            test.shift(T(repeating: 1),  2, T(repeating: 1),     .right, .smart)
        }   else {
            test.shift(T(repeating: 1), ~1, T(repeating: 0),     .right, .smart)
            test.shift(T(repeating: 1), ~0, T(repeating: 0),     .right, .smart)
            test.shift(T(repeating: 1),  0, T(repeating: 1),     .right, .smart)
            test.shift(T(repeating: 1),  1, T(repeating: 1) / 2, .right, .smart)
            test.shift(T(repeating: 1),  2, T(repeating: 1) / 4, .right, .smart)
        }
    }
}
