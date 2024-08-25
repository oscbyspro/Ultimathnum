//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Interoperable
//*============================================================================*

/// A type with a standard-library-compatible representation.
public protocol Interoperable {
    
    /// The standard-library-compatible representation of `Self`.
    associatedtype Stdlib
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Reinterprets the given `source` as this type.
    @inlinable init(_ source: consuming Stdlib)
    
    /// Reiinterprets `self` as a standard-library-compatible type.
    @inlinable consuming func stdlib() -> Stdlib
}
