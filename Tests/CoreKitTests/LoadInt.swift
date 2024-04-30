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
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitDataInt() {
        [U8](repeating: 0, count: 16).withUnsafeBufferPointer {
            let body = DataInt<U8>.Body($0)!
            
            for bit: Bit in [0, 1] {
                Test().same(LoadInt<U8>(body, repeating: bit).data.body.start, $0.baseAddress!)
                Test().same(LoadInt<U8>(body, repeating: bit).data.body.count, IX($0.count))
                Test().same(LoadInt<U8>(body, repeating: bit).appendix, bit)
                
                Test().same(LoadInt<U8>(DataInt(body, repeating: bit)).data.body.start, $0.baseAddress!)
                Test().same(LoadInt<U8>(DataInt(body, repeating: bit)).data.body.count, IX($0.count))
                Test().same(LoadInt<U8>(DataInt(body, repeating: bit)).appendix, bit)
            }
        }
    }
    
    func testInitUnsafeBufferPointer() {
        Test().none(LoadInt<U8>(UnsafeBufferPointer(start: nil, count: 0)))
        
        [U8](repeating: 0, count: 16).withUnsafeBufferPointer {
            Test().same(LoadInt<U8>($0)!.appendix,   .zero)
            Test().same(LoadInt<U8>($0.baseAddress!, count: IX($0.count)).appendix, .zero)

            for bit: Bit in [0, 1] {
                Test().same(LoadInt<U8>($0, repeating: bit)!.data.body.start, $0.baseAddress!)
                Test().same(LoadInt<U8>($0, repeating: bit)!.data.body.count, IX($0.count))
                Test().same(LoadInt<U8>($0, repeating: bit)!.appendix, bit)
                
                Test().same(LoadInt<U8>($0.baseAddress!, count: IX($0.count), repeating: bit).data.body.start, $0.baseAddress!)
                Test().same(LoadInt<U8>($0.baseAddress!, count: IX($0.count), repeating: bit).data.body.count, IX($0.count))
                Test().same(LoadInt<U8>($0.baseAddress!, count: IX($0.count), repeating: bit).appendix, bit)
            }
        }
    }
    
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
            var elements = [Element]()
            
            while !$0.appendixIndexIsZero {
                elements.append($0.next())
            }
            
            return elements
        }
    }
    
    func prefix(_ count: UX, is expectation: [Element]) {
        self.expect(expectation) {
            var elements = [Element]()
            
            for _ in 0 ..< count {
                elements.append($0.next())
            }
            
            return elements
        }
    }
    
    func normalized(is expectation: [Element]) {
        self.expect(expectation) {
            var elements = [Element]()
            
            $0 = $0.normalized()
            
            while !$0.appendixIndexIsZero {
                elements.append($0.next())
            }
            
            return elements
        }
    }
    
    func load(bytes index: PartialRangeFrom<UX>, is expectation: Element) {
        self.expect(expectation) {
            $0[bytes: index.lowerBound...].load()
        }
    }
    
    func expect<T: Equatable>(_ expectation: T, from map: (inout LoadInt<Element>) -> T) {
        self.item.body.withUnsafeBufferPointer {
            if  self.item.appendix != 0 {
                var source = LoadInt<Element>(DataInt($0, repeating: 1)!)
                test.same(map(&source), expectation)
            }
            
            if  self.item.appendix != 1 {
                var source = LoadInt<Element>(DataInt($0, repeating: 0)!)
                test.same(map(&source), expectation)
            }
        }
    }
}
