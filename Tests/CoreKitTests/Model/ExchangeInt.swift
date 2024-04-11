//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Exchange Int
//*============================================================================*

final class ExchangeIntTests: XCTestCase {
    
    typealias T = ExchangeInt
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func check<A, B>(
        _ test: Test,
        _ lhs:  [A],
        _ rhs:  [B],
        repeating bit: Bit? = nil
    )   where A: SystemsInteger & UnsignedInteger, B: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        checkOneWayOnly(test, lhs, rhs, repeating: bit)
        checkOneWayOnly(test, rhs, lhs, repeating: bit)
    }
    
    func checkOneWayOnly<A, B>(
        _ test: Test,
        _ lhs:  [A],
        _ rhs:  [B],
        repeating bit: Bit? = nil
    )   where A: SystemsInteger & UnsignedInteger, B: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        if  bit !=  0 {
            test.collection(T.body(lhs, repeating: 1, as: B.self), rhs)
        }
        
        if  bit !=  1 {
            test.collection(T.body(lhs, repeating: 0, as: B.self), rhs)
        }
    }
}
