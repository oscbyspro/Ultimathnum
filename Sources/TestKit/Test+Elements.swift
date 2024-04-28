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
    
    public func elements<Integer, Element>(
        _ integer: Integer,
        _ expectation: [Element]
    )   where Integer: BinaryInteger, Element: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        integer.withUnsafeBinaryIntegerElements {
            let body = Array($0.body.buffer())
            let elements = $0.withMemoryRebound(to: U8.self) {
                [Element](LoadInt($0).body())
            }
            
            self.pure(elements.elementsEqual(expectation), "\(Array(body)).body -> \(elements)")
            self.exactly(elements, Integer.mode, Fallible(integer))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func exactly<Input, Output>(
        _ input: Input,
        _ expectation: Fallible<Output>
    )   where Input: BinaryInteger, Output: BinaryInteger {
        //=--------------------------------------=
        same(Output.exactly(input), expectation, "T.exactly(some BinaryInteger)")
        //=--------------------------------------=
        input.withUnsafeBinaryIntegerBody {
            let body = Array($0.buffer())
            self.exactly(body, Input.mode, expectation)
        }
        
        input.withUnsafeBinaryIntegerElements {
            same(Output.exactly($0, mode: Input.mode), expectation, "Integer.exactly(_:mode:) [0]")
        }
        
        input.withUnsafeBinaryIntegerElementsAsBytes {
            same(Output.exactly(LoadInt($0), mode: Input.mode), expectation, "Integer.exactly(_:mode:) [1]")
        }
    }
    
    public func exactly<Integer, Element>(
        _ body: [Element],
        _ mode: some Signedness,
        _ expectation: Fallible<Integer>
    )   where Integer: BinaryInteger, Element: SystemsInteger & UnsignedInteger {
        body.withUnsafeBufferPointer {
            let appendix = Bit(mode.isSigned && ($0.last ?? 0) >= Element.msb)
            let elements = DataInt($0, repeating: appendix)!
            
            same(Integer.exactly(elements, mode: mode), expectation, "Integer.exactly(_:mode:) - DataInt")

            elements.withMemoryRebound(to: U8.self) {
                same(Integer.exactly(LoadInt($0), mode: mode), expectation, "Integer.exactly(_:mode:) - LoadInt")
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Test Suite
//=----------------------------------------------------------------------------=

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func commonInitBody<T>(_ type: T.Type, id: SystemsIntegerID) where T: SystemsInteger {
        typealias S = T.Signitude
        typealias M = T.Magnitude
        typealias F = Fallible<T>
        //=----------------------------------=
        self.commonInitBody(T.self, id: BinaryIntegerID())
        //=----------------------------------=
        self.exactly( (S).min, F( T(raw: (S).min), error: T.isSigned == false))
        self.exactly( (S).lsb, F( T(raw: (S).lsb)))
        self.exactly( (S).msb, F( T(raw: (S).msb), error: T.isSigned == false))
        self.exactly( (S).max, F( T(raw: (S).max)))
        
        self.exactly(~(S).min, F(~T(raw: (S).min)))
        self.exactly(~(S).lsb, F(~T(raw: (S).lsb), error: T.isSigned == false))
        self.exactly(~(S).msb, F(~T(raw: (S).msb)))
        self.exactly(~(S).max, F(~T(raw: (S).max), error: T.isSigned == false))
        
        self.exactly( (M).min, F( T(raw: (M).min)))
        self.exactly( (M).lsb, F( T(raw: (M).lsb)))
        self.exactly( (M).msb, F( T(raw: (M).msb), error: T.isSigned == true ))
        self.exactly( (M).max, F( T(raw: (M).max), error: T.isSigned == true ))
        
        self.exactly(~(M).min, F(~T(raw: (M).min), error: T.isSigned == true))
        self.exactly(~(M).lsb, F(~T(raw: (M).lsb), error: T.isSigned == true))
        self.exactly(~(M).msb, F(~T(raw: (M).msb)))
        self.exactly(~(M).max, F(~T(raw: (M).max)))
    }
    
    public func commonInitBody<T>(_ type: T.Type, id: BinaryIntegerID) where T: BinaryInteger {
        typealias S = T.Signitude
        typealias M = T.Magnitude
        typealias F = Fallible<T>
        //=----------------------------------=
        self.commonInitBodyByArray(T.self, id: BinaryIntegerID())
        //=----------------------------------=
        self.exactly( I32.min, F( T(load:  I32.min), error: T.size < 32 || (T.isSigned == false)))
        self.exactly( I32.lsb, F( T(load:  I32.lsb)))
        self.exactly( I32.msb, F( T(load:  I32.msb), error: T.size < 32 || (T.isSigned == false)))
        self.exactly( I32.max, F( T(load:  I32.max), error: T.size < 32))
        
        self.exactly(~I32.min, F(~T(load:  I32.min), error: T.size < 32))
        self.exactly(~I32.lsb, F(~T(load:  I32.lsb), error: T.isSigned == false))
        self.exactly(~I32.msb, F(~T(load:  I32.msb), error: T.size < 32))
        self.exactly(~I32.max, F(~T(load:  I32.max), error: T.size < 32 || (T.isSigned == false)))
        
        self.exactly( U32.min, F( T(load:  U32.min)))
        self.exactly( U32.lsb, F( T(load:  U32.lsb)))
        self.exactly( U32.msb, F( T(load:  U32.msb), error: T.size < 32 || (T.isSigned && T.size == 32)))
        self.exactly( U32.max, F( T(load:  U32.max), error: T.size < 32 || (T.isSigned && T.size == 32)))
        
        self.exactly(~U32.min, F( T(load: ~U32.min), error: T.size < 32 || (T.isSigned && T.size == 32)))
        self.exactly(~U32.lsb, F( T(load: ~U32.lsb), error: T.size < 32 || (T.isSigned && T.size == 32)))
        self.exactly(~U32.msb, F( T(load: ~U32.msb), error: T.size < 32))
        self.exactly(~U32.max, F( T(load: ~U32.max)))
        //=----------------------------------=
        self.exactly([T.Element.Magnitude](),   .signed, F(T.zero))
        self.exactly([T.Element.Magnitude](), .unsigned, F(T.zero))
    }
    
    public func commonInitBodyByArray<T>(_ type: T.Type, id: BinaryIntegerID) where T: BinaryInteger {
        //=--------------------------------------=
        var count = Int(T.size.isInfinite ? 12 : IX(load: T.size) / IX(size: T.Element.self))
        //=--------------------------------------=
        func check(_ body: Array<T.Element.Magnitude>, mode: some Signedness, error: Bool = false) {
            var value = T(repeating: Bit(mode.isSigned && (body.last ?? 0) >= .msb))
            
            for element in body.reversed() {
                value <<= T(T.Element.Magnitude.size)
                value  |= T(load: element)
            }
            
            self.exactly(body, mode, Fallible(value, error: error))
        }
        //=--------------------------------------=
        check(Array(repeating:  0, count: count), mode:   .signed)
        check(Array(repeating:  1, count: count), mode:   .signed)
        check(Array(repeating: ~1, count: count), mode:   .signed, error: !T.isSigned)
        check(Array(repeating: ~0, count: count), mode:   .signed, error: !T.isSigned)
        
        check(Array(repeating:  0, count: count), mode: .unsigned)
        check(Array(repeating:  1, count: count), mode: .unsigned)
        check(Array(repeating: ~1, count: count), mode: .unsigned, error:  T.isSigned && !T.size.isInfinite)
        check(Array(repeating: ~0, count: count), mode: .unsigned, error:  T.isSigned && !T.size.isInfinite)
        
        count += 1
        
        check(Array(repeating:  0, count: count), mode:   .signed)
        check(Array(repeating:  1, count: count), mode:   .signed, error: !T.size.isInfinite)
        check(Array(repeating: ~1, count: count), mode:   .signed, error: !T.isSigned || !T.size.isInfinite)
        check(Array(repeating: ~0, count: count), mode:   .signed, error: !T.isSigned)

        check(Array(repeating:  0, count: count), mode: .unsigned)
        check(Array(repeating:  1, count: count), mode: .unsigned, error: !T.size.isInfinite)
        check(Array(repeating: ~1, count: count), mode: .unsigned, error: !T.size.isInfinite)
        check(Array(repeating: ~0, count: count), mode: .unsigned, error: !T.size.isInfinite)
    }
}
