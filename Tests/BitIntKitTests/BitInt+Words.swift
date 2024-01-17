//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import BitIntKit
import CoreKit
import TestKit

//*============================================================================*
// MARK: * Bit Int x Words
//*============================================================================*

extension BitIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitWords() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            let count = T.max.words.count
            for isSigned in [true, false] {
                Test.words((-1 as T).words, isSigned, isSigned ? T.min : nil as T?)
                Test.words(( 0 as T).words, isSigned, T.max)
                
                Test.words(( 0 as M).words, isSigned, 000 as T?)
                Test.words(( 1 as M).words, isSigned, nil as T?)
                
                Test.words(Array(repeating:  0, count: count + 1), isSigned, 000 as T?)
                Test.words(Array(repeating:  1, count: count + 1), isSigned, nil as T?)
                Test.words(Array(repeating: ~1, count: count + 1), isSigned, nil as T?)
                Test.words(Array(repeating: ~0, count: count + 1), isSigned, isSigned ? -1 : nil as T?)
            }
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            let count = T.max.words.count
            for isSigned in [true, false] {
                Test.words(( 0 as M).words, isSigned, 00000 as T?)
                Test.words(( 1 as M).words, isSigned, T.max as T?)
                
                Test.words(Array(repeating:  0, count: count + 1), isSigned, 000 as T?)
                Test.words(Array(repeating:  1, count: count + 1), isSigned, nil as T?)
                Test.words(Array(repeating: ~1, count: count + 1), isSigned, nil as T?)
                Test.words(Array(repeating: ~0, count: count + 1), isSigned, nil as T?)
            }
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testMakeWords() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.words( 0 as T, [ 0] as [UX])
            Test.words(-1 as T, [~0] as [UX])
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.words( 0 as T, [ 0] as [UX])
            Test.words( 1 as T, [ 1] as [UX])
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
