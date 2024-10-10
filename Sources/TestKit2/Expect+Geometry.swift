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
// MARK: * Expect x Geometry
//*============================================================================*

@inlinable public func Ɣexpect<T>(
    _  value: T,
    isqrt expectation: T,
    at location: SourceLocation = #_sourceLocation
)   throws where T: BinaryInteger {
    
    let low = try #require(expectation.squared().optional())
    #expect(value >= low, sourceLocation: location)
    
    guard let high = expectation.incremented().squared().optional() else { return }
    #expect(value < high, sourceLocation: location)
}
