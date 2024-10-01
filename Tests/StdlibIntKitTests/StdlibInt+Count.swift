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
import TestKit2

//*============================================================================*
// MARK: * Stdlib Int x Count
//*============================================================================*

/// An `StdlibInt` test suite.
///
/// ### Wrapper
///
/// `StdlibInt` should forward most function calls to its underlying model.
///
/// ### Development
///
/// - TODO: Test `StdlibInt` forwarding in generic `BinaryInteger` tests.
///
@Suite struct StdlibIntTestsOnCount {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
 
    @Test("StdlibInt/bitWidth")
    func bitWidth() {
        zero: do {
            #expect(StdlibInt.zero.bitWidth == 1)
        }
        
        positive: do {
            var value =  1 as StdlibInt
            for count in 2 ... 256 {
                #expect(value.bitWidth == count)
                value <<= 1
            }
        }
        
        negative: do {
            var value = -1 as StdlibInt
            for count in 1 ... 256 {
                #expect(value.bitWidth == count)
                value <<= 1
            }
        }
    }
    
    @Test("StdlibInt/trailingZeroBitCount")
    func trailingZeroBitCount() {
        zero: do {
            #expect(StdlibInt.zero.trailingZeroBitCount == 1)
        }
            
        positive: do {
            var value =  1 as StdlibInt
            for count in 0 ..< 256 {
                #expect(value.trailingZeroBitCount == count)
                value <<= 1
            }
        }
       
        negative: do {
            var value = -1 as StdlibInt
            for count in 0 ..< 256 {
                #expect(value.trailingZeroBitCount == count)
                value <<= 1
            }
        }
    }
}
