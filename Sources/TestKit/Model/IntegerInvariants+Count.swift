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
// MARK: * Integer Invariants x Count
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func entropy() where T: BinaryInteger {
        //=--------------------------------------=
        let msb = Self.msbEsque
        let shl = Self.shlEsque
        //=--------------------------------------=
        if  T.isSigned || T.size.isInfinite {
            test.same((msb).count(.entropy()), M(raw: shl + 1), "00000001...1")
        }   else {
            test.same((msb).count(.entropy()), M(raw: shl + 2), "00000001...0")
        }
        //=--------------------------------------=
        if  T.isSigned || T.size.isInfinite {
            test.same((~5 as T).count(.entropy()), 0000000004, "010....1")
            test.same((~4 as T).count(.entropy()), 0000000004, "110....1")
            test.same((~3 as T).count(.entropy()), 0000000003, "00.....1")
            test.same((~2 as T).count(.entropy()), 0000000003, "10.....1")
            test.same((~1 as T).count(.entropy()), 0000000002, "0......1")
            test.same((~0 as T).count(.entropy()), 0000000001, ".......1")
            
        }   else {
            test.same((~5 as T).count(.entropy()), T.size + 1, "010....1...0")
            test.same((~4 as T).count(.entropy()), T.size + 1, "110....1...0")
            test.same((~3 as T).count(.entropy()), T.size + 1, "00.....1...0")
            test.same((~2 as T).count(.entropy()), T.size + 1, "10.....1...0")
            test.same((~1 as T).count(.entropy()), T.size + 1, "0......1...0")
            test.same((~0 as T).count(.entropy()), T.size + 1, ".......1...0")
            
        };  always: do {
            test.same(( 0 as T).count(.entropy()), 0000000001, ".......0")
            test.same(( 1 as T).count(.entropy()), 0000000002, "1......0")
            test.same(( 2 as T).count(.entropy()), 0000000003, "01.....0")
            test.same(( 3 as T).count(.entropy()), 0000000003, "11.....0")
            test.same(( 4 as T).count(.entropy()), 0000000004, "001....0")
            test.same(( 4 as T).count(.entropy()), 0000000004, "101....0")
        }
    }
}
