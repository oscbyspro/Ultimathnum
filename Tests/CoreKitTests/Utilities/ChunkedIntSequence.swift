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
// MARK: * Chunked Int Sequence
//*============================================================================*

final class ChunkedIntSequenceTests: XCTestCase {
    
    typealias T = ChunkedIntSequence
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func check<A: SystemInteger & SignedInteger, B: SystemInteger & SignedInteger>(
    _ lhs: [A], _ rhs: [B], isSigned: Bool? = nil,
    file: StaticString = #file, line: UInt  = #line) {
        //=--------------------------------------=
        checkOneWayOnly(lhs, rhs, isSigned: isSigned, file: file, line: line)
        checkOneWayOnly(rhs, lhs, isSigned: isSigned, file: file, line: line)
    }
    
    func checkOneWayOnly<A: SystemInteger & SignedInteger, B: SystemInteger & SignedInteger>(
    _ lhs: [A], _ rhs: [B], isSigned: Bool? = nil,
    file: StaticString = #file, line: UInt  = #line) {
        //=--------------------------------------=
        let lhsUnsigned = lhs.map(A.Magnitude.init(bitPattern:))
        let rhsUnsigned = rhs.map(B.Magnitude.init(bitPattern:))
        //=--------------------------------------=
        func with(isSigned: Bool) {
            Test.collection(T(lhs,         isSigned: isSigned), rhs,         file: file, line: line)
            Test.collection(T(lhs,         isSigned: isSigned), rhsUnsigned, file: file, line: line)
            Test.collection(T(lhsUnsigned, isSigned: isSigned), rhs,         file: file, line: line)
            Test.collection(T(lhsUnsigned, isSigned: isSigned), rhsUnsigned, file: file, line: line)
        }
        //=--------------------------------------=
        if  isSigned == nil || isSigned == true {
            with(isSigned: true)
        }
        if  isSigned == nil || isSigned == false {
            with(isSigned: false)
        }
    }
}
