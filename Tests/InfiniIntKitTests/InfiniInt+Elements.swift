//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Infini Int x Elements
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBody() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            IntegerInvariants(T.self).elements()
            IntegerInvariants(T.self).exactlyArrayBodyMode()
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testMakeBody() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            typealias E = T.Element.Magnitude
            
            Test().elements(~1 as T, [~1] as [E], 1 as Bit)
            Test().elements(~0 as T, [  ] as [E], 1 as Bit)
            Test().elements( 0 as T, [  ] as [E], 0 as Bit)
            Test().elements( 1 as T, [ 1] as [E], 0 as Bit)
            
            always: do {
                var instance = T(repeating: 0)
                var body = Array<E>()
                
                for element: E in (0 ..< 12).lazy.map(~) {
                    instance <<= T(load: E.size)
                    instance  |= T(load: element)
                    body.insert(element, at: Int.zero)
                    Test().elements(instance, body, 0)
                }
            }

            always: do {
                var instance = T(repeating: 1)
                var body = Array<E>()
                
                for element: E in (0 ..< 12) {
                    instance <<= T(load: E.size)
                    instance  |= T(load: element)
                    body.insert(element, at: Int.zero)
                    Test().elements(instance, body, 1)
                }
            }
        }

        for type in Self.types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// The initializer takes any sequence, but it's almost always an array.
    func testInitNonContiguousBody() {
        func whereTheElementTypeIs<E>(_ element: E.Type) where E: SystemsInteger {
            typealias T = InfiniInt<E>
            //=----------------------------------=
            let body: Range<U8> = 1 ..< 5
            //=----------------------------------=
            Test().same(T(body),                             T(0x04030201))
            Test().same(T(body.dropFirst(1)),                T(0x00040302))
            Test().same(T(body.dropFirst(2)),                T(0x00000403))
            Test().same(T(body.dropFirst(3)),                T(0x00000004))
            Test().same(T(body.dropFirst(4)),                T(0x00000000))
            
            Test().same(T(body,              repeating: 0),  T(0x04030201))
            Test().same(T(body.dropFirst(1), repeating: 0),  T(0x00040302))
            Test().same(T(body.dropFirst(2), repeating: 0),  T(0x00000403))
            Test().same(T(body.dropFirst(3), repeating: 0),  T(0x00000004))
            Test().same(T(body.dropFirst(4), repeating: 0),  T(0x00000000))
            
            Test().same(T(body,              repeating: 1), ~T(0xfbfcfdfe))
            Test().same(T(body.dropFirst(1), repeating: 1), ~T(0x00fbfcfd))
            Test().same(T(body.dropFirst(2), repeating: 1), ~T(0x0000fbfc))
            Test().same(T(body.dropFirst(3), repeating: 1), ~T(0x000000fb))
            Test().same(T(body.dropFirst(4), repeating: 1), ~T(0x00000000))
        }
        
        for element in Self.elements {
            whereTheElementTypeIs(element)
        }
    }
}
