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
// MARK: * Infini Int Storage x Memory
//*============================================================================*

extension InfiniIntStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (DataInt<Element>.Body) throws -> T
    )   rethrows -> T {
        
        try self.body.withUnsafeBufferPointer {
            try action(DataInt.Body($0)!)
        }
    }
    
    @inlinable public mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (DataInt<Element>.Canvas) throws -> T
    )   rethrows -> T {
        
        let result = try self.body.withUnsafeMutableBufferPointer {
            try action(DataInt.Canvas($0)!)
        }
        
        return result as T
    }
}
