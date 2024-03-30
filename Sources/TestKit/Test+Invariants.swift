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
// MARK: * Test x Invariants
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func invariants<T>(
        _ type: T.Type, 
        file: StaticString = #file,
        line: UInt = #line,
        identifier: SystemsIntegerID = .init()
    )   where T: SystemsInteger {
        //=--------------------------------------=
        XCTAssertEqual(
            T.bitWidth.count(1, option: .all), 
            T.Magnitude(1),
            "\(T.self).bitWidth must be a power of 2",
            file: file,
            line: line
        )
        XCTAssertGreaterThanOrEqual(
            UX(bitWidth: T.self), 
            UX(bitWidth: T.Element.self),
            "\(T.self) must be at least as wide as \(T.Element.self)",
            file: file, 
            line: line
        )
        //=--------------------------------------=
        Test.equal(MemoryLayout<T>.self, MemoryLayout<T.Content>.self, file: file, line: line)
        //=--------------------------------------=
        Test.invariants(type, file: file, line: line, identifier: BinaryIntegerID())
    }
    
    public static func invariants<T>(
        _ type: T.Type,
        file: StaticString = #file,
        line: UInt = #line,
        identifier: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        //=--------------------------------------=
        XCTAssertEqual(
            T.Element.bitWidth.count(1, option: .all),
            T.Element.Magnitude(1),
            "\(T.Element.self).bitWidth must be a power of 2",
            file: file,
            line: line
        )
        //=--------------------------------------=
        XCTAssertEqual( T.isSigned, T.self is any   SignedInteger.Type, file: file, line: line)
        XCTAssertEqual(!T.isSigned, T.self is any UnsignedInteger.Type, file: file, line: line)
        //=--------------------------------------=
        Test.invariants(type, file: file, line: line, identifier: BitCastableID())
    }
    
    public static func invariants<T>(
        _ type: T.Type,
        file: StaticString = #file,
        line: UInt = #line,
        identifier: BitCastableID // = .init()
    )   where T: BitCastable {
        Test.equal(MemoryLayout<T>.self, MemoryLayout<T.BitPattern>.self, file: file, line: line)
    }
}
