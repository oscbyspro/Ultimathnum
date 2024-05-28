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
import TestKit

//*============================================================================*
// MARK: * Core Int x Text
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Pyramids
    //=------------------------------------------------------------------------=
    
    func testDescriptionByBaseNumeralPyramid() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for radix: UX in 2 ... 36 {
                Test().descriptionByBaseNumeralPyramid(T.self, radix: radix)
            }
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    func testDescriptionByEachNumeralPyramid() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for radix: UX in 2 ... 36 {
                Test().descriptionByEachNumeralPyramid(T.self, radix: radix)
            }
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    func testDescriptionByHighNumeralPyramid() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for radix: UX in 2 ... 36 {
                Test().descriptionByHighNumeralPyramid(T.self, radix: radix)
            }
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
}
