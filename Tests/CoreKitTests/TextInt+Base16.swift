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
// MARK: * Text Int x Base 16
//*============================================================================*

extension TextIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encoding (and Decoding)
    //=------------------------------------------------------------------------=
    
    func testEncodingAsBase16() {
        func whereTypeIs<T>(_ type: T.Type) where T: BinaryInteger {
            let (item) = TextInt.radix(16)

            guard T.size >= U8.size else { return }
            if  T.isSigned {
                Case(item).encode(T(load: I8 (load: 0x00 as U64)),   "0")
                Case(item).encode(T(load: I8 (load: 0x7f as U64)),  "7f") // I8.max
                Case(item).encode(T(load: I8 (load: 0x80 as U64)), "-80") // I8.min
                Case(item).encode(T(load: I8 (load: 0x07 as U64)),   "7")
                Case(item).encode(T(load: I8 (load: 0xff as U64)),  "-1")
            }   else {
                Case(item).encode(T(load: U8 (load: 0x00 as U64)),   "0") // U8.min
                Case(item).encode(T(load: U8 (load: 0x7f as U64)),  "7f")
                Case(item).encode(T(load: U8 (load: 0x80 as U64)),  "80")
                Case(item).encode(T(load: U8 (load: 0x07 as U64)),   "7")
                Case(item).encode(T(load: U8 (load: 0xff as U64)),  "ff") // U8.max
            }
            
            guard T.size >= U16.size else { return }
            if  T.isSigned {
                Case(item).encode(T(load: I16(load: 0x0000 as U64)),     "0")
                Case(item).encode(T(load: I16(load: 0x0100 as U64)),   "100")
                Case(item).encode(T(load: I16(load: 0x7fff as U64)),  "7fff") // I16.max
                Case(item).encode(T(load: I16(load: 0x8000 as U64)), "-8000") // I16.min
                Case(item).encode(T(load: I16(load: 0x807f as U64)), "-7f81")
                Case(item).encode(T(load: I16(load: 0xfffe as U64)),    "-2")
                Case(item).encode(T(load: I16(load: 0xffff as U64)),    "-1")
            }   else {
                Case(item).encode(T(load: U16(load: 0x0000 as U64)),     "0") // U16.min
                Case(item).encode(T(load: U16(load: 0x0100 as U64)),   "100")
                Case(item).encode(T(load: U16(load: 0x7fff as U64)),  "7fff")
                Case(item).encode(T(load: U16(load: 0x8000 as U64)),  "8000")
                Case(item).encode(T(load: U16(load: 0x807f as U64)),  "807f")
                Case(item).encode(T(load: U16(load: 0xfffe as U64)),  "fffe")
                Case(item).encode(T(load: U16(load: 0xffff as U64)),  "ffff") // U16.max
            }
            
            guard T.size >= U32.size else { return }
            if  T.isSigned {
                Case(item).encode(T(load: I32(load: 0x00000000 as U64)),         "0")
                Case(item).encode(T(load: I32(load: 0x03020100 as U64)),   "3020100")
                Case(item).encode(T(load: I32(load: 0x7fffffff as U64)),  "7fffffff") // I32.max
                Case(item).encode(T(load: I32(load: 0x80000000 as U64)), "-80000000") // I32.min
                Case(item).encode(T(load: I32(load: 0x81807f7e as U64)), "-7e7f8082")
                Case(item).encode(T(load: I32(load: 0xfffefdfc as U64)),    "-10204")
                Case(item).encode(T(load: I32(load: 0xffffffff as U64)),        "-1")
            }   else {
                Case(item).encode(T(load: U32(load: 0x00000000 as U64)),         "0") // U32.min
                Case(item).encode(T(load: U32(load: 0x03020100 as U64)),   "3020100")
                Case(item).encode(T(load: U32(load: 0x7fffffff as U64)),  "7fffffff")
                Case(item).encode(T(load: U32(load: 0x80000000 as U64)),  "80000000")
                Case(item).encode(T(load: U32(load: 0x81807f7e as U64)),  "81807f7e")
                Case(item).encode(T(load: U32(load: 0xfffefdfc as U64)),  "fffefdfc")
                Case(item).encode(T(load: U32(load: 0xffffffff as U64)),  "ffffffff") // U32.max
            }
            
            guard T.size >= U64.size else { return }
            if  T.isSigned {
                Case(item).encode(T(load: I64(load: 0x0000000000000000 as U64)),                 "0")
                Case(item).encode(T(load: I64(load: 0x0706050403020100 as U64)),   "706050403020100")
                Case(item).encode(T(load: I64(load: 0x7fffffffffffffff as U64)),  "7fffffffffffffff") // I64.max
                Case(item).encode(T(load: I64(load: 0x8000000000000000 as U64)), "-8000000000000000") // I64.max
                Case(item).encode(T(load: I64(load: 0x838281807f7e7d7c as U64)), "-7c7d7e7f80818284")
                Case(item).encode(T(load: I64(load: 0xfffefdfcfbfaf9f8 as U64)),    "-1020304050608")
                Case(item).encode(T(load: I64(load: 0xffffffffffffffff as U64)),                "-1")
            }   else {
                Case(item).encode(T(load: U64(load: 0x0000000000000000 as U64)),                "0") // U64.min
                Case(item).encode(T(load: U64(load: 0x0706050403020100 as U64)),   "706050403020100")
                Case(item).encode(T(load: U64(load: 0x7fffffffffffffff as U64)),  "7fffffffffffffff")
                Case(item).encode(T(load: U64(load: 0x8000000000000000 as U64)),  "8000000000000000")
                Case(item).encode(T(load: U64(load: 0x838281807f7e7d7c as U64)),  "838281807f7e7d7c")
                Case(item).encode(T(load: U64(load: 0xfffefdfcfbfaf9f8 as U64)),  "fffefdfcfbfaf9f8")
                Case(item).encode(T(load: U64(load: 0xffffffffffffffff as U64)),  "ffffffffffffffff") // U64.max
            }
        }
        
        for type in coreSystemsIntegers {
            whereTypeIs(type)
        }
    }
}
