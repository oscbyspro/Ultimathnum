//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Normal Int
//*============================================================================*

/// A signed, auto-normalized, arbitrary precision integer.
@frozen public struct NormalInt {
    
    //*========================================================================*
    // MARK: * Magnitude
    //*========================================================================*
    
    /// An unsigned, auto-normalized, arbitrary precision integer.
    @frozen public struct Magnitude: UnsignedInteger & BinaryInteger {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var storage: NormalInt.Storage
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(storage: consuming NormalInt.Storage) {
            self.storage = storage
        }
    }
}
