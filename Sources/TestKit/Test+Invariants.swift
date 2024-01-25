//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Test x Invariants
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func invariants<T: SystemsInteger>(
    _   type: T.Type, file: StaticString = #file, line: UInt = #line) {
        Test.invariantsAsSomeSystemsInteger(type, file: file, line: line)
    }
    
    public static func invariants<T: BinaryInteger>(
    _   type: T.Type, file: StaticString = #file, line: UInt = #line) {
        Test.invariantsAsSomeBinaryInteger(type, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func invariantsAsSomeSystemsInteger<T: SystemsInteger>(
    _   type: T.Type, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssert(T.bitWidth.count(1, option: .all) == 1, "T.bitWidth must be a power of 2", file: file, line: line)
        XCTAssert(T.bitWidth.load(as: UX.self) >= T.Element.bitWidth.load(as: UX.self), "T.bitWidth >= T.Element.bitWidth", file: file, line: line)
        //=--------------------------------------=
        XCTAssertEqual(MemoryLayout<T>.size,      MemoryLayout<T.Content>.size,      "MemoryLayout<T.Content>.size",      file: file, line: line)
        XCTAssertEqual(MemoryLayout<T>.stride,    MemoryLayout<T.Content>.stride,    "MemoryLayout<T.Content>.stride",    file: file, line: line)
        XCTAssertEqual(MemoryLayout<T>.alignment, MemoryLayout<T.Content>.alignment, "MemoryLayout<T.Content>.alignment", file: file, line: line)
        //=--------------------------------------=
        Test.invariantsAsSomeBinaryInteger(type, file: file, line: line)
    }
    
    public static func invariantsAsSomeBinaryInteger<T: BinaryInteger>(
    _   type: T.Type, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(T.isSigned == true,  T.self is any   SignedInteger.Type)
        XCTAssertEqual(T.isSigned == false, T.self is any UnsignedInteger.Type)
        //=--------------------------------------=
        XCTAssert(T.Element.bitWidth.count(1, option: .all) == 1, "T.Element.bitWidth must be a power of 2", file: file, line: line)
        //=--------------------------------------=
        Test.invariantsAsSomeBitCastable(type, file: file, line: line)
    }
    
    public static func invariantsAsSomeBitCastable<T: BitCastable>(
    _   type: T.Type, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(MemoryLayout<T>.size,      MemoryLayout<T.BitPattern>.size,      "MemoryLayout<T.BitPattern>.size",      file: file, line: line)
        XCTAssertEqual(MemoryLayout<T>.stride,    MemoryLayout<T.BitPattern>.stride,    "MemoryLayout<T.BitPattern>.stride",    file: file, line: line)
        XCTAssertEqual(MemoryLayout<T>.alignment, MemoryLayout<T.BitPattern>.alignment, "MemoryLayout<T.BitPattern>.alignment", file: file, line: line)
    }
}
