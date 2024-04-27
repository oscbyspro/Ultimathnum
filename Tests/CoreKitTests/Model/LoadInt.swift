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
// MARK: * Load Int
//*============================================================================*

final class LoadIntTests: XCTestCase {
    
    //*========================================================================*
    // MARK: * Item
    //*========================================================================*
    
    /// A proxy object.
    ///
    /// - Note: Both bits exhibit the same behavior when the `appendix` is `nil`.
    ///
    struct Item {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        let body: [U8]
        let appendix: Bit?
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        init(_ body: [U8], repeating appendix: Bit? = nil) {
            self.body = body
            self.appendix = appendix
        }
    }
    //*========================================================================*
    // MARK: * Case
    //*========================================================================*
    
    struct Case<Element> where Element: SystemsInteger & UnsignedInteger {
                
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
        
        init(_  item: Item, file: StaticString = #file, line: UInt = #line) {
            self.init(item, test: Test(file: file, line: line))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension LoadIntTests.Case {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func body(is expectation: [Element]) {
        self.expect(expectation) {
            Array($0.source())
        }
    }
    
    func prefix(_ count: UX, is expectation: [Element]) {
        self.expect(expectation) {
            Array($0.prefix(count))
        }
    }
    
    func normalized(is expectation: [Element]) {
        self.expect(expectation) {
            Array($0.normalized())
        }
    }
    
    func element(_ index: UX, is expectation: Element) {
        self.expect(expectation) {
            $0[index]
        }
    }
    
    func expect<T: Equatable>(_ expectation: T, from map: (LoadInt<Element>) -> T) {
        self.item.body.withUnsafeBufferPointer {
            if  self.item.appendix != 0 {
                test.same(map(LoadInt<Element>(DataInt($0, repeating: 1)!)), expectation)
            }
            
            if  self.item.appendix != 1 {
                test.same(map(LoadInt<Element>(DataInt($0, repeating: 0)!)), expectation)
            }
        }
    }
}
