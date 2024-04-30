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
// MARK: * Core Int
//*============================================================================*

final class CoreIntTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInvariants() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).mode(BinaryIntegerID())
            IntegerInvariants(T.self).size(SystemsIntegerID())
            IntegerInvariants(T.self).protocols()
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testMinMax() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().same(T.min, T.isSigned ?  T.msb :  0)
            Test().same(T.max, T.isSigned ? ~T.msb : ~0)
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    func testLsbMsb() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().same(T.lsb.count(.ascending (1)), 1)
            Test().same(T.lsb.count(.descending(0)), T.size - 1)
            Test().same(T.msb.count(.ascending (0)), T.size - 1)
            Test().same(T.msb.count(.descending(1)), 1)
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
}
