//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Castable
//*============================================================================*

/// A type that supports type-safe reinterpretation.
///
/// Models that share the same `BitPattern` type are bitwise compatible, and you
/// may reinterpret an instance of either type as an instance of the other using
/// the generic `init(raw:)` initializer.
///
public protocol BitCastable<BitPattern> {
    
    /// The bit pattern representation used by this type.
    associatedtype BitPattern: BitCastable<BitPattern> & Sendable
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Reinterprets the `source` as an instance of this type.
    @inlinable init(raw source: consuming BitPattern)
    
    /// Reinterprets `self` as an instance of the given `type`.
    @inlinable consuming func load(as type: BitPattern.Type) -> BitPattern
}
