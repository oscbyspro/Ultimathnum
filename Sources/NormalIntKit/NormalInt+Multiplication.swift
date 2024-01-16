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
// MARK: * Normal Int x Multiplication
//*============================================================================*

extension NormalInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func squared() throws -> Self {
        self.storage.withUnsafeBufferPointer{ words in
            Self.uninitialized(count: words.count * 2) {
                SUISS.initialize(&$0, toSquareProductOf: words)
            }
        }
    }
    
    @inlinable public consuming func times(_ multiplier: Self) throws -> Self {
        self.storage.withUnsafeBufferPointer { lhs in
            multiplier.storage.withUnsafeBufferPointer { rhs in
                Self.uninitialized(count: lhs.count + rhs.count) {
                    SUISS.initialize(&$0, to: lhs, times: rhs)
                }
            }
        }
    }
}
