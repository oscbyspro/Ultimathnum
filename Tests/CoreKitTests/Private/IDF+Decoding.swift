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
// MARK: * Integer Description Format x Decoding
//*============================================================================*

final class IntegerDescriptionFormatTestsOnDecoding: XCTestCase {
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let decoder = Namespace.IntegerDescriptionFormat.Decoder()
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSmall() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            check(Test(),   "0", 000 as T?)
            check(Test(),  "#0", 000 as T?)
            check(Test(),  "&0", nil as T?)
            check(Test(),  "+0", 000 as T?)
            check(Test(), "+#0", 000 as T?)
            check(Test(), "+&0", nil as T?)
            check(Test(),  "-0", 000 as T?)
            check(Test(), "-#0", 000 as T?)
            check(Test(), "-&0", nil as T?)
            check(Test(),   "1", 001 as T?)
            check(Test(),  "#1", 001 as T?)
            check(Test(),  "&1", nil as T?)
            check(Test(),  "+1", 001 as T?)
            check(Test(), "+#1", 001 as T?)
            check(Test(), "+&1", nil as T?)
            check(Test(),  "-1", T.isSigned ? -1 as T : nil)
            check(Test(), "-#1", T.isSigned ? -1 as T : nil)
            check(Test(), "-&1", nil as T?)
            
            check(Test(), "#+0", nil as T?)
            check(Test(), "#-0", nil as T?)
            check(Test(), "&+0", nil as T?)
            check(Test(), "&-0", nil as T?)
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    func testI32() {
        check(Test(),  "0000000000", I32(load: 0x00000000 as U32))
        check(Test(),  "0050462976", I32(load: 0x03020100 as U32))
        check(Test(),  "2147483647", I32(load: 0x7fffffff as U32)) // I32.max
        check(Test(), "-2147483648", I32(load: 0x80000000 as U32)) // I32.min
        check(Test(), "-2122285186", I32(load: 0x81807f7e as U32))
        check(Test(), "-0000066052", I32(load: 0xfffefdfc as U32))
        check(Test(), "-0000000001", I32(load: 0xffffffff as U32))
    }
    
    func testU32() {
        check(Test(),  "0000000000", U32(load: 0x00000000 as U32))
        check(Test(),  "0050462976", U32(load: 0x03020100 as U32))
        check(Test(),  "2147483647", U32(load: 0x7fffffff as U32)) // I32.max
        check(Test(), "+2147483648", U32(load: 0x80000000 as U32)) // I32.min
        check(Test(), "+2172682110", U32(load: 0x81807f7e as U32))
        check(Test(), "+4294901244", U32(load: 0xfffefdfc as U32))
        check(Test(), "+4294967295", U32(load: 0xffffffff as U32))
    }
    
    func testI64() {
        check(Test(),  "0000000000000000000", I64(load: 0x0000000000000000 as U64))
        check(Test(),  "0506097522914230528", I64(load: 0x0706050403020100 as U64))
        check(Test(),  "9223372036854775807", I64(load: 0x7fffffffffffffff as U64)) // I64.max
        check(Test(), "-9223372036854775808", I64(load: 0x8000000000000000 as U64)) // I64.max
        check(Test(), "-8970465118873813636", I64(load: 0x838281807f7e7d7c as U64))
        check(Test(), "-0000283686952306184", I64(load: 0xfffefdfcfbfaf9f8 as U64))
        check(Test(), "-0000000000000000001", I64(load: 0xffffffffffffffff as U64))
    }

    func testU64() {
        check(Test(),  "0000000000000000000", U64(load: 0x0000000000000000 as U64)) // U64.min
        check(Test(),  "0506097522914230528", U64(load: 0x0706050403020100 as U64))
        check(Test(),  "9223372036854775807", U64(load: 0x7fffffffffffffff as U64))
        check(Test(),  "9223372036854775808", U64(load: 0x8000000000000000 as U64))
        check(Test(),  "9476278954835737980", U64(load: 0x838281807f7e7d7c as U64))
        check(Test(), "18446460386757245432", U64(load: 0xfffefdfcfbfaf9f8 as U64))
        check(Test(), "18446744073709551615", U64(load: 0xffffffffffffffff as U64)) // U64.max
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testError() {
        check(Test(), "+", nil as U64?)
        check(Test(), "-", nil as U64?)
        check(Test(), "~", nil as U64?)
        check(Test(), " ", nil as U64?)
        
        check(Test(), "!0000000000000000001", nil as U64?)
        check(Test(), "000000000!1000000000", nil as U64?)
        check(Test(), "0000000001!000000000", nil as U64?)
        check(Test(), "1000000000000000000!", nil as U64?)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func check<T>(
        _ test: Test,
        _ description: String,
        _ expectation: T?
    )   where T: BinaryInteger {
        test.same(try? decoder.decode(description), expectation)
    }
}
