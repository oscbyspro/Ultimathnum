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
// MARK: * Integer Description Format x Encoding
//*============================================================================*

final class IntegerDescriptionFormatTestsOnEncoding: XCTestCase {
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let encoder = Namespace.IntegerDescriptionFormat.Encoder()
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testEncoding() {
        for count in 0 ..< 4 {
            let x0 = [0] + Array(repeating: 0 as U64, count: count)
            let x1 = [1] + Array(repeating: 0 as U64, count: count)
            
            checkEncoding(Sign.plus,  x0,  "0")
            checkEncoding(Sign.minus, x0,  "0")
            checkEncoding(Sign.plus,  x1,  "1")
            checkEncoding(Sign.minus, x1, "-1")
        }
    }
    
    func testInt32() {
        checkEncoding(I32(truncating: 0x00000000 as U32),           "0")
        checkEncoding(I32(truncating: 0x03020100 as U32),    "50462976")
        checkEncoding(I32(truncating: 0x7fffffff as U32),  "2147483647") // I32.max
        checkEncoding(I32(truncating: 0x80000000 as U32), "-2147483648") // I32.min
        checkEncoding(I32(truncating: 0x81807f7e as U32), "-2122285186")
        checkEncoding(I32(truncating: 0xfffefdfc as U32),      "-66052")
        checkEncoding(I32(truncating: 0xffffffff as U32),          "-1")
    }

    func testUInt32() {
        checkEncoding(U32(truncating: 0x00000000 as U32),           "0") // U32.min
        checkEncoding(U32(truncating: 0x03020100 as U32),    "50462976")
        checkEncoding(U32(truncating: 0x7fffffff as U32),  "2147483647")
        checkEncoding(U32(truncating: 0x80000000 as U32),  "2147483648")
        checkEncoding(U32(truncating: 0x81807f7e as U32),  "2172682110")
        checkEncoding(U32(truncating: 0xfffefdfc as U32),  "4294901244")
        checkEncoding(U32(truncating: 0xffffffff as U32),  "4294967295") // U32.max
    }

    func testI64() {
        checkEncoding(I64(truncating: 0x0000000000000000 as U64),                    "0")
        checkEncoding(I64(truncating: 0x0706050403020100 as U64),   "506097522914230528")
        checkEncoding(I64(truncating: 0x7fffffffffffffff as U64),  "9223372036854775807") // I64.max
        checkEncoding(I64(truncating: 0x8000000000000000 as U64), "-9223372036854775808") // I64.max
        checkEncoding(I64(truncating: 0x838281807f7e7d7c as U64), "-8970465118873813636")
        checkEncoding(I64(truncating: 0xfffefdfcfbfaf9f8 as U64),     "-283686952306184")
        checkEncoding(I64(truncating: 0xffffffffffffffff as U64),                   "-1")
    }

    func testU64() {
        checkEncoding(U64(truncating: 0x0000000000000000 as U64),                    "0") // U64.min
        checkEncoding(U64(truncating: 0x0706050403020100 as U64),   "506097522914230528")
        checkEncoding(U64(truncating: 0x7fffffffffffffff as U64),  "9223372036854775807")
        checkEncoding(U64(truncating: 0x8000000000000000 as U64),  "9223372036854775808")
        checkEncoding(U64(truncating: 0x838281807f7e7d7c as U64),  "9476278954835737980")
        checkEncoding(U64(truncating: 0xfffefdfcfbfaf9f8 as U64), "18446460386757245432")
        checkEncoding(U64(truncating: 0xffffffffffffffff as U64), "18446744073709551615") // U64.max
    }

    // MARK: Tests + Big Integer
    
    func testInt128() {
        checkEncoding(Sign.plus,  [0x0000000000000000, 0x0000000000000000] as [U64],                                        "0")
        checkEncoding(Sign.plus,  [0x0706050403020100, 0x0f0e0d0c0b0a0908] as [U64],   "20011376718272490338853433276725592320")
        checkEncoding(Sign.plus,  [0xffffffffffffffff, 0x7fffffffffffffff] as [U64],  "170141183460469231731687303715884105727") // I128.max
        checkEncoding(Sign.minus, [0x0000000000000000, 0x8000000000000000] as [U64], "-170141183460469231731687303715884105728") // I128.min
        checkEncoding(Sign.minus, [0x08090a0b0c0d0e10, 0x0001020304050607] as [U64],      "-5233100606242806050955395731361296")
        checkEncoding(Sign.minus, [0x0000000000000001, 0x0000000000000000] as [U64],                                       "-1")
    }
    
    func testU128() {
        checkEncoding(Sign.plus,  [0x0000000000000000, 0x0000000000000000] as [U64],                                        "0") // U128.min
        checkEncoding(Sign.plus,  [0x0706050403020100, 0x0f0e0d0c0b0a0908] as [U64],   "20011376718272490338853433276725592320")
        checkEncoding(Sign.plus,  [0x0000000000000000, 0x8000000000000000] as [U64],  "170141183460469231731687303715884105728")
        checkEncoding(Sign.plus,  [0xf7f6f5f4f3f2f1f0, 0xfffefdfcfbfaf9f8] as [U64],  "340277133820332220657323652036036850160")
        checkEncoding(Sign.plus,  [0xffffffffffffffff, 0x7fffffffffffffff] as [U64],  "170141183460469231731687303715884105727")
        checkEncoding(Sign.plus,  [0xffffffffffffffff, 0xffffffffffffffff] as [U64],  "340282366920938463463374607431768211455") // U128.max
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func checkEncoding(_ integer: some Integer, _ expectation: String, file: StaticString = #file, line: UInt = #line) {
        let sign = Sign(Bit(integer < 0))
        let magnitude = [UX](ChunkedInt(integer.magnitude.words, isSigned: false))
        
        XCTAssertEqual(encoder.encode(integer), expectation, file: file, line: line)
        XCTAssertEqual(encoder.encode(sign: sign, magnitude: magnitude), expectation, file: file, line: line)
    }
    
    func checkEncoding(_ sign: Sign, _ magnitude: [U64], _ expectation: String, file: StaticString = #file, line: UInt = #line) {
        let magnitude = [UX](ChunkedInt(magnitude, isSigned: false))
        XCTAssertEqual(encoder.encode(sign: sign, magnitude: magnitude), expectation, file: file, line: line)
    }
}
