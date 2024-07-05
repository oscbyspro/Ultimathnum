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
// MARK: * Root Int x Elements
//*============================================================================*

extension RootIntTests {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAppendix() {
        Test().same(T(-6).appendix, 1 as Bit)
        Test().same(T(-5).appendix, 1 as Bit)
        Test().same(T(-4).appendix, 1 as Bit)
        Test().same(T(-3).appendix, 1 as Bit)
        Test().same(T(-2).appendix, 1 as Bit)
        Test().same(T(-1).appendix, 1 as Bit)
        Test().same(T( 0).appendix, 0 as Bit)
        Test().same(T( 1).appendix, 0 as Bit)
        Test().same(T( 2).appendix, 0 as Bit)
        Test().same(T( 3).appendix, 0 as Bit)
        Test().same(T( 4).appendix, 0 as Bit)
        Test().same(T( 5).appendix, 0 as Bit)
        
        Test().same(T(-0x80000000000000000000000000000000).appendix, 1 as Bit)
        Test().same(T( 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF).appendix, 0 as Bit)
    }
    
    func testElements() throws {
        Test().same(T(-123)[UX(  )], ~122 as UX)
        Test().same(T(-001)[UX(  )], ~000 as UX)
        Test().same(T( 000)[UX(  )],  000 as UX)
        Test().same(T( 123)[UX(  )],  123 as UX)
        
        Test().same(T(-123)[UX.max], ~000 as UX)
        Test().same(T(-001)[UX.max], ~000 as UX)
        Test().same(T( 000)[UX.max],  000 as UX)
        Test().same(T( 123)[UX.max],  000 as UX)
        
        Test().same(T(-0x80000000000000000000000000000000)[127 / UX(size: UX.self)],  (UX.max << min(127, UX(size: UX.self) - 1)))
        Test().same(T( 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)[127 / UX(size: UX.self)], ~(UX.max << min(127, UX(size: UX.self) - 1)))
    }
}
