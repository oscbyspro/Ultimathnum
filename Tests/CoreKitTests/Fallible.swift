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
// MARK: * Fallible
//*============================================================================*

final class FallibleTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testGet() {
        //=--------------------------------------=
        enum Bad: Error { case code123, code456 }
        //=--------------------------------------=
        Case(Fallible<IX>(0, error: false)).prune(Bad.code123, is: .success(00000000000))
        Case(Fallible<IX>(0, error: true )).prune(Bad.code123, is: .failure(Bad.code123))
        Case(Fallible<IX>(0, error: false)).prune(Bad.code456, is: .success(00000000000))
        Case(Fallible<IX>(0, error: true )).prune(Bad.code456, is: .failure(Bad.code456))
        Case(Fallible<IX>(1, error: false)).prune(Bad.code123, is: .success(00000000001))
        Case(Fallible<IX>(1, error: true )).prune(Bad.code123, is: .failure(Bad.code123))
        Case(Fallible<IX>(1, error: false)).prune(Bad.code456, is: .success(00000000001))
        Case(Fallible<IX>(1, error: true )).prune(Bad.code456, is: .failure(Bad.code456))
    }
    
    //*========================================================================*
    // MARK: * Case
    //*========================================================================*
    
    struct Case<Value> where Value: Equatable {
        
        typealias Item = Fallible<Value>
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=

        var test: Test
        var item: Item
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        init(_ item: Item, test: Test) {
            self.test = test
            self.item = item
        }
        
        init(_ item: Item, file: StaticString = #file, line: UInt = #line) {
            self.init(item, test: Test(file: file, line: line))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension FallibleTests.Case {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func prune<E>(_ error: E, is expectation: Result<Value, E>) where E: Equatable {
        test.result({ try item.prune(error) }, expectation, "prune")
        test.same(item.result(error), expectation, "result")
        test.same(item.optional(), try? expectation.get(), "optional")
    }
}
