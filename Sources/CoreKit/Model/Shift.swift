//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Shift
//*============================================================================*

/// A finite value from zero to the wrapped type's bit width.
///
/// ### Development
///
/// Swift does not expose unchecked shifts to there's no reason to premask it.
///
@frozen public struct Shift<Value> where Value: BinaryInteger {
    
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
    
    @inlinable public static func predicate(_ value: Value) -> Bool {
        !value.isInfinite && Value.Magnitude(bitPattern: value) < Value.size
    }
}
