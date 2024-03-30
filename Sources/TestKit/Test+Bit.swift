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
// MARK: * Test x Elements
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Elements
    //=------------------------------------------------------------------------=
    
    public static func load<Integer, Element>(
        _ element: Element, 
        _ integer: Integer,
        file: StaticString = #file,
        line: UInt = #line
    )   where Integer: BinaryInteger, Element: SystemsInteger<Integer.Element.BitPattern> {
        //=--------------------------------------=
        XCTAssertEqual(Integer(load:       element), integer, file: file, line: line)
        XCTAssertEqual(Integer(truncating: element), integer, file: file, line: line)
        XCTAssertEqual(Integer(load:       element).load(as:  Element.self), element, file: file, line: line)
    }
    
    public static func load<Integer, Element>(
        _ integer: Integer,
        _ element: Element,
        file: StaticString = #file,
        line: UInt = #line
    )   where Integer: BinaryInteger, Element: SystemsInteger<Integer.Element.BitPattern> {
        //=--------------------------------------=
        XCTAssertEqual(integer.load(as: Element.self), element, file: file, line: line)
        XCTAssertEqual(integer.load(as: Element.self), Element(truncating: integer), file: file, line: line)
        XCTAssertEqual(Integer(load: element).load(as: Element.self), element, file: file, line: line)
    }
    
    public static func elements<Integer, Element>(
        _ integer: Integer, 
        _ expectation: [Element],
        file: StaticString = #file,
        line: UInt = #line
    )   where Integer: BinaryInteger, Element: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        let elements = ExchangeInt(integer, as: Element.self).source()
        //=--------------------------------------=
        brr: do {
            XCTAssert(elements.elementsEqual(expectation), "\(integer).elements -> \(Array(elements))", file: file, line: line)
        }
        
        brr: do {
            Test.elements(Array(elements), Integer.isSigned, Fallible(integer), file: file, line: line)
        }
    }
    
    public static func elements<Integer: BinaryInteger, Element: SystemsInteger & UnsignedInteger>(
        _ elements: [Element], 
        _ isSigned: Bool, 
        _ expectation: Fallible<Integer>,
        file: StaticString = #file,
        line: UInt = #line
    )   where Integer: BinaryInteger, Element: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        let elements = ExchangeInt(elements, isSigned: isSigned, as: Integer.Element.Magnitude.self)
        //=--------------------------------------=
        brr: do {
            XCTAssertEqual(Integer.exactly(elements: elements, isSigned: isSigned), expectation, file: file, line: line)
        }
    }
}
