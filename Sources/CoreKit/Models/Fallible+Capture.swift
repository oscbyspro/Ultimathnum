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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func capture(_ value: inout Value, map: (Value) throws -> Fallible<Value>) rethrows -> Bool {
        let overflow: Bool
        (value,overflow) = try map(value).components
        return overflow
    }
}
