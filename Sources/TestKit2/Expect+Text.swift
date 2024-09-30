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
// MARK: * Expect x Text
//*============================================================================*

@inlinable public func Ɣexpect<T>(
    _ input: T,
    description expectation: String,
    at location: SourceLocation = #_sourceLocation
) where T: CustomStringConvertible {
    
    #expect(input.description         == expectation, sourceLocation: location)
    #expect(String(describing: input) == expectation, sourceLocation: location)
}

//*============================================================================*
// MARK: * Expect x Text x Integers
//*============================================================================*

/// Tests whether an integer's description is stable.
@inlinable public func Ɣexpect<T>(
    _  format: TextInt,
    bidirectional integer: T,
    at location: SourceLocation = #_sourceLocation
)   throws where T: BinaryInteger {
        
    let encoded = integer.description(as: format)
    let decoded = try T.init(encoded, as: format)
    #expect(decoded == integer, "BinaryInteger/description(_:as:) then BinaryInteger.init(_:as:)", sourceLocation: location)
}
