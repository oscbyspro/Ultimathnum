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
        typealias Element = Integer.Element
        //=--------------------------------------=
        let expectation = Fallible(integer)
        //=--------------------------------------=
        if  body.count <= 1 {
            let comparand = !body.isEmpty ? body : [Element.Magnitude(repeating: appendix)]
            same([Element.Magnitude(raw: integer.load(as: Element.Signitude.self))], comparand, "load(as:) [0]")
            same([Element.Magnitude(raw: integer.load(as: Element.Magnitude.self))], comparand, "load(as:) [1]")
        }
        
        if  body.count <= 1 {
            let element = integer.load(as: Element.Signitude.self)
            if  element.appendix == appendix {
                same(Integer(load:  element), expectation.value, "init(load:) [0]")
            }   else {
                let mask: Integer = Integer(repeating: 1) << Integer(Integer.Element.size)
                same(Integer(load:  element) ^ mask, expectation.value, "init(load:) [1]")
            }
        }
        
        if  body.count <= 1 {
            let element = integer.load(as: Element.Magnitude.self)
            if  element.appendix == appendix {
                same(Integer(load:  element), expectation.value, "init(load:) [2]")
            }   else {
                same(Integer(load:  element.toggled()).toggled(), expectation.value, "init(load:) [3]")
            }
        }
        //=--------------------------------------=
        integer.withUnsafeBinaryIntegerElements {
            same(Array($0.body.buffer()), body, "body [0]")
            same(appendix, $0.appendix, "appendix [0]")
            same(Integer.exactly($0, mode: Integer.mode), expectation, "rountrip [0]")
        }
        
        integer.withUnsafeBinaryIntegerElements(as: U8.self) {
            same(appendix, $0.appendix, "appendix [1]")
            same(Integer.exactly($0, mode: Integer.mode), expectation, "rountrip [1]")
        }
        //=--------------------------------------=
        if  var mutableInteger = Optional.some(integer) {
            mutableInteger.withUnsafeMutableBinaryIntegerElements {
                same(Array($0.body.buffer()), body, "body [2]")
                same(appendix, $0.appendix, "appendix [2]")
                $0.body.initialize(repeating: Element.Magnitude(repeating: $0.appendix))
            }
            
            same(mutableInteger, Integer(repeating: appendix), "override body [2]")
        }
        
        if  var mutableInteger = Optional.some(integer) {
            mutableInteger.withUnsafeMutableBinaryIntegerElements(as: U8.self) {
                same(appendix, $0.appendix, "appendix [3]")
                $0.body.initialize(repeating: U8(repeating: $0.appendix))
            }
            
            same(mutableInteger, Integer(repeating: appendix), "override body [3]")
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
        //=--------------------------------------=
        func ix(_ element: UX) -> some SystemsInteger<UX.BitPattern> { IX(raw: element) }
        func ux(_ element: UX) -> some SystemsInteger<UX.BitPattern> { UX(raw: element) }
        //=--------------------------------------=
        body.withUnsafeBufferPointer {
            //=----------------------------------=
            let appendix = Bit(mode.matchesSignedTwosComplementFormat && ($0.last ?? 0) >= Element.msb)
            let elements = DataInt($0, repeating: appendix)!
            //=----------------------------------=
            if !expectation.error {
                same(Integer(load: elements), expectation.value, "T.init(load:) - DataInt")
            }
            
            always: do {
                same(Integer.exactly(elements, mode: mode), expectation, "T.exactly(_:mode:) - DataInt")
            }
            
            elements.reinterpret(as: U8.self) {
                same(Integer.exactly($0, mode: mode), expectation, "T.exactly(_:mode:) - DataInt<U8>")
                
                if !expectation.error, $0.count(.entropy) <= UX.size {
                    let word = $0.load(as: UX.self)
                    
                    if  Integer.isSigned {
                        same(Integer(load:  ix(word)), expectation.value, "T.init(load:) - IX")
                        same(IX(raw: word), expectation.value.load(as: IX.self), "T/load(as:) - IX")
                    }   else {
                        same(Integer(load:  ux(word)), expectation.value, "T.init(load:) - UX")
                        same(UX(raw: word), expectation.value.load(as: UX.self), "T/load(as:) - UX")
                    }
                }
            }
        }
    }
}
