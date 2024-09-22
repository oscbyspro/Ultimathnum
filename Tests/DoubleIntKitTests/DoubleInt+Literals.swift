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
// MARK: * Double Int x Literals
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLiteralInt() {
        Test().same(I8x2.exactly(-0000032769 as LiteralInt), Fallible(I8x2.max, error: true))
        Test().same(I8x2.exactly(-0000032768 as LiteralInt), Fallible(I8x2.min))
        Test().same(I8x2.exactly( 0000032767 as LiteralInt), Fallible(I8x2.max))
        Test().same(I8x2.exactly( 0000032768 as LiteralInt), Fallible(I8x2.min, error: true))
        
        Test().same(U8x2.exactly(-0000000001 as LiteralInt), Fallible(U8x2.max, error: true))
        Test().same(U8x2.exactly( 0000000000 as LiteralInt), Fallible(U8x2.min))
        Test().same(U8x2.exactly( 0000065535 as LiteralInt), Fallible(U8x2.max))
        Test().same(U8x2.exactly( 0000065536 as LiteralInt), Fallible(U8x2.min, error: true))
        
        Test().same(I8x4.exactly(-2147483649 as LiteralInt), Fallible(I8x4.max, error: true))
        Test().same(I8x4.exactly(-2147483648 as LiteralInt), Fallible(I8x4.min))
        Test().same(I8x4.exactly( 2147483647 as LiteralInt), Fallible(I8x4.max))
        Test().same(I8x4.exactly( 2147483648 as LiteralInt), Fallible(I8x4.min, error: true))
                
        Test().same(U8x4.exactly(-0000000001 as LiteralInt), Fallible(U8x4.max, error: true))
        Test().same(U8x4.exactly( 0000000000 as LiteralInt), Fallible(U8x4.min))
        Test().same(U8x4.exactly( 4294967295 as LiteralInt), Fallible(U8x4.max))
        Test().same(U8x4.exactly( 4294967296 as LiteralInt), Fallible(U8x4.min, error: true))
    }
}
