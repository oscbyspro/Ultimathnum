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
// MARK: * Make Int
//*============================================================================*

final class MakeIntTests: XCTestCase {
    
    typealias T = MakeInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMode() {
        Test().yay(T.mode.isSigned)
    }
    
    func testEntropy() {
        Test().same(T(-6).entropy, 4 as UX, "1...010")
        Test().same(T(-5).entropy, 4 as UX, "1...011")
        Test().same(T(-4).entropy, 3 as UX, "1....00")
        Test().same(T(-3).entropy, 3 as UX, "1....01")
        Test().same(T(-2).entropy, 2 as UX, "1.....0")
        Test().same(T(-1).entropy, 1 as UX, "1......")
        Test().same(T( 0).entropy, 1 as UX, "0......")
        Test().same(T( 1).entropy, 2 as UX, "0.....1")
        Test().same(T( 2).entropy, 3 as UX, "0....10")
        Test().same(T( 3).entropy, 3 as UX, "0....11")
        Test().same(T( 4).entropy, 4 as UX, "0...100")
        Test().same(T( 5).entropy, 4 as UX, "0...101")
        
        Test().same(T(-0x80000000000000000000000000000000).entropy, 128)
        Test().same(T( 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF).entropy, 128)
    }
    
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
    
    func testSignum() {
        Test().same(T(-6).signum(), Signum.less)
        Test().same(T(-5).signum(), Signum.less)
        Test().same(T(-4).signum(), Signum.less)
        Test().same(T(-3).signum(), Signum.less)
        Test().same(T(-2).signum(), Signum.less)
        Test().same(T(-1).signum(), Signum.less)
        Test().same(T( 0).signum(), Signum.same)
        Test().same(T( 1).signum(), Signum.more)
        Test().same(T( 2).signum(), Signum.more)
        Test().same(T( 3).signum(), Signum.more)
        Test().same(T( 4).signum(), Signum.more)
        Test().same(T( 5).signum(), Signum.more)
        
        Test().same(T(-0x80000000000000000000000000000000).signum(), Signum.less)
        Test().same(T( 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF).signum(), Signum.more)
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
        
        Test().same(T(-0x80000000000000000000000000000000)[127 / UX.size],  (UX.max << min(127, UX.size - 1)))
        Test().same(T( 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)[127 / UX.size], ~(UX.max << min(127, UX.size - 1)))
    }
}
