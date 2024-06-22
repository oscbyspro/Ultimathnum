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
// MARK: * Stdlib Int x Words
//*============================================================================*

extension StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testWords() throws {
        if  MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size {
            Test().same(Array(( 0x00000000000000000000000000000000 as T).words), [0x0000000000000000] as [UInt])
            Test().same(Array(( 0x00000000000000000000000000000001 as T).words), [0x0000000000000001] as [UInt])
            Test().same(Array(( 0x00000000000000000706050403020100 as T).words), [0x0706050403020100] as [UInt])
            Test().same(Array(( 0x0f0e0d0c0b0a09080706050403020100 as T).words), [0x0706050403020100, 0x0f0e0d0c0b0a0908] as [UInt])
            Test().same(Array(( 0x7fffffffffffffffffffffffffffffff as T).words), [0xffffffffffffffff, 0x7fffffffffffffff] as [UInt])
            Test().same(Array(( 0x80000000000000000000000000000000 as T).words), [0x0000000000000000, 0x8000000000000000, 0x0000000000000000] as [UInt])
            Test().same(Array(( 0x80000000000000000000000000000001 as T).words), [0x0000000000000001, 0x8000000000000000, 0x0000000000000000] as [UInt])
            
            Test().same(Array((-0x00000000000000000000000000000000 as T).words), [0x0000000000000000] as [UInt])
            Test().same(Array((-0x00000000000000000000000000000001 as T).words), [0xffffffffffffffff] as [UInt])
            Test().same(Array((-0x00000000000000000706050403020100 as T).words), [0xf8f9fafbfcfdff00] as [UInt])
            Test().same(Array((-0x0f0e0d0c0b0a09080706050403020100 as T).words), [0xf8f9fafbfcfdff00, 0xf0f1f2f3f4f5f6f7] as [UInt])
            Test().same(Array((-0x7fffffffffffffffffffffffffffffff as T).words), [0x0000000000000001, 0x8000000000000000] as [UInt])
            Test().same(Array((-0x80000000000000000000000000000000 as T).words), [0x0000000000000000, 0x8000000000000000] as [UInt])
            Test().same(Array((-0x80000000000000000000000000000001 as T).words), [0xffffffffffffffff, 0x7fffffffffffffff, 0xffffffffffffffff] as [UInt])
        }   else {
            throw XCTSkip()
        }
    }
}
