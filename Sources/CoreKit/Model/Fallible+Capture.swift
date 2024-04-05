//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible x Capture
//*============================================================================*

extension Fallible {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func capture(_ map: (Value) throws -> Value) rethrows {
        self = try self.map(map)
    }
    
    @inlinable public mutating func capture(_ map: (Value) throws -> Fallible<Value>) rethrows {
        self = try self.map(map)
    }
}
