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
// MARK: * Data Int x Buffer
//*============================================================================*

extension DataIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUnsafeBufferPointer() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            Test().none(DataInt<T>(UnsafeBufferPointer(start: nil, count: 0)))
            Test().none(DataInt<T>.Body(UnsafeBufferPointer(start: nil, count: 0)))
            Test().none(MutableDataInt<T>(UnsafeMutableBufferPointer(start: nil, count: 0)))
            Test().none(MutableDataInt<T>.Body(UnsafeMutableBufferPointer(start: nil, count: 0)))
            
            var body = Array(repeating: T.zero, count: 3)
            body.withUnsafeMutableBufferPointer {
                let start =  $0.baseAddress!
                for count in IX.zero ..< IX($0.count) {
                    always: do {
                        let body = DataInt.Body(start, count: count)
                        Test().same(body.start, start)
                        Test().same(body.count, count)
                        Test().same(Array(body.buffer()), Array($0.prefix(Int(count))))
                    }
                        
                    always: do {
                        let body = MutableDataInt.Body(start, count: count)
                        Test().same(body.start, start)
                        Test().same(body.count, count)
                        Test().same(Array(body.buffer()), Array($0.prefix(Int(count))))
                    }
                    
                    for bit: Bit in [0, 1] {
                        let elements = DataInt(start, count: count, repeating: bit)
                        Test().same(elements.body.start, start)
                        Test().same(elements.body.count, count)
                        Test().same(elements.appendix, ((bit)))
                    }
                    
                    for bit: Bit in [0, 1] {
                        let elements = MutableDataInt(start, count: count, repeating: bit)
                        Test().same(elements.body.start, start)
                        Test().same(elements.body.count, count)
                        Test().same(elements.appendix, ((bit)))
                    }
                }
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
}
