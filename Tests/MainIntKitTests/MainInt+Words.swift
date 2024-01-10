//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import MainIntKit
import TestKit
import XCTest

//*============================================================================*
// MARK: * Main Int x Words
//*============================================================================*

extension MainIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitWords() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            let count   = T.max.words.count
            let isExact = T.bitWidth % M(load: Word(bitPattern: UX.bitWidth)) == 0
            for isSigned in [true, false] {
                XCTAssertEqual(try? T(words: ( T.min).words, isSigned: isSigned),  isSigned ? T.min : nil)
                XCTAssertEqual(try? T(words: ( T.max).words, isSigned: isSigned),  T.max)
                
                XCTAssertEqual(try? T(words: ( M.min).words, isSigned: isSigned),  00000)
                XCTAssertEqual(try? T(words: ( M.max).words, isSigned: isSigned),  isSigned && isExact ?  -001 : nil)
                XCTAssertEqual(try? T(words: ( M.msb).words, isSigned: isSigned),  isSigned && isExact ? T.min : nil)
                XCTAssertEqual(try? T(words: (~M.msb).words, isSigned: isSigned), ~T.msb)
                
                XCTAssertEqual(try? T(words: Array(repeating:  0, count: count + 1), isSigned: isSigned), 000)
                XCTAssertEqual(try? T(words: Array(repeating:  1, count: count + 1), isSigned: isSigned), nil)
                XCTAssertEqual(try? T(words: Array(repeating: ~1, count: count + 1), isSigned: isSigned), nil)
                XCTAssertEqual(try? T(words: Array(repeating: ~0, count: count + 1), isSigned: isSigned), isSigned ? -1 : nil)
            }
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            let count   = T.max.words.count
            let isExact = T.bitWidth % M(load: Word(bitPattern: UX.bitWidth)) == 0
            for isSigned in [true, false] {
                XCTAssertEqual(try? T(words: ( M.min).words, isSigned: isSigned),  00000)
                XCTAssertEqual(try? T(words: ( M.max).words, isSigned: isSigned),  isSigned && isExact ? nil : T.max)
                XCTAssertEqual(try? T(words: ( M.msb).words, isSigned: isSigned),  isSigned && isExact ? nil : T.msb)
                XCTAssertEqual(try? T(words: (~M.msb).words, isSigned: isSigned), ~T.msb)
                
                XCTAssertEqual(try? T(words: Array(repeating:  0, count: count + 1), isSigned: isSigned), 000)
                XCTAssertEqual(try? T(words: Array(repeating:  1, count: count + 1), isSigned: isSigned), nil)
                XCTAssertEqual(try? T(words: Array(repeating: ~1, count: count + 1), isSigned: isSigned), nil)
                XCTAssertEqual(try? T(words: Array(repeating: ~0, count: count + 1), isSigned: isSigned), nil)
            }
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testMakeWords() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.words(-2 as T, [~1] as [Word])
            Test.words(-1 as T, [~0] as [Word])
            Test.words( 0 as T, [ 0] as [Word])
            Test.words( 1 as T, [ 1] as [Word])
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.words( 0 as T, [ 0] as [Word])
            Test.words( 1 as T, [ 1] as [Word])
            Test.words( 2 as T, [ 2] as [Word])
            Test.words( 3 as T, [ 3] as [Word])
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
