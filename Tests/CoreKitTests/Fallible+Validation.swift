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
}
