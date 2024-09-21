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
            Test().elements(~1 as T, [~1] as [T.Element.Magnitude], Bit.one )
            Test().elements(~0 as T, [  ] as [T.Element.Magnitude], Bit.one )
            Test().elements( 0 as T, [  ] as [T.Element.Magnitude], Bit.zero)
            Test().elements( 1 as T, [ 1] as [T.Element.Magnitude], Bit.zero)
            
            always: do {
                var instance = T(repeating: Bit.zero)
                var body = Array<T.Element.Magnitude>()
                
                for element: T.Element.Magnitude in (0 ..< 12).lazy.map(~) {
                    instance <<= T(load: IX(size: T.Element.Magnitude.self))
                    instance  |= T(load: element)
                    body.insert(element, at: Int.zero)
                    Test().elements(instance, body, Bit.zero)
                }
            }

            always: do {
                var instance = T(repeating: Bit.one)
                var body = Array<T.Element.Magnitude>()
                
                for element: T.Element.Magnitude in (0 ..< 12) {
                    instance <<= T(load: IX(size: T.Element.Magnitude.self))
                    instance  |= T(load: element)
                    body.insert(element, at: Int.zero)
                    Test().elements(instance, body, Bit.one)
                }
            }
        }

        for type in Self.types {
            whereIs(type)
        }
    }
}
