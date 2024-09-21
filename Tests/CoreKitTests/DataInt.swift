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
// MARK: * Data Int
//*============================================================================*

final class DataIntTests: XCTestCase {
    
    //*========================================================================*
    // MARK: * Body
    //*========================================================================*
    
    struct Body<Element> where Element: SystemsInteger & UnsignedInteger {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        let test: Test
        let body: [Element]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        init(_ body: [Element], test: Test) {
            self.test = test
            self.body = body
        }
        
        
        init(_ body: [Element], file: StaticString = #file, line: UInt = #line) {
            self.test = Test(file: file, line: line)
            self.body = body
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        func expect<T: Equatable>(
            _ expectation: T,
            read:  (inout DataInt<Element>.Body) -> T,
            write: (inout MutableDataInt<Element>.Body) -> T
        ) {
            
            var copy = self.body
            copy.withUnsafeBufferPointer {
                var source = DataInt<Element>.Body($0)!
                test.same(read(&source), expectation)
            }
            
            copy.withUnsafeMutableBufferPointer {
                var source = MutableDataInt<Element>.Body($0)!
                test.same(write(&source), expectation)
            }
        }
    }
    
    //*========================================================================*
    // MARK: * Extension
    //*========================================================================*
    
    struct Extension<Element> where Element: SystemsInteger & UnsignedInteger {
        
        typealias Item = (body: [Element], appendix: Bit?)
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=

        var test: Test
        let item: Item
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        init(_  item: Item, test: Test) {
            self.test = test
            self.item = item
        }
        
        init(_  body: [Element], repeating appendix: Bit?, file: StaticString = #file, line: UInt = #line) {
            self.init((body, appendix), test: Test(file: file, line: line))
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        func expect<T: Equatable>(
            _ expectation: T,
            read:  (inout DataInt<Element>) -> T,
            write: (inout MutableDataInt<Element>) -> T
        ) {
            
            var copy = item
            copy.body.withUnsafeBufferPointer {
                if  self.item.appendix != Bit.zero {
                    var source = DataInt($0, repeating: Bit.one)!
                    test.same(read(&source), expectation)
                }
                
                if  self.item.appendix != Bit.one {
                    var source = DataInt($0, repeating: Bit.zero)!
                    test.same(read(&source), expectation)
                }
            }
            
            copy = self.item
            copy.body.withUnsafeMutableBufferPointer {
                if  self.item.appendix != Bit.zero {
                    var source = MutableDataInt($0, repeating: Bit.one)!
                    test.same(write(&source), expectation)
                }
            }
            
            
            copy = self.item
            copy.body.withUnsafeMutableBufferPointer {
                if  self.item.appendix != Bit.one {
                    var source = MutableDataInt($0, repeating: Bit.zero)!
                    test.same(write(&source), expectation)
                }
            }
        }
    }
}
