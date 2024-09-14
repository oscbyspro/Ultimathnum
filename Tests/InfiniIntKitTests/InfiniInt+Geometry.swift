//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Infini Int x Geometry
//*============================================================================*

final class InfiniIntTestsOnGeometry: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// - Seealso: https://www.wolframalpha.com/input?i=floor%28sqrt%28321%21%29%29
    func testIntegerSquareRootOfFactorial321() {
        let value = IXL(321).factorial()!
        let expectation = UXL("""
        0000000000000000000000000000000000000000000000000026062792913603\
        4852359151877315143131904266127104261942203056907277755117135873\
        5999735977332697495465868036180289948163225036497853196327377133\
        3804099951819160430912720514963353046932086492435801453916838004\
        8131925747401035885523686460539264165373280627726671674087518980\
        3775713261640843722248736613200259232221333640637256452385600599
        """)!
        
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            let isqrt = T(value).isqrt()!
            Test().comparison(isqrt, expectation, Signum.zero)
            Test().comparison(isqrt.plus(0).squared().unwrap(), value, Signum.negative)
            Test().comparison(isqrt.plus(1).squared().unwrap(), value, Signum.positive)
        }
        
        whereIs(IXL.self)
        whereIs(UXL.self)
        #if !DEBUG
        whereIs(InfiniInt<I8>.self)
        whereIs(InfiniInt<U8>.self)
        #endif
    }
}
