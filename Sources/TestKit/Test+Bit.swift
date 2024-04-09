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
        same(Integer(truncating: element), integer)
        same(Integer(load:       element).load(as: Element.self), element)
    }
    
    public func load<Integer, Element>(
        _ integer: Integer,
        _ element: Element
    )   where Integer: BinaryInteger, Element: SystemsInteger<Integer.Element.BitPattern> {
        //=--------------------------------------=
        same(integer.load(as: Element.self), element)
        same(integer.load(as: Element.self), Element(truncating: integer))
        same(Integer(load: element).load(as: Element.self), element)
    }
    
    public func elements<Integer, Element>(
        _ integer: Integer,
        _ expectation: [Element]
    )   where Integer: BinaryInteger, Element: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        integer.withUnsafeBinaryIntegerBody {
            let body = $0.buffer()
            let chunks = Array(ExchangeInt(body, isSigned: Integer.isSigned, as: Element.self).source())
            self.pure(chunks.elementsEqual(expectation), "\(Array(body)).body -> \(chunks)")
            self.elements(chunks, Integer.isSigned, Fallible(integer))
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
