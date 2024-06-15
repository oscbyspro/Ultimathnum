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
        same(Integer(load: element),     integer)
        same(Element(load: Integer(load: element)), element)
        //=--------------------------------------=
        if  Element.isSigned, Element.size <= UX.size || Element.size < UX.size {
            same(Integer(load: IX(load: element)),    integer)
            same(Element(load: Integer(load: IX(load: element))), element)
        }
        
        if !Element.isSigned, Element.size <= UX.size {
            same(Integer(load: UX(load: element)),    integer)
            same(Element(load: Integer(load: UX(load: element))), element)
        }
    }
    
    public func load<Integer, Element>(
        _ integer: Integer,
        _ element: Element
    )   where Integer: BinaryInteger, Element: SystemsInteger<Integer.Element.BitPattern> {
        //=--------------------------------------=
        same(Element(load: integer),     element)
        same(Element(load: Integer(load: element)), element)
        //=--------------------------------------=
        if  Element.isSigned, Element.size <= UX.size || Element.size < UX.size {
            same(Element(load: IX(load: integer)),     element)
            same(Element(load: Integer(load: IX(load: integer))), element)
        }
        
        if !Element.isSigned, Element.size <= UX.size {
            same(Element(load: UX(load: integer)),     element)
            same(Element(load: Integer(load: UX(load: integer))), element)
        }
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
        let bodyAsBytes: [U8] = body.withUnsafeBytes {
            $0.map(U8.init(_:))
        }
        //=--------------------------------------=
        // section: init(load: Element) stuff
        //=--------------------------------------=
        if  body.count <= 1 {
            let comparand = !body.isEmpty ? body : [Element.Magnitude(repeating: appendix)]
            same([Element.Magnitude(load: Element.Signitude(load: integer))], comparand, "load(as:) [0]")
            same([Element.Magnitude(load: Element.Magnitude(load: integer))], comparand, "load(as:) [1]")
        }
        
        if  body.count <= 1 {
            let element = Element.Signitude(load: integer)
            if  element.appendix == appendix {
                same(Integer(load:  element), integer, "init(load:) [0]")
            }   else {
                let mask: Integer = Integer(repeating: 1) << Integer(Integer.Element.size)
                same(Integer(load:  element) ^ mask, integer, "init(load:) [1]")
            }
        }
        
        if  body.count <= 1 {
            let element = Element.Magnitude(load: integer)
            if  element.appendix == appendix {
                same(Integer(load:  element), integer, "init(load:) [2]")
            }   else {
                same(Integer(load:  element.toggled()).toggled(), integer, "init(load:) [3]")
            }
        }
        //=--------------------------------------=
        // section: binary integer body
        //=--------------------------------------=
        integer.withUnsafeBinaryIntegerBody {
            yay ($0.buffer().elementsEqual(body), "body")
            same($0.appendix, Bit.zero, "body appendix is always zero")
        }
        
        integer.withUnsafeBinaryIntegerBody(as: U8.self) {
            yay ($0.buffer().elementsEqual(bodyAsBytes), "body-as-bytes")
            same($0.appendix, Bit.zero, "body-as-bytes appendix is always zero")
        }
        
        if  var mutableInteger = Optional.some(integer) {
            mutableInteger.withUnsafeMutableBinaryIntegerBody {
                yay ($0.buffer().elementsEqual(body), "mutable body")
                same($0.appendix, Bit.zero, "mutable body appendix is always zero")
                $0.initialize(repeating: Element.Magnitude(repeating: appendix))
            }
            
            same(mutableInteger, Integer(repeating: appendix), "override mutable body")
        }
        
        if  var mutableInteger = Optional.some(integer) {
            mutableInteger.withUnsafeMutableBinaryIntegerBody(as: U8.self) {
                yay ($0.buffer().elementsEqual(bodyAsBytes), "mutable body-as-bytes")
                same($0.appendix, Bit.zero, "mutable body-as-bytes appendix is always zero")
                $0.initialize(repeating: U8(repeating: appendix))
            }
            
            same(mutableInteger, Integer(repeating: appendix), "override mutable body-as-bytes")
        }
        //=--------------------------------------=
        // section: binary integer elements
        //=--------------------------------------=
        (copy integer).withUnsafeBinaryIntegerElements {
            yay ($0.body.buffer().elementsEqual(body), "elements body")
            same($0.appendix, appendix, "elements appendix")
            same(Integer($0, mode: Integer.mode), integer, "exactly elements")
        }
        
        (copy integer).withUnsafeBinaryIntegerElements(as: U8.self) {
            yay ($0.body.buffer().elementsEqual(bodyAsBytes), "elements-as-bytes body")
            same($0.appendix, appendix, "elements-as-bytes appendix")
            same(Integer($0, mode: Integer.mode), integer, "exactly elements-as-bytes")
        }
        
        if  var mutableInteger = Optional.some(integer) {
            mutableInteger.withUnsafeMutableBinaryIntegerElements {
                yay ($0.body.buffer().elementsEqual(body), "mutable elements body")
                same($0.appendix, appendix, "mutable elements appendix")
                $0.body.initialize(repeating: Element.Magnitude(repeating: appendix))
            }
            
            same(mutableInteger, Integer(repeating: appendix), "override mutable elements body")
        }
        
        if  var mutableInteger = Optional.some(integer) {
            mutableInteger.withUnsafeMutableBinaryIntegerElements(as: U8.self) {
                yay ($0.body.buffer().elementsEqual(bodyAsBytes), "mutable elements-as-bytes body")
                same($0.appendix, appendix, "mutable elements-as-bytes appendix")
                $0.body.initialize(repeating: U8(repeating: appendix))
            }
            
            same(mutableInteger, Integer(repeating: appendix), "override mutable elements-as-bytes body")
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
                
                if !expectation.error, $0.entropy() <= UX.size {
                    let word = $0.load(as: UX.self)
                    
                    if  Integer.isSigned {
                        same(Integer(load:  ix(word)), expectation.value,   "T.init(load:) - IX")
                        same(IX(raw: word), IX(load:   expectation.value), "IX.init(load:) - T" )
                    }   else {
                        same(Integer(load:  ux(word)), expectation.value,   "T.init(load:) - UX")
                        same(UX(raw: word), UX(load:   expectation.value), "UX.init(load:) - T" )
                    }
                }
            }
        }
    }
}
