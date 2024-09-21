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
import RandomIntKit
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
                Test().elements( 0 as T, [T.Element.Magnitude(load:  0 as T)] + [T.Element.Magnitude](repeating:  0, count: count - 1), Bit.zero)
                Test().elements( 1 as T, [T.Element.Magnitude(load:  1 as T)] + [T.Element.Magnitude](repeating:  0, count: count - 1), Bit.zero)
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
                    
                    Test().elements(integer,           elements,        Bit(!T.isArbitrary && (T.isSigned && elements.last! >= .msb)))
                    Test().elements(integer.toggled(), elements.map(~), Bit( T.isArbitrary || (T.isSigned && elements.last! <  .msb)))
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
                var count = Int(T.isArbitrary ? 12 : IX(size: T.self)! / IX(size: T.Element.Magnitude.self))
                
                check(Array(repeating:  0, count: count), mode:   .signed)
                check(Array(repeating:  1, count: count), mode:   .signed)
                check(Array(repeating: ~1, count: count), mode:   .signed, error: !T.isSigned)
                check(Array(repeating: ~0, count: count), mode:   .signed, error: !T.isSigned)
                
                check(Array(repeating:  0, count: count), mode: .unsigned)
                check(Array(repeating:  1, count: count), mode: .unsigned)
                check(Array(repeating: ~1, count: count), mode: .unsigned, error:  T.isSigned && !T.isArbitrary)
                check(Array(repeating: ~0, count: count), mode: .unsigned, error:  T.isSigned && !T.isArbitrary)
                
                count += 1
                
                check(Array(repeating:  0, count: count), mode:   .signed)
                check(Array(repeating:  1, count: count), mode:   .signed, error: !T.isArbitrary)
                check(Array(repeating: ~1, count: count), mode:   .signed, error:  T.isEdgy)
                check(Array(repeating: ~0, count: count), mode:   .signed, error: !T.isSigned)
                
                check(Array(repeating:  0, count: count), mode: .unsigned)
                check(Array(repeating:  1, count: count), mode: .unsigned, error: !T.isArbitrary)
                check(Array(repeating: ~1, count: count), mode: .unsigned, error: !T.isArbitrary)
                check(Array(repeating: ~0, count: count), mode: .unsigned, error: !T.isArbitrary)
            }
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitArbitraryWhereCountIsInvalidIsNil() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Test().comparison(T.Element.size, Count(1), Signum.positive, id: ComparableID())
            
            for count: IX in [IX.min, IX.min + 1, -1, IX.max - 1, IX.max] as [IX] {
                always: do {
                    Test().none(T.arbitrary(uninitialized: count) { _ in 000000 })
                    Test().none(T.arbitrary(uninitialized: count) { _ in Void() })
                }
                
                for appendix in [Bit.zero, Bit.one] {
                    Test().none(T.arbitrary(uninitialized: count, repeating: appendix) { _ in 000000 })
                    Test().none(T.arbitrary(uninitialized: count, repeating: appendix) { _ in Void() })
                }
            }
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testInitArbitraryIsLikeInitDataIntOrNil() {
        func whereIs<T>(_ type: T.Type, randomness: consuming FuzzerInt) where T: BinaryInteger {
            var source = Array(repeating: T.Element.Magnitude.zero, count: 4)
            
            for _ in 0 ..< 16 {
                source.withUnsafeMutableBytes {
                    randomness.fill($0)
                }
                
                for end: Int in Int.zero ... source.count {
                    always: do {
                        let expectation = source[..<end].withUnsafeBufferPointer {
                            T.isArbitrary ? T(load: DataInt($0)!) : nil
                        }
                        
                        let result0 = T.arbitrary(uninitialized: IX(source.count)) { body in
                            for index in Int.zero ..< end {
                                body[unchecked: IX(index)] = source[index]
                            }
                            
                            return IX(end)
                        }
                        
                        let result1 = T.arbitrary(uninitialized: IX(end)) { body -> Void in
                            for index in Int.zero ..< end {
                                body[unchecked: IX(index)] = source[index]
                            }
                        }
                        
                        Test().same(result0, expectation, "body: \(source[..<end]), bit: default [0]")
                        Test().same(result1, expectation, "body: \(source[..<end]), bit: default [1]")
                    }
                    
                    for bit in [Bit.zero, Bit.one] {
                        let expectation = source[..<end].withUnsafeBufferPointer {
                            T.isArbitrary ? T(load: DataInt($0, repeating: bit)!) : nil
                        }
                        
                        let result0 = T.arbitrary(uninitialized: IX(source.count), repeating: bit) { body in
                            for index in Int.zero ..< end {
                                body[unchecked: IX(index)] = source[index]
                            }
                            
                            return IX(end)
                        }
                        
                        let result1 = T.arbitrary(uninitialized: IX(end), repeating: bit) { body -> Void in
                            for index in Int.zero ..< end {
                                body[unchecked: IX(index)] = source[index]
                            }
                        }
                        
                        Test().same(result0, expectation, "body: \(source[..<end]), appendix: \(bit) [0]")
                        Test().same(result1, expectation, "body: \(source[..<end]), appendix: \(bit) [1]")
                    }
                }
            }
        }
        
        for type in binaryIntegers {
            whereIs(type, randomness: fuzzer)
        }
    }
    
    func testInitSystemsIsLikeInitDataIntOrNil() {
        func whereIs<T>(_ type: T.Type, randomness: consuming FuzzerInt) where T: BinaryInteger {
            let count  = T.isArbitrary ?  IX.zero : IX(size: T.self)! / IX(size: T.Element.self)
            var source = Array(repeating: T.Element.Magnitude.zero, count: Swift.Int(count))
            
            for _ in 0 ..< 16 {
                source.withUnsafeMutableBytes {
                    randomness.fill($0)
                }
                
                let expectation = source.withUnsafeBufferPointer {
                    T.isArbitrary ? nil : T(load: DataInt($0)!)
                }
                
                let result = T.systems {
                    for index in $0.indices {
                        $0[unchecked: index] = source[Int(index)]
                    }
                }
                
                Test().same(result, expectation, "body: \(source)")
            }
        }
        
        for type in binaryIntegers {
            whereIs(type, randomness: fuzzer)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Disambiguation
//=----------------------------------------------------------------------------=

extension BinaryIntegerTestsOnElements {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDisambiguateTokenInitLoadBinaryIntegerWhereElementIsToken() {
        let ix = IX.random()
        let ux = UX.random()
        
        Test().same(IX(load: InfiniInt<IX>(load: ix)), ix)
        Test().same(IX(load: InfiniInt<UX>(load: ix)), ix)
        Test().same(UX(load: InfiniInt<IX>(load: ux)), ux)
        Test().same(UX(load: InfiniInt<UX>(load: ux)), ux)
        
        Test().same(IX(load: DoubleInt<IX>(load: ix)), ix)
        Test().same(IX(load: DoubleInt<UX>(load: ix)), ix)
        Test().same(UX(load: DoubleInt<IX>(load: ux)), ux)
        Test().same(UX(load: DoubleInt<UX>(load: ux)), ux)
    }
}
