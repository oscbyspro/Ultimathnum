//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Elements
//*============================================================================*

final class BinaryIntegerTestsOnElements: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testElements() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            if  let size  = IX(size: T.self) {
                let count = Swift.Int(size / IX(size: T.Element.Magnitude.self))
                
                Test().elements(~1 as T, [T.Element.Magnitude(load: ~1 as T)] + [T.Element.Magnitude](repeating: ~0, count: count - 1), Bit(T.isSigned))
                Test().elements(~0 as T, [T.Element.Magnitude(load: ~0 as T)] + [T.Element.Magnitude](repeating: ~0, count: count - 1), Bit(T.isSigned))
                Test().elements( 0 as T, [T.Element.Magnitude(load:  0 as T)] + [T.Element.Magnitude](repeating:  0, count: count - 1), 000000000000000)
                Test().elements( 1 as T, [T.Element.Magnitude(load:  1 as T)] + [T.Element.Magnitude](repeating:  0, count: count - 1), 000000000000000)
            }
            
            element: do {
                let mask = T(load: T.Element.Magnitude.max)
                
                var x = ~9 as T
                var y = ~9 as T.Element.Magnitude.Signitude
                var z = ~9 as T.Element.Magnitude.Magnitude
                
                for _ in 0 ..< 20 {
                    Test().load(y,  x)
                    Test().load(z,  x & mask)
                    
                    Test().load(x,  y)
                    Test().load(x & mask,  y)
                    
                    x &+= 1
                    y &+= 1
                    z &+= 1
                }
            }
            
            sequences: do {
                let size = UX(Esque<T>.shl + 1)
                
                for offset: UX in (1 ... 12).lazy.map({ $0 &* size >> 3 }) {
                    var element = T.Element.Magnitude.zero
                    var integer = T.zero
                    var elements: [T.Element.Magnitude] = []
                    
                    for x in (1 ... size >> 3).lazy.map({ $0  &+ offset }) {
                        integer <<= 8
                        element <<= 8
                        integer  |= T(load: x & 0xFF)
                        element  |= T.Element.Magnitude(load: x & 0xFF)
                        
                        if  x % UX(size: T.Element.Magnitude.self) >> 3 == 0 {
                            elements.insert(element, at: 0)
                        }
                    }
                    
                    Test().elements(integer,           elements,        Bit(!T.size.isInfinite && T.isSigned && elements.last! >= .msb))
                    Test().elements(integer.toggled(), elements.map(~), Bit( T.size.isInfinite || T.isSigned && elements.last! <  .msb))
                }
            }
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testExactlyArrayBodyMode() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Test().exactly([T.Element.Magnitude](),   .signed, Fallible(T.zero))
            Test().exactly([T.Element.Magnitude](), .unsigned, Fallible(T.zero))
            
            func check(_ body: [T.Element.Magnitude], mode: Signedness, error: Bool = false, file: StaticString = #file, line: UInt = #line) {
                var value = T(repeating: Bit(mode == .signed && (body.last ?? 0) >= .msb))
                
                for element in body.reversed() {
                    value <<= T(load: IX(size: T.Element.Magnitude.self))
                    value  |= T(load: element)
                }
                
                Test(file: file, line: line).exactly(body, mode, Fallible(value, error: error))
            }
            
            always: do {
                var count = Int(T.size.isInfinite ? 12 : IX(size: T.self)! / IX(size: T.Element.Magnitude.self))
                
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
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitArbitraryIsLikeInitDataIntOrNil() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var source = Array<T.Element.Magnitude>(repeating: 0, count: 3)
            let elements = (IX(-2) ... IX(2)).map(T.Element.Magnitude.init(load:))
            
            for c: T.Element.Magnitude in elements {
                for b: T.Element.Magnitude in elements {
                    for a: T.Element.Magnitude in elements {
                        
                        source[0] = a
                        source[1] = b
                        source[2] = c
                        
                        for count: Int in Int.zero ... source.count {
                            for appendix: Bit in [0, 1] {
                                
                                let expectation = source[..<count].withUnsafeBufferPointer {
                                    !T.size.isInfinite ? nil : T(load: DataInt($0, repeating: appendix)!)
                                }
                                
                                let resultIX = T.arbitrary(uninitialized: 3, repeating: appendix) {
                                    for index in Int.zero ..< count {
                                        $0[unchecked: IX(index)] = source[index]
                                    }
                                    
                                    return IX(count)
                                }
                                
                                let resultVoid = T.arbitrary(uninitialized: IX(count), repeating: appendix) {
                                    for index in Int.zero ..< count {
                                        $0[unchecked: IX(index)] = source[index]
                                    }
                                    
                                    return (((( ))))
                                }
                                
                                Test().same(resultIX,   expectation, "body: \(source[..<count]), appendix: \(appendix) [IX]")
                                Test().same(resultVoid, expectation, "body: \(source[..<count]), appendix: \(appendix) [Void]")
                            }
                        }
                    }
                }
            }
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testInitArbitraryWhereCountIsInvalidIsNil() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Test().comparison(T.Element.size, Count(1), Signum.more, id: ComparableID())
            
            for count: IX in [IX.min, IX.min + 1, -1, IX.max - 1, IX.max] as [IX] {
                for appendix: Bit in [0, 1] {
                    Test().none(T.arbitrary(uninitialized: count, repeating: appendix) { _ -> IX   in 0 })
                    Test().none(T.arbitrary(uninitialized: count, repeating: appendix) { _ -> Void in   })
                }
            }
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
}
