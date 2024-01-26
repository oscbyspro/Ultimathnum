//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
    
    func check<A: SystemsInteger & UnsignedInteger, B: SystemsInteger & UnsignedInteger>(
    _ lhs: [A], _ rhs: [B], isSigned: Bool? = nil, file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        checkOneWayOnly(lhs, rhs, isSigned: isSigned, file: file, line: line)
        checkOneWayOnly(rhs, lhs, isSigned: isSigned, file: file, line: line)
    }
    
    func checkOneWayOnly<A: SystemsInteger & UnsignedInteger, B: SystemsInteger & UnsignedInteger>(
    _ lhs: [A], _ rhs: [B], isSigned: Bool? = nil, file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        if  isSigned != false {
            Test.collection(T(lhs as [A], isSigned: true,  as: B.self).source(), rhs, file: file, line: line)
        }
        
        if  isSigned != true {
            Test.collection(T(lhs as [A], isSigned: false, as: B.self).source(), rhs, file: file, line: line)
        }
    }
}
