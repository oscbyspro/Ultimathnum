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
