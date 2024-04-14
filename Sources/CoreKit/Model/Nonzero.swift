//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Nonzero
//*============================================================================*

@frozen public struct Nonzero<Value> where Value: Equatable & ExpressibleByIntegerLiteral {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let nonzero: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ nonzero: consuming Value) {
        precondition(Self.predicate((nonzero)))
        self.nonzero = nonzero
    }
    
    @inlinable public init(unchecked nonzero: consuming Value) {
        Swift.assert(Self.predicate((nonzero)))
        self.nonzero = nonzero
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func predicate(_ value: borrowing Value) -> Bool {
        (value != 0)
    }
}
