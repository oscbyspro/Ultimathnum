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
 
    func testBitWidth() {
        zero: do {
            Test().same(T.zero.bitWidth, 1)
        }
        
        positive: do {
            var value =  1 as StdlibInt
            for count in 2 ... 256 {
                Test().same(value.bitWidth, count)
                value <<= 1
            }
        }
        
        negative: do {
            var value = -1 as StdlibInt
            for count in 1 ... 256 {
                Test().same(value.bitWidth, count)
                value <<= 1
            }
        }
    }
    
    func testTrailingZeroBitCount() {
        zero: do {
            Test().same(T.zero.trailingZeroBitCount, 1)
        }
            
        positive: do {
            var value =  1 as StdlibInt
            for count in 0 ..< 256 {
                Test().same(value.trailingZeroBitCount, count)
                value <<= 1
            }
        }
       
        negative: do {
            var value = -1 as StdlibInt
            for count in 0 ..< 256 {
                Test().same(value.trailingZeroBitCount, count)
                value <<= 1
            }
        }
    }
}
