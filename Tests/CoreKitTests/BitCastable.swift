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
// MARK: * Bit Castable
//*============================================================================*

final class BitCastableTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testRawInitUsingCoreSystemsIntegers() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias S = T.Signitude
            typealias M = T.Magnitude
            
            Test().same(T(raw: S.min),  T.msb)
            Test().same(T(raw: S.max), ~T.msb)
            
            Test().same(T(raw: M.min),  T(repeating: Bit.zero))
            Test().same(T(raw: M.max),  T(repeating: Bit.one ))
        }

        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
}
