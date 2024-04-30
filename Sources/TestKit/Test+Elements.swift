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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func elements<Integer>(
        _ integer: Integer,
        _ body: [Integer.Element.Magnitude],
        _ appendix: Bit
    )   where Integer: BinaryInteger {
        //=--------------------------------------=
        let expectation = Fallible(integer)
        //=--------------------------------------=
        integer.withUnsafeBinaryIntegerElements {
            same(Array($0.body.buffer()), body, "body")
            same(appendix, $0.appendix, "appendix")
            same(Integer.exactly($0, mode: Integer.mode), expectation, "rountrip")
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func exactly<Integer, Element>(
        _ body: [Element],
        _ mode: some Signedness,
        _ expectation: Fallible<Integer>
    )   where Integer: BinaryInteger, Element: SystemsInteger & UnsignedInteger {
        body.withUnsafeBufferPointer {
            //=----------------------------------=
            let appendix = Bit(mode.isSigned && ($0.last ?? 0) >= Element.msb)
            let elements = DataInt($0, repeating: appendix)!
            //=----------------------------------=
            same(Integer.exactly(elements, mode: mode), expectation, "Integer.exactly(_:mode:) - DataInt")

            elements.withMemoryRebound(to: U8.self) {
                same(Integer.exactly(LoadInt($0), mode: mode), expectation, "Integer.exactly(_:mode:) - LoadInt")
            }
        }
    }
}
