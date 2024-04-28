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
/// - TODO: It should conform to BitCastable.
///
/// ### Development
///
/// Swift does not expose unchecked shifts to there's no reason to premask it.
///
@frozen public struct Shift<Value>: BitCastable where Value: BinaryInteger {
    
    public typealias BitPattern = Shift<Value.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static func predicate(_ value: Value) -> Bool {
        !Bool(value.appendix) && Value.Magnitude(raw: value) < Value.size
    }
    
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
    // MARK: Initializes
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming BitPattern) {
        self.init(unchecked: Value(raw: source.value))
    }
    
    @inlinable public func load(as type: BitPattern.Type) -> BitPattern {
        BitPattern(unchecked: Value.Magnitude(raw: self.value))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func nondistance() -> Self where Value: SystemsInteger {
        Self(unchecked: Value(raw: Value.size).minus(self.value).assert())
    }
}
