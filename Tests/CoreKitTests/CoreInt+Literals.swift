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
// MARK: * Core Int x Literals
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLiteralInt() {
        Test().same(I16.exactly(-0000032769 as LiteralInt), Fallible(I16.max, error: true))
        Test().same(I16.exactly(-0000032768 as LiteralInt), Fallible(I16.min))
        Test().same(I16.exactly( 0000032767 as LiteralInt), Fallible(I16.max))
        Test().same(I16.exactly( 0000032768 as LiteralInt), Fallible(I16.min, error: true))
        
        Test().same(U16.exactly(-0000000001 as LiteralInt), Fallible(U16.max, error: true))
        Test().same(U16.exactly( 0000000000 as LiteralInt), Fallible(U16.min))
        Test().same(U16.exactly( 0000065535 as LiteralInt), Fallible(U16.max))
        Test().same(U16.exactly( 0000065536 as LiteralInt), Fallible(U16.min, error: true))
        
        Test().same(I32.exactly(-2147483649 as LiteralInt), Fallible(I32.max, error: true))
        Test().same(I32.exactly(-2147483648 as LiteralInt), Fallible(I32.min))
        Test().same(I32.exactly( 2147483647 as LiteralInt), Fallible(I32.max))
        Test().same(I32.exactly( 2147483648 as LiteralInt), Fallible(I32.min, error: true))
                
        Test().same(U32.exactly(-0000000001 as LiteralInt), Fallible(U32.max, error: true))
        Test().same(U32.exactly( 0000000000 as LiteralInt), Fallible(U32.min))
        Test().same(U32.exactly( 4294967295 as LiteralInt), Fallible(U32.max))
        Test().same(U32.exactly( 4294967296 as LiteralInt), Fallible(U32.min, error: true))
    }
}
