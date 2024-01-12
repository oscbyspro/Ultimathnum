//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import ModelsKit
import MainIntKit
import TestKit

//*============================================================================*
// MARK: * Chunked x Perfect Inputs
//*============================================================================*

extension ChunkedTests {
            
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func test32As32() {
        check([              ] as [U32], [              ] as [U32])
        check([ 1            ] as [U32], [ 1            ] as [U32])
        check([ 1,  2        ] as [U32], [ 1,  2        ] as [U32])
        check([ 1,  2,  3    ] as [U32], [ 1,  2,  3    ] as [U32])
        check([ 1,  2,  3,  4] as [U32], [ 1,  2,  3,  4] as [U32])
        
        check([              ] as [U32], [              ] as [U32])
        check([~1            ] as [U32], [~1            ] as [U32])
        check([~1, ~2        ] as [U32], [~1, ~2        ] as [U32])
        check([~1, ~2, ~3    ] as [U32], [~1, ~2, ~3    ] as [U32])
        check([~1, ~2, ~3, ~4] as [U32], [~1, ~2, ~3, ~4] as [U32])
    }
    
    func test32As64() {
        check([                              ] as [U32], [              ] as [U64])
        check([ 1,  0                        ] as [U32], [ 1            ] as [U64])
        check([ 1,  0,  2,  0                ] as [U32], [ 1,  2        ] as [U64])
        check([ 1,  0,  2,  0,  3,  0        ] as [U32], [ 1,  2,  3    ] as [U64])
        check([ 1,  0,  2,  0,  3,  0,  4,  0] as [U32], [ 1,  2,  3,  4] as [U64])
        
        check([                              ] as [U32], [              ] as [U64])
        check([~1, ~0                        ] as [U32], [~1            ] as [U64])
        check([~1, ~0, ~2, ~0                ] as [U32], [~1, ~2        ] as [U64])
        check([~1, ~0, ~2, ~0, ~3, ~0        ] as [U32], [~1, ~2, ~3    ] as [U64])
        check([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as [U32], [~1, ~2, ~3, ~4] as [U64])
    }
    
    func test64As64() {
        check([              ] as [U64], [              ] as [U64])
        check([ 1            ] as [U64], [ 1            ] as [U64])
        check([ 1,  2        ] as [U64], [ 1,  2        ] as [U64])
        check([ 1,  2,  3    ] as [U64], [ 1,  2,  3    ] as [U64])
        check([ 1,  2,  3,  4] as [U64], [ 1,  2,  3,  4] as [U64])
        
        check([              ] as [U64], [              ] as [U64])
        check([~1            ] as [U64], [~1            ] as [U64])
        check([~1, ~2        ] as [U64], [~1, ~2        ] as [U64])
        check([~1, ~2, ~3    ] as [U64], [~1, ~2, ~3    ] as [U64])
        check([~1, ~2, ~3, ~4] as [U64], [~1, ~2, ~3, ~4] as [U64])
    }
    
    func test64As32() {
        check([              ] as [U64], [                              ] as [U32])
        check([ 1            ] as [U64], [ 1,  0                        ] as [U32])
        check([ 1,  2        ] as [U64], [ 1,  0,  2,  0                ] as [U32])
        check([ 1,  2,  3    ] as [U64], [ 1,  0,  2,  0,  3,  0        ] as [U32])
        check([ 1,  2,  3,  4] as [U64], [ 1,  0,  2,  0,  3,  0,  4,  0] as [U32])
        
        check([              ] as [U64], [                              ] as [U32])
        check([~1            ] as [U64], [~1, ~0                        ] as [U32])
        check([~1, ~2        ] as [U64], [~1, ~0, ~2, ~0                ] as [U32])
        check([~1, ~2, ~3    ] as [U64], [~1, ~0, ~2, ~0, ~3, ~0        ] as [U32])
        check([~1, ~2, ~3, ~4] as [U64], [~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as [U32])
    }
}
