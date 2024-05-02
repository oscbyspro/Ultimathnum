//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Integer Invariants x Count
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func count() {
        for bit: Bit in [0, 1] {
            test.count( 0 as T,            (bit), bit == 0 ? T.size : 0)
            test.count(~0 as T,            (bit), bit == 1 ? T.size : 0)
            test.count( 0 as T,  .ascending(bit), bit == 0 ? T.size : 0)
            test.count(~0 as T,  .ascending(bit), bit == 1 ? T.size : 0)
            test.count( 0 as T, .descending(bit), bit == 0 ? T.size : 0)
            test.count(~0 as T, .descending(bit), bit == 1 ? T.size : 0)
            
            for element: (value: T, bit: Bit) in [(11, 0), (~11, 1)] {
                Test().same(element.value.count(           (bit)), bit == element.bit ? T.size - 3 : 3)
                Test().same(element.value.count( .ascending(bit)), bit == element.bit ? 0000000000 : 2)
                Test().same(element.value.count(.descending(bit)), bit == element.bit ? T.size - 4 : 0)
            }
        }
        
    }
}
