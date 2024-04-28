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
// MARK: * Infinit Int x Elements
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBody() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Test().commonInitBody(T.self, id: BinaryIntegerID())
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
}
