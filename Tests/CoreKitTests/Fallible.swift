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
        func expect(_ item: Fallible<IX>, prune failure: Bad, is expectation: Result<IX, Bad>, line: UInt = #line) {
            Test(line: line).result(try item.prune(failure), expectation, "prune")
            Test(line: line).same(item.result(failure), expectation, "result")
            Test(line: line).same(item.optional(), try? expectation.get(), "optional")
        }
        
        expect(Fallible<IX>(0, error: false), prune: Bad.code123, is: .success(00000000000))
        expect(Fallible<IX>(0, error: true ), prune: Bad.code123, is: .failure(Bad.code123))
        expect(Fallible<IX>(0, error: false), prune: Bad.code456, is: .success(00000000000))
        expect(Fallible<IX>(0, error: true ), prune: Bad.code456, is: .failure(Bad.code456))
        expect(Fallible<IX>(1, error: false), prune: Bad.code123, is: .success(00000000001))
        expect(Fallible<IX>(1, error: true ), prune: Bad.code123, is: .failure(Bad.code123))
        expect(Fallible<IX>(1, error: false), prune: Bad.code456, is: .success(00000000001))
        expect(Fallible<IX>(1, error: true ), prune: Bad.code456, is: .failure(Bad.code456))
    }
    
    func testInvalidation() {
        Test().same(IX(0).veto(              ), Fallible(0, error: true ))
        Test().same(IX(1).veto(       false  ), Fallible(1, error: false))
        Test().same(IX(2).veto(       true   ), Fallible(2, error: true ))
        Test().same(IX(3).veto({ _ in false }), Fallible(3, error: false))
        Test().same(IX(4).veto({ _ in true  }), Fallible(4, error: true ))
        
        Test().same(Fallible<IX>(0, error: false).veto(              ), Fallible(0, error: true ))
        Test().same(Fallible<IX>(1, error: true ).veto(              ), Fallible(1, error: true ))
        Test().same(Fallible<IX>(2, error: false).veto(       false  ), Fallible(2, error: false))
        Test().same(Fallible<IX>(3, error: false).veto(       true   ), Fallible(3, error: true ))
        Test().same(Fallible<IX>(4, error: true ).veto(       false  ), Fallible(4, error: true ))
        Test().same(Fallible<IX>(5, error: true ).veto(       true   ), Fallible(5, error: true ))
        Test().same(Fallible<IX>(6, error: false).veto({ _ in false }), Fallible(6, error: false))
        Test().same(Fallible<IX>(7, error: false).veto({ _ in true  }), Fallible(7, error: true ))
        Test().same(Fallible<IX>(8, error: true ).veto({ _ in false }), Fallible(8, error: true ))
        Test().same(Fallible<IX>(9, error: true ).veto({ _ in true  }), Fallible(9, error: true ))
    }
    
    func testComparison() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var success = U32.min
            let values8 = (I8.min ... I8.max).lazy.map(T.init(load:))
            
            for lhs in values8 {
                for rhs in values8 {
                    let equal = lhs == rhs
                    success &+= U32(Bit((lhs.veto(false) == rhs.veto(false)) == equal))
                    success &+= U32(Bit((lhs.veto(false) == rhs.veto(true )) == false))
                    success &+= U32(Bit((lhs.veto(true ) == rhs.veto(false)) == false))
                    success &+= U32(Bit((lhs.veto(true ) == rhs.veto(true )) == equal))
                }
            }
            
            Test().same(success, 4 &* 256 &* 256)
        }
        
        whereIs(I8.self)
        whereIs(U8.self)
    }
}
