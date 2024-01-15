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
// MARK: * Chunked Int
//*============================================================================*

final class ChunkedIntTests: XCTestCase {
    
    typealias T = ChunkedInt
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func check<A: SystemInteger & UnsignedInteger, B: SystemInteger & UnsignedInteger>(
    _ lhs: [A], _ rhs: [B], isSigned: Bool? = nil, file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        checkOneWayOnly(lhs, rhs, isSigned: isSigned, file: file, line: line)
        checkOneWayOnly(rhs, lhs, isSigned: isSigned, file: file, line: line)
    }
    
    func checkOneWayOnly<A: SystemInteger & UnsignedInteger, B: SystemInteger & UnsignedInteger>(
    _ lhs: [A], _ rhs: [B], isSigned: Bool? = nil, file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        if  isSigned == nil || isSigned == true {
            Test.collection(T(lhs, isSigned: true), rhs, file: file, line: line)
        }
        if  isSigned == nil || isSigned == false {
            Test.collection(T(lhs, isSigned: false), rhs, file: file, line: line)
        }
    }
}
