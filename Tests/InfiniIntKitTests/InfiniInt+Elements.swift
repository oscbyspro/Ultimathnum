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
    
    func testMakeBody() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            Test().elements(~1 as T, [~1] as [T.Element.Magnitude], 1 as Bit)
            Test().elements(~0 as T, [  ] as [T.Element.Magnitude], 1 as Bit)
            Test().elements( 0 as T, [  ] as [T.Element.Magnitude], 0 as Bit)
            Test().elements( 1 as T, [ 1] as [T.Element.Magnitude], 0 as Bit)
            
            always: do {
                var instance = T(repeating: 0)
                var body = Array<T.Element.Magnitude>()
                
                for element: T.Element.Magnitude in (0 ..< 12).lazy.map(~) {
                    instance <<= T(load: IX(size: T.Element.Magnitude.self))
                    instance  |= T(load: element)
                    body.insert(element, at: Int.zero)
                    Test().elements(instance, body, 0)
                }
            }

            always: do {
                var instance = T(repeating: 1)
                var body = Array<T.Element.Magnitude>()
                
                for element: T.Element.Magnitude in (0 ..< 12) {
                    instance <<= T(load: IX(size: T.Element.Magnitude.self))
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
