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
// MARK: * Integer Invariants x Values
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utiliteis
    //=------------------------------------------------------------------------=
    
    public func edgesMinMax() where T: EdgyInteger {
        //=--------------------------------------=
        let min = T.isSigned ? 1 << T(raw: T.size - 1) : T.zero
        let max = min.toggled()
        //=--------------------------------------=
        test.comparison(T.min, T.max, Signum.less)
        //=--------------------------------------=
        test.same(T.min, min, "min")
        test.same(T.max, max, "max")
    }
    
    public func edgesLsbMsb() where T: SystemsInteger {
        //=--------------------------------------=
        test.comparison(T.lsb, T.msb, T.isSigned ? Signum.more : Signum.less)
        //=--------------------------------------=
        test.count(T.lsb,  .ascending(0), 0)
        test.count(T.lsb,  .ascending(1), 1)
        test.count(T.lsb, .descending(0), T.size - 1)
        test.count(T.lsb, .descending(1), 0)
        
        test.count(T.msb,  .ascending(0), T.size - 1)
        test.count(T.msb,  .ascending(1), 0)
        test.count(T.msb, .descending(0), 0)
        test.count(T.msb, .descending(1), 1)
    }
}
