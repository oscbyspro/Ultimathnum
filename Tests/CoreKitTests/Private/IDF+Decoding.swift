//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
        
    func testI32() {
        check( "0000000000", I32(truncating: 0x00000000 as U32))
        check( "0050462976", I32(truncating: 0x03020100 as U32))
        check( "2147483647", I32(truncating: 0x7fffffff as U32)) // I32.max
        check("-2147483648", I32(truncating: 0x80000000 as U32)) // I32.min
        check("-2122285186", I32(truncating: 0x81807f7e as U32))
        check("-0000066052", I32(truncating: 0xfffefdfc as U32))
        check("-0000000001", I32(truncating: 0xffffffff as U32))
    }

    func testU32() {
        check( "0000000000", U32(truncating: 0x00000000 as U32))
        check( "0050462976", U32(truncating: 0x03020100 as U32))
        check( "2147483647", U32(truncating: 0x7fffffff as U32)) // I32.max
        check("+2147483648", U32(truncating: 0x80000000 as U32)) // I32.min
        check("+2172682110", U32(truncating: 0x81807f7e as U32))
        check("+4294901244", U32(truncating: 0xfffefdfc as U32))
        check("+4294967295", U32(truncating: 0xffffffff as U32))
    }
    
    func testI64() {
        check( "0000000000000000000", I64(truncating: 0x0000000000000000 as U64))
        check( "0506097522914230528", I64(truncating: 0x0706050403020100 as U64))
        check( "9223372036854775807", I64(truncating: 0x7fffffffffffffff as U64)) // I64.max
        check("-9223372036854775808", I64(truncating: 0x8000000000000000 as U64)) // I64.max
        check("-8970465118873813636", I64(truncating: 0x838281807f7e7d7c as U64))
        check("-0000283686952306184", I64(truncating: 0xfffefdfcfbfaf9f8 as U64))
        check("-0000000000000000001", I64(truncating: 0xffffffffffffffff as U64))
    }

    func testU64() {
        check( "0000000000000000000", U64(truncating: 0x0000000000000000 as U64)) // U64.min
        check( "0506097522914230528", U64(truncating: 0x0706050403020100 as U64))
        check( "9223372036854775807", U64(truncating: 0x7fffffffffffffff as U64))
        check( "9223372036854775808", U64(truncating: 0x8000000000000000 as U64))
        check( "9476278954835737980", U64(truncating: 0x838281807f7e7d7c as U64))
        check("18446460386757245432", U64(truncating: 0xfffefdfcfbfaf9f8 as U64))
        check("18446744073709551615", U64(truncating: 0xffffffffffffffff as U64)) // U64.max
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testError() {
        check("+", nil as U64?)
        check("-", nil as U64?)
        check("~", nil as U64?)
        check(" ", nil as U64?)
        
        check("!0000000000000000001", nil as U64?)
        check("000000000!1000000000", nil as U64?)
        check("0000000001!000000000", nil as U64?)
        check("1000000000000000000!", nil as U64?)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func check<T: BinaryInteger>(_ description: String, _ expectation: T?, file: StaticString = #file, line: UInt = #line) {
        let result: T? = try?  decoder.decode(description)
        XCTAssertEqual(result, expectation, file: file, line: line)
    }
}
