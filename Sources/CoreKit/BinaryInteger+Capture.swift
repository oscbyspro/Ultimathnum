//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Capture
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - TODO: Consider using `Fallible.capture(_:)` instead.
    ///
    @inlinable public mutating func capture(_ map: (Self) throws -> Self) rethrows {
        self = try map(self)
    }
    
    /// ### Development
    ///
    /// - TODO: Consider using `Fallible.capture(_:)` instead.
    ///
    @inlinable public mutating func capture(_ map: (Self) throws -> Fallible<Self>) rethrows -> Bool {
        try Fallible.capture(&self, map: map)
    }
}
