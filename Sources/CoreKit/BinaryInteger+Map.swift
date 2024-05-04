//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Map
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(map: (Self) -> Self) -> Void {
        mutating get {
            self = map(self)
        }
    }
    
    @inlinable public subscript(map: (Self) -> Fallible<Self>) -> Bool {
        mutating get {
            let result = map(self)
            self = result.value
            return result.error
        }
    }
}
