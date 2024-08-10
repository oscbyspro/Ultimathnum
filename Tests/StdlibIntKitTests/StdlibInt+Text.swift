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
// MARK: * Stdlib Int x Text
//*============================================================================*

extension StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    func testInitText() {
        Test().same(T( "10"),  10)
        Test().same(T("+10"),  10)
        Test().same(T("-10"), -10)
        Test().same(T( "ff"), nil)
        
        Test().success({ try T( "10", as:     .decimal) },   10)
        Test().success({ try T("+10", as:     .decimal) },   10)
        Test().success({ try T("-10", as:     .decimal) },  -10)
        Test().failure({ try T( "ff", as:     .decimal) },  TextInt.Error.invalid)
        Test().failure({ try T("+ff", as:     .decimal) },  TextInt.Error.invalid)
        Test().failure({ try T("-ff", as:     .decimal) },  TextInt.Error.invalid)
        Test().failure({ try T( "zz", as:     .decimal) },  TextInt.Error.invalid)
        Test().failure({ try T("+zz", as:     .decimal) },  TextInt.Error.invalid)
        Test().failure({ try T("-zz", as:     .decimal) },  TextInt.Error.invalid)
        Test().success({ try T( "10", as: .hexadecimal) },   16)
        Test().success({ try T("+10", as: .hexadecimal) },   16)
        Test().success({ try T("-10", as: .hexadecimal) },  -16)
        Test().success({ try T( "ff", as: .hexadecimal) },  255)
        Test().success({ try T("+ff", as: .hexadecimal) },  255)
        Test().success({ try T("-ff", as: .hexadecimal) }, -255)
        Test().failure({ try T( "zz", as: .hexadecimal) },  TextInt.Error.invalid)
        Test().failure({ try T("+zz", as: .hexadecimal) },  TextInt.Error.invalid)
        Test().failure({ try T("-zz", as: .hexadecimal) },  TextInt.Error.invalid)
    }
    
    func testMakeText() {
        Test().same(T( 9999).description,                    "9999")
        Test().same(T(-9999).description,                   "-9999")
        Test().same(T( 9999).description(as:     .decimal),  "9999")
        Test().same(T(-9999).description(as:     .decimal), "-9999")
        Test().same(T( 9999).description(as: .hexadecimal),  "270f")
        Test().same(T(-9999).description(as: .hexadecimal), "-270f")
    }
}
