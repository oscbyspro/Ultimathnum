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
// MARK: * Test x Floats
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func stdlib<A, B>(
        _ source: A, is destination: B?, exactly: Bool = false, as type: B.Type = B.self
    )   where A: Swift.BinaryFloatingPoint, B: BinaryInteger {
        
        if  let destination {
            same(B.init     (source), destination)
            same(B.exactly  (source), Fallible(destination, error: !exactly).optional())
            same(B.leniently(source), Fallible(destination, error: !exactly))
        }   else {
            none(B.exactly  (source))
            none(B.leniently(source))
        }
    }
}
