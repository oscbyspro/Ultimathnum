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

extension FallibleTests {
    
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
    
    func testInvalidation() {
        Test().same(Fallible<IX>(0, error: false).invalidated(              ), Fallible(0, error: true ))
        Test().same(Fallible<IX>(0, error: true ).invalidated(              ), Fallible(0, error: true ))
        Test().same(Fallible<IX>(0, error: false).invalidated(       false  ), Fallible(0, error: false))
        Test().same(Fallible<IX>(0, error: false).invalidated(       true   ), Fallible(0, error: true ))
        Test().same(Fallible<IX>(0, error: true ).invalidated(       false  ), Fallible(0, error: true ))
        Test().same(Fallible<IX>(0, error: true ).invalidated(       true   ), Fallible(0, error: true ))
        Test().same(Fallible<IX>(0, error: false).invalidated({ _ in false }), Fallible(0, error: false))
        Test().same(Fallible<IX>(0, error: false).invalidated({ _ in true  }), Fallible(0, error: true ))
        Test().same(Fallible<IX>(0, error: true ).invalidated({ _ in false }), Fallible(0, error: true ))
        Test().same(Fallible<IX>(0, error: true ).invalidated({ _ in true  }), Fallible(0, error: true ))
    }
}
