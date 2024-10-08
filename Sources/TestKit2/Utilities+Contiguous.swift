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
// MARK: * Utilities x Contiguous
//*============================================================================*

extension Contiguous {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable public borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (DataInt<Element>.Body) throws -> T
    )   rethrows -> T {
        try self.withUnsafeBufferPointer {
            try action(DataInt.Body($0)!)
        }
    }

    @inlinable public mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (MutableDataInt<Element>.Body) throws -> T
    )   rethrows -> T where Self: MutableContiguous {
        try self.withUnsafeMutableBufferPointer {
            try action(MutableDataInt.Body($0)!)
        }
    }
}
