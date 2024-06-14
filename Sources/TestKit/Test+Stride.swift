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
// MARK: * Test x Stride
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func distance<T, D>(
        _ start: T, 
        _ end:   T,
        _ expectation: Fallible<D>,
        lossy: Bool = false
    )   where T: BinaryInteger, D: SignedInteger {
        
        let distance = start.distance(to: end, as: D.self)
        let advanced = start.advanced(by: distance .value)
        
        always: do {
            same(distance, expectation, "distance(to:)")
        }
        
        if !lossy {
            same(advanced, end.veto(expectation.error), "advanced(by:) [0]")
        }   else {
            yay (expectation.error,      "advanced(by:) [1]")
            nonsame(advanced.value, end, "advanced(by:) [2]")
        }
    }
}
