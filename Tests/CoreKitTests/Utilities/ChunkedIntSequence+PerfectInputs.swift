//=----------------------------------------------------------------------------=
// This source file is part of the Iltimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import MainIntKit
import TestKit

//*============================================================================*
// MARK: * Chunked Int Sequence x Perfect Inputs
//*============================================================================*

extension ChunkedIntSequenceTests {
            
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func test32As32() {
        check([              ] as [I32], [              ] as [I32])
        check([ 1            ] as [I32], [ 1            ] as [I32])
        check([ 1,  2        ] as [I32], [ 1,  2        ] as [I32])
        check([ 1,  2,  3    ] as [I32], [ 1,  2,  3    ] as [I32])
        check([ 1,  2,  3,  4] as [I32], [ 1,  2,  3,  4] as [I32])
        
        check([              ] as [I32], [              ] as [I32])
        check([~1            ] as [I32], [~1            ] as [I32])
        check([~1, ~2        ] as [I32], [~1, ~2        ] as [I32])
        check([~1, ~2, ~3    ] as [I32], [~1, ~2, ~3    ] as [I32])
        check([~1, ~2, ~3, ~4] as [I32], [~1, ~2, ~3, ~4] as [I32])
    }
    
    func test32As64() {
        check([                              ] as [I32], [              ] as [I64])
        check([ 1,  0                        ] as [I32], [ 1            ] as [I64])
        check([ 1,  0,  2,  0                ] as [I32], [ 1,  2        ] as [I64])
        check([ 1,  0,  2,  0,  3,  0        ] as [I32], [ 1,  2,  3    ] as [I64])
        check([ 1,  0,  2,  0,  3,  0,  4,  0] as [I32], [ 1,  2,  3,  4] as [I64])
        
        check([                              ] as [I32], [              ] as [I64])
        check([~1, ~0                        ] as [I32], [~1            ] as [I64])
        check([~1, ~0, ~2, ~0                ] as [I32], [~1, ~2        ] as [I64])
        check([~1, ~0, ~2, ~0, ~3, ~0        ] as [I32], [~1, ~2, ~3    ] as [I64])
        check([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as [I32], [~1, ~2, ~3, ~4] as [I64])
    }
    
    func test64As64() {
        check([              ] as [I64], [              ] as [I64])
        check([ 1            ] as [I64], [ 1            ] as [I64])
        check([ 1,  2        ] as [I64], [ 1,  2        ] as [I64])
        check([ 1,  2,  3    ] as [I64], [ 1,  2,  3    ] as [I64])
        check([ 1,  2,  3,  4] as [I64], [ 1,  2,  3,  4] as [I64])
        
        check([              ] as [I64], [              ] as [I64])
        check([~1            ] as [I64], [~1            ] as [I64])
        check([~1, ~2        ] as [I64], [~1, ~2        ] as [I64])
        check([~1, ~2, ~3    ] as [I64], [~1, ~2, ~3    ] as [I64])
        check([~1, ~2, ~3, ~4] as [I64], [~1, ~2, ~3, ~4] as [I64])
    }
    
    func test64As32() {
        check([              ] as [I64], [                              ] as [I32])
        check([ 1            ] as [I64], [ 1,  0                        ] as [I32])
        check([ 1,  2        ] as [I64], [ 1,  0,  2,  0                ] as [I32])
        check([ 1,  2,  3    ] as [I64], [ 1,  0,  2,  0,  3,  0        ] as [I32])
        check([ 1,  2,  3,  4] as [I64], [ 1,  0,  2,  0,  3,  0,  4,  0] as [I32])
        
        check([              ] as [I64], [                              ] as [I32])
        check([~1            ] as [I64], [~1, ~0                        ] as [I32])
        check([~1, ~2        ] as [I64], [~1, ~0, ~2, ~0                ] as [I32])
        check([~1, ~2, ~3    ] as [I64], [~1, ~0, ~2, ~0, ~3, ~0        ] as [I32])
        check([~1, ~2, ~3, ~4] as [I64], [~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as [I32])
    }
}
