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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func load<Integer, Element>(
        _ element: Element, 
        _ integer: Integer
    )   where Integer: BinaryInteger, Element: SystemsInteger<Integer.Element.BitPattern> {
        //=--------------------------------------=
        same(Integer(load:       element), integer)
        same(Integer(load: element), integer)
        same(Integer(load:       element).load(as: Element.self), element)
    }
    
    public func load<Integer, Element>(
        _ integer: Integer,
        _ element: Element
    )   where Integer: BinaryInteger, Element: SystemsInteger<Integer.Element.BitPattern> {
        //=--------------------------------------=
        same(integer.load(as: Element.self), element)
        same(integer.load(as: Element.self), Element(load: integer))
        same(Integer(load: element).load(as: Element.self), element)
    }
    
    public func elements<Integer, Element>(
        _ integer: Integer,
        _ expectation: [Element]
    )   where Integer: BinaryInteger, Element: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        integer.withUnsafeBinaryIntegerMemory {
            let body = Array($0.body.buffer())
            let elements = $0.withMemoryRebound(to: U8.self) {
                [Element](ExchangeInt($0).body())
            }
            
            self.pure(elements.elementsEqual(expectation), "\(Array(body)).body -> \(elements)")
            self.elements(elements, Integer.isSigned, Fallible(integer))
        }
    }
    
    public func elements<Integer, Element>(
        _ body: [Element],
        _ isSigned: Bool,
        _ expectation: Fallible<Integer>
    )   where Integer: BinaryInteger, Element: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        same(Integer.exactly(body: body, isSigned: isSigned), expectation, "Integer.exactly(body:isSigned:)")
    }
}
