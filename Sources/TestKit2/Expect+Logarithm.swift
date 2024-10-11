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
// MARK: * Expect x Logarithm
//*============================================================================*

@inlinable public func Ɣexpect<T>(
    _  value: T,
    ilog2 expectation: Count,
    at location: SourceLocation = #_sourceLocation
)   throws where T: BinaryInteger {
        
    let ilog2 = try #require(value.ilog2())
    #expect(ilog2 == expectation, sourceLocation: location)
    #expect(ilog2 <  T.size,      sourceLocation: location)
    #expect(ilog2.isInfinite == value.isInfinite, sourceLocation: location)
    
    if !ilog2.isInfinite {
        let low = T.lsb.up(ilog2)
        #expect(value >= low, sourceLocation: location)

        if  let high = low.times(2).optional() {
            #expect(value < high, sourceLocation: location)
        }
    }
}
