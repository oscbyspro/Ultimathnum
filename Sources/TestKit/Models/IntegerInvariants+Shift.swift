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
        test.shift(T(repeating: 0), ~1, T(repeating: 0), .up, .smart)
        test.shift(T(repeating: 0), ~0, T(repeating: 0), .up, .smart)
        test.shift(T(repeating: 0),  0, T(repeating: 0), .up, .smart)
        test.shift(T(repeating: 0),  1, T(repeating: 0), .up, .smart)
        test.shift(T(repeating: 0),  2, T(repeating: 0), .up, .smart)
        
        if  T.isSigned {
            test.shift(T(repeating: 1), ~1, T(repeating: 1),     .up, .smart)
            test.shift(T(repeating: 1), ~0, T(repeating: 1),     .up, .smart)
            test.shift(T(repeating: 1),  0, T(repeating: 1),     .up, .smart)
            test.shift(T(repeating: 1),  1, T(repeating: 1) * 2, .up, .smart)
            test.shift(T(repeating: 1),  2, T(repeating: 1) * 4, .up, .smart)
        }   else {
            test.shift(T(repeating: 1), ~1, T(repeating: 0),     .up, .smart)
            test.shift(T(repeating: 1), ~0, T(repeating: 0),     .up, .smart)
            test.shift(T(repeating: 1),  0, T(repeating: 1),     .up, .smart)
            test.shift(T(repeating: 1),  1, T(repeating: 1) - 1, .up, .smart)
            test.shift(T(repeating: 1),  2, T(repeating: 1) - 3, .up, .smart)
        }
    }
    
    public func downshiftRepeatingBit() {
        test.shift(T(repeating: 0), ~1, T(repeating: 0), .down, .smart)
        test.shift(T(repeating: 0), ~0, T(repeating: 0), .down, .smart)
        test.shift(T(repeating: 0),  0, T(repeating: 0), .down, .smart)
        test.shift(T(repeating: 0),  1, T(repeating: 0), .down, .smart)
        test.shift(T(repeating: 0),  2, T(repeating: 0), .down, .smart)
        
        if  T.isSigned {
            test.shift(T(repeating: 1), ~1, T(repeating: 1) * 4, .down, .smart)
            test.shift(T(repeating: 1), ~0, T(repeating: 1) * 2, .down, .smart)
            test.shift(T(repeating: 1),  0, T(repeating: 1),     .down, .smart)
            test.shift(T(repeating: 1),  1, T(repeating: 1),     .down, .smart)
            test.shift(T(repeating: 1),  2, T(repeating: 1),     .down, .smart)
        }   else if T.size.isInfinite {
            test.shift(T(repeating: 1), ~1, T(repeating: 1),     .down, .smart)
            test.shift(T(repeating: 1), ~0, T(repeating: 1),     .down, .smart)
            test.shift(T(repeating: 1),  0, T(repeating: 1),     .down, .smart)
            test.shift(T(repeating: 1),  1, T(repeating: 1),     .down, .smart)
            test.shift(T(repeating: 1),  2, T(repeating: 1),     .down, .smart)
        }   else {
            test.shift(T(repeating: 1), ~1, T(repeating: 0),     .down, .smart)
            test.shift(T(repeating: 1), ~0, T(repeating: 0),     .down, .smart)
            test.shift(T(repeating: 1),  0, T(repeating: 1),     .down, .smart)
            test.shift(T(repeating: 1),  1, T(repeating: 1) / 2, .down, .smart)
            test.shift(T(repeating: 1),  2, T(repeating: 1) / 4, .down, .smart)
        }
    }
}
