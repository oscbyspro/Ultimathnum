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
// MARK: * Text Int x Base 10
//*============================================================================*

extension TextIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Decoding
    //=------------------------------------------------------------------------=
    
    func testDecodingEdges08AsBase10() {
        typealias R<T> = Result<T, TextInt.Failure>
        
        let (item) = TextInt.radix(10)        
        Case(item).decode("-129", R<I8>.failure(.overflow))
        Case(item).decode("-128", R<I8>.success(.min))
        Case(item).decode("+127", R<I8>.success(.max))
        Case(item).decode("+128", R<I8>.failure(.overflow))
        Case(item).decode("-001", R<U8>.failure(.overflow))
        Case(item).decode("-000", R<U8>.success(.min))
        Case(item).decode("+255", R<U8>.success(.max))
        Case(item).decode("+256", R<U8>.failure(.overflow))
    } 
    
    func testDecodingEdges16AsBase10() {
        typealias R<T> = Result<T, TextInt.Failure>
        
        let (item) = TextInt.radix(10)
        Case(item).decode("-32769", R<I16>.failure(.overflow))
        Case(item).decode("-32768", R<I16>.success(.min))
        Case(item).decode("+32767", R<I16>.success(.max))
        Case(item).decode("+32768", R<I16>.failure(.overflow))
        Case(item).decode("-00001", R<U16>.failure(.overflow))
        Case(item).decode("-00000", R<U16>.success(.min))
        Case(item).decode("+65535", R<U16>.success(.max))
        Case(item).decode("+65536", R<U16>.failure(.overflow))
    }
    
    func testDecodingEdges32AsBase10() {
        typealias R<T> = Result<T, TextInt.Failure>
        
        let (item) = TextInt.radix(10)
        Case(item).decode("-2147483649", R<I32>.failure(.overflow))
        Case(item).decode("-2147483648", R<I32>.success(.min))
        Case(item).decode("+2147483647", R<I32>.success(.max))
        Case(item).decode("+2147483648", R<I32>.failure(.overflow))
        Case(item).decode("-0000000001", R<U32>.failure(.overflow))
        Case(item).decode("-0000000000", R<U32>.success(.min))
        Case(item).decode("+4294967295", R<U32>.success(.max))
        Case(item).decode("+4294967296", R<U32>.failure(.overflow))
    }
    
    func testDecodingEdges64AsBase10() {
        typealias R<T> = Result<T, TextInt.Failure>
        
        let (item) = TextInt.radix(10)
        Case(item).decode("-09223372036854775809", R<I64>.failure(.overflow))
        Case(item).decode("-09223372036854775808", R<I64>.success(.min))
        Case(item).decode("+09223372036854775807", R<I64>.success(.max))
        Case(item).decode("+09223372036854775808", R<I64>.failure(.overflow))
        Case(item).decode("-00000000000000000001", R<U64>.failure(.overflow))
        Case(item).decode("-00000000000000000000", R<U64>.success(.min))
        Case(item).decode("+18446744073709551615", R<U64>.success(.max))
        Case(item).decode("+18446744073709551616", R<U64>.failure(.overflow))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encoding (and Decoding)
    //=------------------------------------------------------------------------=
    
    func testEncodingAsBase10() {
        let item = TextInt.radix(10)
        
        func whereTypeIs<T>(_ type: T.Type) where T: BinaryInteger {
            guard T.size >= U8.size else { return }
            if  T.isSigned {
                Case(item).encode(T(load: I8 (load: 0x00 as U64)),    "0")
                Case(item).encode(T(load: I8 (load: 0x7f as U64)),  "127") // I8.max
                Case(item).encode(T(load: I8 (load: 0x80 as U64)), "-128") // I8.min
                Case(item).encode(T(load: I8 (load: 0x07 as U64)),    "7")
                Case(item).encode(T(load: I8 (load: 0xff as U64)),   "-1")
            }   else {
                Case(item).encode(T(load: U8 (load: 0x00 as U64)),    "0") // U8.min
                Case(item).encode(T(load: U8 (load: 0x7f as U64)),  "127")
                Case(item).encode(T(load: U8 (load: 0x80 as U64)),  "128")
                Case(item).encode(T(load: U8 (load: 0x07 as U64)),    "7")
                Case(item).encode(T(load: U8 (load: 0xff as U64)),  "255") // U8.max
            }
            
            guard T.size >= U16.size else { return }
            if  T.isSigned {
                Case(item).encode(T(load: I16(load: 0x0000 as U64)),      "0")
                Case(item).encode(T(load: I16(load: 0x0100 as U64)),    "256")
                Case(item).encode(T(load: I16(load: 0x7fff as U64)),  "32767") // I16.max
                Case(item).encode(T(load: I16(load: 0x8000 as U64)), "-32768") // I16.min
                Case(item).encode(T(load: I16(load: 0x807f as U64)), "-32641")
                Case(item).encode(T(load: I16(load: 0xfffe as U64)),     "-2")
                Case(item).encode(T(load: I16(load: 0xffff as U64)),     "-1")
            }   else {
                Case(item).encode(T(load: U16(load: 0x0000 as U64)),      "0") // U16.min
                Case(item).encode(T(load: U16(load: 0x0100 as U64)),    "256")
                Case(item).encode(T(load: U16(load: 0x7fff as U64)),  "32767")
                Case(item).encode(T(load: U16(load: 0x8000 as U64)),  "32768")
                Case(item).encode(T(load: U16(load: 0x807f as U64)),  "32895")
                Case(item).encode(T(load: U16(load: 0xfffe as U64)),  "65534")
                Case(item).encode(T(load: U16(load: 0xffff as U64)),  "65535") // U16.max
            }
            
            guard T.size >= U32.size else { return }
            if  T.isSigned {
                Case(item).encode(T(load: I32(load: 0x00000000 as U64)),           "0")
                Case(item).encode(T(load: I32(load: 0x03020100 as U64)),    "50462976")
                Case(item).encode(T(load: I32(load: 0x7fffffff as U64)),  "2147483647") // I32.max
                Case(item).encode(T(load: I32(load: 0x80000000 as U64)), "-2147483648") // I32.min
                Case(item).encode(T(load: I32(load: 0x81807f7e as U64)), "-2122285186")
                Case(item).encode(T(load: I32(load: 0xfffefdfc as U64)),      "-66052")
                Case(item).encode(T(load: I32(load: 0xffffffff as U64)),          "-1")
            }   else {
                Case(item).encode(T(load: U32(load: 0x00000000 as U64)),           "0") // U32.min
                Case(item).encode(T(load: U32(load: 0x03020100 as U64)),    "50462976")
                Case(item).encode(T(load: U32(load: 0x7fffffff as U64)),  "2147483647")
                Case(item).encode(T(load: U32(load: 0x80000000 as U64)),  "2147483648")
                Case(item).encode(T(load: U32(load: 0x81807f7e as U64)),  "2172682110")
                Case(item).encode(T(load: U32(load: 0xfffefdfc as U64)),  "4294901244")
                Case(item).encode(T(load: U32(load: 0xffffffff as U64)),  "4294967295") // U32.max
            }
            
            guard T.size >= U64.size else { return }
            if  T.isSigned {
                Case(item).encode(T(load: I64(load: 0x0000000000000000 as U64)),                    "0")
                Case(item).encode(T(load: I64(load: 0x0706050403020100 as U64)),   "506097522914230528")
                Case(item).encode(T(load: I64(load: 0x7fffffffffffffff as U64)),  "9223372036854775807") // I64.max
                Case(item).encode(T(load: I64(load: 0x8000000000000000 as U64)), "-9223372036854775808") // I64.max
                Case(item).encode(T(load: I64(load: 0x838281807f7e7d7c as U64)), "-8970465118873813636")
                Case(item).encode(T(load: I64(load: 0xfffefdfcfbfaf9f8 as U64)),     "-283686952306184")
                Case(item).encode(T(load: I64(load: 0xffffffffffffffff as U64)),                   "-1")
            }   else {
                Case(item).encode(T(load: U64(load: 0x0000000000000000 as U64)),                    "0") // U64.min
                Case(item).encode(T(load: U64(load: 0x0706050403020100 as U64)),   "506097522914230528")
                Case(item).encode(T(load: U64(load: 0x7fffffffffffffff as U64)),  "9223372036854775807")
                Case(item).encode(T(load: U64(load: 0x8000000000000000 as U64)),  "9223372036854775808")
                Case(item).encode(T(load: U64(load: 0x838281807f7e7d7c as U64)),  "9476278954835737980")
                Case(item).encode(T(load: U64(load: 0xfffefdfcfbfaf9f8 as U64)), "18446460386757245432")
                Case(item).encode(T(load: U64(load: 0xffffffffffffffff as U64)), "18446744073709551615") // U64.max
            }
        }
        
        for type in coreSystemsIntegers {
            whereTypeIs(type)
        }
    }
}
