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
// MARK: * Infini Int Storage x Elements
//*============================================================================*

extension InfiniIntStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal var count: IX {
        IX(self.body.count)
    }
    
    @inlinable internal func count(while predicate: (Element) -> Bool) -> IX {
        IX(self.body.prefix(while: predicate).count)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (DataInt<Element>.Body) throws -> T
    )   rethrows -> T {
        
        try self.body.withUnsafeBufferPointer {
            try action(DataInt.Body($0)!)
        }
    }
    
    @inlinable internal mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (MutableDataInt<Element>.Body) throws -> T
    )   rethrows -> T {
        
        let result = try self.body.withUnsafeMutableBufferPointer {
            try action(MutableDataInt.Body($0)!)
        }
        
        return result as T
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal borrowing func withUnsafeBinaryIntegerElements<T>(
        unchecked range: PartialRangeFrom<IX>,
        perform action: (DataInt<Element>) throws -> T
    )   rethrows -> T {
        
        let appendix: Bit = self.appendix

        return try self.body.withUnsafeBufferPointer {
            try action(DataInt(DataInt.Body($0)![unchecked: range], repeating: appendix))
        }
    }
}
