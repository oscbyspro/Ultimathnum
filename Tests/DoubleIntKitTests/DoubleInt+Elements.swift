//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import TestKit

//*============================================================================*
// MARK: * Double Int x Elements
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitElements() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            let count = MemoryLayout<T>.size / MemoryLayout<T.Element>.stride
            for isSigned in [true, false] {
                Test.elements(Array(ExchangeInt( T.min).bitPattern.source()), isSigned,  isSigned ? T.min : nil)
                Test.elements(Array(ExchangeInt( T.max).bitPattern.source()), isSigned,  T.max)
                
                Test.elements(Array(ExchangeInt( M.min).bitPattern.source()), isSigned,  00000 as T)
                Test.elements(Array(ExchangeInt( M.max).bitPattern.source()), isSigned,  isSigned ? -1 as T : nil as T?)
                Test.elements(Array(ExchangeInt( M.msb).bitPattern.source()), isSigned,  isSigned ?  T .min : nil as T?)
                Test.elements(Array(ExchangeInt(~M.msb).bitPattern.source()), isSigned, ~T.msb)
                
                Test.elements(Array(repeating:  0 as T.Element.Magnitude, count: 1 + count), isSigned, 000 as T?)
                Test.elements(Array(repeating:  1 as T.Element.Magnitude, count: 1 + count), isSigned, nil as T?)
                Test.elements(Array(repeating: ~1 as T.Element.Magnitude, count: 1 + count), isSigned, nil as T?)
                Test.elements(Array(repeating: ~0 as T.Element.Magnitude, count: 1 + count), isSigned, isSigned ? -1 as T : nil as T?)
            }
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            let count = MemoryLayout<T>.size / MemoryLayout<T.Element>.stride
            for isSigned in [true, false] {
                Test.elements(Array(ExchangeInt( M.min).bitPattern.source()), isSigned,  00000 as T?)
                Test.elements(Array(ExchangeInt( M.max).bitPattern.source()), isSigned,  isSigned ? nil : T.max as T?)
                Test.elements(Array(ExchangeInt( M.msb).bitPattern.source()), isSigned,  isSigned ? nil : T.msb as T?)
                Test.elements(Array(ExchangeInt(~M.msb).bitPattern.source()), isSigned, ~T.msb as T?)
                
                Test.elements(Array(repeating:  0 as T.Element.Magnitude, count: 1 + count), isSigned, 000 as T?)
                Test.elements(Array(repeating:  1 as T.Element.Magnitude, count: 1 + count), isSigned, nil as T?)
                Test.elements(Array(repeating: ~1 as T.Element.Magnitude, count: 1 + count), isSigned, nil as T?)
                Test.elements(Array(repeating: ~0 as T.Element.Magnitude, count: 1 + count), isSigned, nil as T?)
            }
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testMakeElements() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias EX = T.Element.Magnitude
            
            Test.elements(~1 as T, [EX(truncating: ~1 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<EX>.size))
            Test.elements(~0 as T, [EX(truncating: ~0 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<EX>.size))
            Test.elements( 0 as T, [EX(truncating:  0 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<EX>.size))
            Test.elements( 1 as T, [EX(truncating:  1 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<EX>.size))
            
            Test.elements(~1 as T, [U8(truncating: ~1 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test.elements(~0 as T, [U8(truncating: ~0 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test.elements( 0 as T, [U8(truncating:  0 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test.elements( 1 as T, [U8(truncating:  1 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            
            Test.elements(~1 as T, [UX(truncating: ~1 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test.elements(~0 as T, [UX(truncating: ~0 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test.elements( 0 as T, [UX(truncating:  0 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test.elements( 1 as T, [UX(truncating:  1 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
        }

        for type in Self.types {
            whereIs(type)
        }
    }
}
