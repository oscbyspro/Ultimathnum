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
// MARK: * Expect x Random x Utilities
//*============================================================================*

@inlinable public func Ɣexpect<T>(
    entropic randomness: inout some Randomness,
    through index: Shift<T.Magnitude>,
    as domain: Domain,
    is expectation: Set<T>,
    at location: SourceLocation = #_sourceLocation
)   where T: BinaryInteger {
    var result = Set<T>()
    
    while result.count < expectation.count {
        for _ in 000 ..< expectation.count {
            result.insert(T.entropic(through: index, as: domain, using: &randomness))
        }
    }
    
    #expect(result == expectation, sourceLocation: location)
}
