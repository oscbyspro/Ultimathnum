//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import StdlibIntKit
import TestKit

//*============================================================================*
// MARK: * Stdlib Int x Count
//*============================================================================*

extension StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
 
    func testUpshiftAnyByMinInt() {
        Test().same(T( 2) << Int.min,  0 as T)
        Test().same(T( 1) << Int.min,  0 as T)
        Test().same(T( 0) << Int.min,  0 as T)
        Test().same(T(-1) << Int.min, -1 as T)
        Test().same(T(-2) << Int.min, -1 as T)
    }
    
    func testUpshiftZeroByMaxInt() {
        Test().same(T( 0) << Int.max,  0 as T)
    }
    
    func testDownshiftAnyByMaxInt() {
        Test().same(T( 2) >> Int.max,  0 as T)
        Test().same(T( 1) >> Int.max,  0 as T)
        Test().same(T( 0) >> Int.max,  0 as T)
        Test().same(T(-1) >> Int.max, -1 as T)
        Test().same(T(-2) >> Int.max, -1 as T)
    }
    
    func testDownshiftZeroByMinInt() {
        Test().same(T( 0) >> Int.min,  0 as T)
    }
}
