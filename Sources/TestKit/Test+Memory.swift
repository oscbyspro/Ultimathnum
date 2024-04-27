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
// MARK: * Test x Memory
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
        same(Integer(load: element), integer)
        same(Integer(load: element), integer)
        same(Integer(load: element).load(as: Element.self), element)
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
        integer.withUnsafeBinaryIntegerElements {
            let body = Array($0.body.buffer())
            let elements = $0.withMemoryRebound(to: U8.self) {
                [Element](LoadInt($0).source())
            }
            
            self.pure(elements.elementsEqual(expectation), "\(Array(body)).body -> \(elements)")
            self.elements(elements, Integer.mode, Fallible(integer))
        }
    }
    
    public func elements<Integer, Element>(
        _ body: [Element],
        _ mode: some Signedness,
        _ expectation: Fallible<Integer>
    )   where Integer: BinaryInteger, Element: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        body.withUnsafeBufferPointer {
            let appendix = Bit(mode.isSigned && ($0.last ?? 0) >= Element.msb)
            let elements = DataInt($0,  repeating: appendix)!
            same(Integer.exactly(elements, mode: mode), expectation, "Integer.exactly(body:isSigned:)")
        }
    }
}
