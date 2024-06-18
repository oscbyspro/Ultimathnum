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
    
    public func bitCountForEachBitSelection() {
        for bit: Bit in [0, 1] {
            always: do {
                test     .count( 0 as T, bit, bit == 0 ? T.size : 0)
                test     .count(~0 as T, bit, bit == 1 ? T.size : 0)
                test .ascending( 0 as T, bit, bit == 0 ? T.size : 0)
                test .ascending(~0 as T, bit, bit == 1 ? T.size : 0)
                test.descending( 0 as T, bit, bit == 0 ? T.size : 0)
                test.descending(~0 as T, bit, bit == 1 ? T.size : 0)
            }
            
            for element: (value: T, bit: Bit) in [(11, 0), (~11, 1)] {
                test     .count(element.value, bit, bit == element.bit ? T.size - 3 : 3)
                test .ascending(element.value, bit, bit == element.bit ? 0000000000 : 2)
                test.descending(element.value, bit, bit == element.bit ? T.size - 4 : 0)
            }
            
            for element: (value: T, bit: Bit) in [(22, 0), (~22, 1)] {
                test     .count(element.value, bit, bit == element.bit ? T.size - 3 : 3)
                test .ascending(element.value, bit, bit == element.bit ? 0000000001 : 0)
                test.descending(element.value, bit, bit == element.bit ? T.size - 5 : 0)
            }
            
            for element: (value: T, bit: Bit) in [(33, 0), (~33, 1)] {
                test     .count(element.value, bit, bit == element.bit ? T.size - 2 : 2)
                test .ascending(element.value, bit, bit == element.bit ? 0000000000 : 1)
                test.descending(element.value, bit, bit == element.bit ? T.size - 6 : 0)
            }
            
            for element: (value: T, bit: Bit) in [(44, 0), (~44, 1)] {
                test     .count(element.value, bit, bit == element.bit ? T.size - 3 : 3)
                test .ascending(element.value, bit, bit == element.bit ? 0000000002 : 0)
                test.descending(element.value, bit, bit == element.bit ? T.size - 6 : 0)
            }
                        
            for element: (value: T, bit: Bit) in [(55, 0), (~55, 1)] {
                test     .count(element.value, bit, bit == element.bit ? T.size - 5 : 5)
                test .ascending(element.value, bit, bit == element.bit ? 0000000000 : 3)
                test.descending(element.value, bit, bit == element.bit ? T.size - 6 : 0)
            }
        }
    }
}
