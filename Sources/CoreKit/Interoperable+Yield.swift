//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Interoperable x Yield
//*============================================================================*

extension Interoperable {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Yields its `stdlib` representation.
    ///
    /// - Note: Use the `stdlib()` method to transfer ownership.
    ///
    @inlinable public var stdlib: Stdlib {
        mutating _read {
            let stdlib = self.stdlib()
            yield stdlib
            self = Self(stdlib)
        }
        
        mutating _modify {
            var stdlib = self.stdlib()
            yield &stdlib
            self = Self(stdlib)
        }
    }
}
