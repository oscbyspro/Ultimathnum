//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Utilities x Pointers
//*============================================================================*

extension UnsafeBufferPointer: Contiguous {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func withUnsafeBufferPointer<T>(_ perform: (UnsafeBufferPointer<Element>) throws -> T) rethrows -> T {
        try perform(self)
    }
}

//*============================================================================*
// MARK: * Utilities x Pointers x Mutable
//*============================================================================*

extension UnsafeMutableBufferPointer: Contiguous {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func withUnsafeBufferPointer<T>(_ perform: (UnsafeBufferPointer<Element>) throws -> T) rethrows -> T {
        try perform(UnsafeBufferPointer(self))
    }
}
