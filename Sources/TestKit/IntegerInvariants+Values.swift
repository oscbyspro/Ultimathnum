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
        test .ascending(T.lsb, 0 as Bit, 0)
        test .ascending(T.lsb, 1 as Bit, 1)
        test.descending(T.lsb, 0 as Bit, T.size - 1)
        test.descending(T.lsb, 1 as Bit, 0)
        
        test .ascending(T.msb, 0 as Bit, T.size - 1)
        test .ascending(T.msb, 1 as Bit, 0)
        test.descending(T.msb, 0 as Bit, 0)
        test.descending(T.msb, 1 as Bit, 1)
    }
}
