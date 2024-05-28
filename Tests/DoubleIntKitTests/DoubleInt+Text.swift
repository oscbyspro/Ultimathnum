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
// MARK: * Double Int x Text
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Pyramids
    //=------------------------------------------------------------------------=
    
    func testDescriptionByBaseNumeralPyramid() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            #if DEBUG
            Test().descriptionByBaseNumeralPyramid(T.self, radix: 10)
            Test().descriptionByBaseNumeralPyramid(T.self, radix: 16)
            #else
            for radix: UX in 2 ... 36 {
                Test().descriptionByBaseNumeralPyramid(T.self, radix: radix)
            }
            #endif
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testDescriptionByEachNumeralPyramid() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            #if DEBUG
            Test().descriptionByEachNumeralPyramid(T.self, radix: 10)
            Test().descriptionByEachNumeralPyramid(T.self, radix: 16)
            #else
            for radix: UX in 2 ... 36 {
                Test().descriptionByEachNumeralPyramid(T.self, radix: radix)
            }
            #endif
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testDescriptionByHighNumeralPyramid() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            #if DEBUG
            Test().descriptionByHighNumeralPyramid(T.self, radix: 10)
            Test().descriptionByHighNumeralPyramid(T.self, radix: 16)
            #else
            for radix: UX in 2 ... 36 {
                Test().descriptionByHighNumeralPyramid(T.self, radix: radix)
            }
            #endif
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
