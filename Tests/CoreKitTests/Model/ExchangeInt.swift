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
        _ lhs: [A], 
        _ rhs: [B],
        isSigned: Bool? = nil,
        test: Test = .init()
    )   where A: SystemsInteger & UnsignedInteger, B: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        checkOneWayOnly(lhs, rhs, isSigned: isSigned, test: test)
        checkOneWayOnly(rhs, lhs, isSigned: isSigned, test: test)
    }
    
    func checkOneWayOnly<A, B>(
        _ lhs: [A], 
        _ rhs: [B],
        isSigned: Bool? = nil, 
        test: Test = .init()
    )   where A: SystemsInteger & UnsignedInteger, B: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        if  isSigned != false {
            test.collection(T(lhs as [A], isSigned: true,  as: B.self).source(), rhs)
        }
        
        if  isSigned != true {
            test.collection(T(lhs as [A], isSigned: false, as: B.self).source(), rhs)
        }
    }
}
