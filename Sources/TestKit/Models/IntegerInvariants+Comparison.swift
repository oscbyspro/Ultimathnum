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
// MARK: * Integer Invariants x Addition
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func comparisonAgainstOneByte() where T: BinaryInteger {
        //=--------------------------------------=
        typealias M = T.Magnitude
        typealias S = T.Signitude
        //=--------------------------------------=
        if  T.isSigned {
            test.comparison(T(I8.min),     I8.min,  0 as Signum)
            test.comparison(T(I8.min) + 1, I8.min,  1 as Signum)
            test.comparison(T(U8.min) - 1, U8.min, -1 as Signum)
            test.comparison(T(U8.min),     U8.min,  0 as Signum)
            test.comparison(T(U8.min) + 1, U8.min,  1 as Signum)
            test.comparison(T(I8.max) - 1, I8.max, -1 as Signum)
            test.comparison(T(I8.max),     I8.max,  0 as Signum)
        }   else {
            test.comparison(T(U8.min),     U8.min,  0 as Signum)
            test.comparison(T(U8.min) + 1, U8.min,  1 as Signum)
            test.comparison(T(U8.max) - 1, U8.max, -1 as Signum)
            test.comparison(T(U8.max),     U8.max,  0 as Signum)
        }
    }
    
    public func comparisonOfRepeatingBit() where T: BinaryInteger {
        //=--------------------------------------=
        typealias M = T.Magnitude
        typealias S = T.Signitude
        //=--------------------------------------=
        always: do {
            test.comparison(M(repeating: 0), M(repeating: 0),  0 as Signum)
            test.comparison(M(repeating: 0), M(repeating: 1), -1 as Signum)
            test.comparison(M(repeating: 1), M(repeating: 0),  1 as Signum)
            test.comparison(M(repeating: 1), M(repeating: 1),  0 as Signum)
            
            test.comparison(M(repeating: 0), S(repeating: 0),  0 as Signum)
            test.comparison(M(repeating: 0), S(repeating: 1),  1 as Signum)
            test.comparison(M(repeating: 1), S(repeating: 0),  1 as Signum)
            test.comparison(M(repeating: 1), S(repeating: 1),  1 as Signum)
            
            test.comparison(S(repeating: 0), M(repeating: 0),  0 as Signum)
            test.comparison(S(repeating: 0), M(repeating: 1), -1 as Signum)
            test.comparison(S(repeating: 1), M(repeating: 0), -1 as Signum)
            test.comparison(S(repeating: 1), M(repeating: 1), -1 as Signum)
            
            test.comparison(S(repeating: 0), S(repeating: 0),  0 as Signum)
            test.comparison(S(repeating: 0), S(repeating: 1),  1 as Signum)
            test.comparison(S(repeating: 1), S(repeating: 0), -1 as Signum)
            test.comparison(S(repeating: 1), S(repeating: 1),  0 as Signum)
        }
    }
}
