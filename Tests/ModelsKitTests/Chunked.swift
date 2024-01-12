//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import ModelsKit
import TestKit

//*============================================================================*
// MARK: * Chunked
//*============================================================================*

final class ChunkedTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func check<A: SystemInteger & UnsignedInteger, B: SystemInteger & UnsignedInteger>(
    _ lhs: [A], _ rhs: [B], isSigned: Bool? = nil,
    file: StaticString = #file, line: UInt  = #line) {
        //=--------------------------------------=
        checkOneWay(lhs, rhs, isSigned: isSigned, file: file, line: line)
        checkOneWay(rhs, lhs, isSigned: isSigned, file: file, line: line)
    }

    func checkOneWay<A: SystemInteger & UnsignedInteger, B: SystemInteger & UnsignedInteger>(
    _ lhs: [A], _ rhs: [B], isSigned: Bool? = nil,
    file: StaticString = #file, line: UInt  = #line) {
        //=--------------------------------------=
        let lhsUnsigned = lhs.map(A.Magnitude.init(bitPattern:))
        let rhsUnsigned = rhs.map(B.Magnitude.init(bitPattern:))
        //=--------------------------------------=
        func with(isSigned: Bool) {
            checkElementsEqual(Chunked(lhs,         isSigned: isSigned), rhs,         file: file, line: line)
            checkElementsEqual(Chunked(lhsUnsigned, isSigned: isSigned), rhsUnsigned, file: file, line: line)
        }
        //=--------------------------------------=
        if  isSigned == nil || isSigned == true {
            with(isSigned: true)
        }
        if  isSigned == nil || isSigned == false {
            with(isSigned: false)
        }
    }
    
    func checkElementsEqual<Base: RandomAccessCollection>(
    _ base: Base, _ expectation: [Base.Element],
    file: StaticString = #file, line: UInt = #line) where Base.Element: Equatable {
        //=--------------------------------------=
        XCTAssertEqual(Array(base), expectation, file: file,  line: line)
        XCTAssertEqual(Array(base.indices.map({ base[$0] })), expectation, file: file, line: line)
        //=--------------------------------------=
        for distance in 0 ..< base.count {
            //=----------------------------------=
            let index0 = base.index(base.startIndex, offsetBy: distance + 0)
            let index1 = base.index(base.startIndex, offsetBy: distance + 1)
            //=----------------------------------=
            XCTAssertEqual(base[index0],expectation[distance], file: file, line: line)
            //=----------------------------------=
            XCTAssertEqual(base.index(before: index1), index0, file: file, line: line)
            XCTAssertEqual(base.index(after:  index0), index1, file: file, line: line)

            XCTAssertEqual(base.index(base.endIndex, offsetBy: distance + 0 - base.count), index0, file: file, line: line)
            XCTAssertEqual(base.index(base.endIndex, offsetBy: distance + 1 - base.count), index1, file: file, line: line)
            //=----------------------------------=
            XCTAssertEqual(base.distance(from: base.startIndex, to: index0), distance + 0, file: file, line: line)
            XCTAssertEqual(base.distance(from: base.startIndex, to: index1), distance + 1, file: file, line: line)
            
            XCTAssertEqual(base.distance(from: index0, to: base.endIndex), base.count - distance - 0, file: file, line: line)
            XCTAssertEqual(base.distance(from: index1, to: base.endIndex), base.count - distance - 1, file: file, line: line)
        }
        //=--------------------------------------=
        for distance in 0 ... base.count + 1 {
            XCTAssert(base.prefix(distance).elementsEqual(expectation.prefix(distance)), file: file, line: line)
            XCTAssert(base.suffix(distance).elementsEqual(expectation.suffix(distance)), file: file, line: line)
        }
    }
}
