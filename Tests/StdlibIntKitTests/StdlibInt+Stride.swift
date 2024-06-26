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
// MARK: * Stdlib Int x Stride
//*============================================================================*

extension StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testStride() {
        for start: StdlibInt in [0, 1, -1, Self.min128, Self.max128, Self.min256, Self.max256] {
            for distance: Swift.Int in [0, 1, -1,  Int.min, Int.max, Int.min + 1, Int.max - 1] {
                let end = start.advanced(by: distance)
                
                always: do {
                    Test().same(start.distance(to: end),  distance)
                }
                
                if  distance != Swift.Int.min {
                    Test().same(end.distance(to: start), -distance)
                }
            }
        }
    }
}
