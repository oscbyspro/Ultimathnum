//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import StdlibIntKit
import TestKit

//*============================================================================*
// MARK: * Stdlib Int x Geometry
//*============================================================================*

final class StdlibIntTestsOnGeometry: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIntegerSquareRootOfSmallValues() {
        Test().same(StdlibInt( 0).isqrt(), 0)
        Test().same(StdlibInt( 1).isqrt(), 1)
        Test().same(StdlibInt( 2).isqrt(), 1)
        Test().same(StdlibInt( 3).isqrt(), 1)
        Test().same(StdlibInt( 4).isqrt(), 2)
        Test().same(StdlibInt( 5).isqrt(), 2)
        Test().same(StdlibInt( 6).isqrt(), 2)
        Test().same(StdlibInt( 7).isqrt(), 2)
        Test().same(StdlibInt( 8).isqrt(), 2)
        Test().same(StdlibInt( 9).isqrt(), 3)
    }
    
    func testIntegerSquareRootOfNegativeIsNil() {
        Test().none(StdlibInt(-1).isqrt())
        Test().none(StdlibInt(-2).isqrt())
        Test().none(StdlibInt(-3).isqrt())
        Test().none(StdlibInt(-4).isqrt())
    }
    
    /// - Seealso: https://www.wolframalpha.com/input?i=floor%28sqrt%28321%21%29%29
    func testIntegerSquareRootOfFactorial321() {
        let index = StdlibInt(321)
        let element = index.factorial()!
        let isqrt = element.isqrt()!
        let expectation = StdlibInt("""
        0000000000000000000000000000000000000000000000000026062792913603\
        4852359151877315143131904266127104261942203056907277755117135873\
        5999735977332697495465868036180289948163225036497853196327377133\
        3804099951819160430912720514963353046932086492435801453916838004\
        8131925747401035885523686460539264165373280627726671674087518980\
        3775713261640843722248736613200259232221333640637256452385600599
        """)!
                
        Test().same((isqrt), expectation)
        Test().less((isqrt + 0) * (isqrt + 0), element)
        Test().more((isqrt + 1) * (isqrt + 1), element)
    }
}
