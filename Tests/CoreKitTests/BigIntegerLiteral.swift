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
// MARK: * Big Integer Literal
//*============================================================================*

final class BigIntegerLiteralTests: XCTestCase {
    
    typealias T = BigIntLiteral
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSignum() {
        Test().same((-2 as T).signum(), Signum.less)
        Test().same((-1 as T).signum(), Signum.less)
        Test().same(( 0 as T).signum(), Signum.same)
        Test().same(( 1 as T).signum(), Signum.more)
        Test().same(( 2 as T).signum(), Signum.more)
    }
        
    func testElements() {
        Test().same((-123 as T)[UX(  )], ~122 as UX)
        Test().same(( 000 as T)[UX(  )],  000 as UX)
        Test().same(( 123 as T)[UX(  )],  123 as UX)

        Test().same((-123 as T)[UX.max], UX(repeating: 1))
        Test().same(( 123 as T)[UX.max], UX(repeating: 0))
    }
}
