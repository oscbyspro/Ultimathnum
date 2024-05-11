//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Core Int x Elements
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBody() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).exactlyArrayBodyMode()
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    func testMakeBody() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).elements()
        }

        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    func testElementsCanBeRebound() {
        func whereIs<T, U>(_ type: T.Type, _ destination: U.Type) where T: SystemsInteger, U: SystemsInteger {
            Test().same(T.elementsCanBeRebound(to: U.self), T.size >= U.size)

            if  T.size < U.size, var value = Optional(T.zero) {
                Test().none(value.withUnsafeBinaryIntegerElements(as:        U.Magnitude.self, perform:{ _ in }))
                Test().none(value.withUnsafeMutableBinaryIntegerElements(as: U.Magnitude.self, perform:{ _ in }))
            }
        }

        for source in coreSystemsIntegers {
            for destination in coreSystemsIntegers {
                whereIs(source, destination)
            }
        }
    }
}
