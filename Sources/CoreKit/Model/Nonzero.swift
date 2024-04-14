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
    
    public let value: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ value: consuming Value) {
        guard Self.predicate(value) else { return nil }
        self.value = value
    }
    
    @inlinable public init(unchecked value: consuming Value) {
        Swift.assert(Self.predicate(value), String.brokenInvariant())
        self.value = value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func predicate(_ value: borrowing Value) -> Bool {
        (value != 0)
    }
}
