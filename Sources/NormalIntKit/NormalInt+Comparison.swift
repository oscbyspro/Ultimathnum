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
// MARK: * Normal Int x Comparison
//*============================================================================*

extension NormalInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) ==  0
    }
    
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == -1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func hash(into hasher: inout Hasher) {
        self.storage.withUnsafeBufferPointer {
            for element in $0 {
                hasher.combine(element)
            }
        }
    }
    
    @inlinable public borrowing func compared(to other: Self) -> Signum {
        self.storage.withUnsafeBufferPointer { lhs in
            other.storage.withUnsafeBufferPointer { rhs in
                let lhs = SuccinctInt(lhs, isSigned: Self.isSigned)
                let rhs = SuccinctInt(rhs, isSigned: Self.isSigned)
                return (lhs).compared(to:  rhs)
            }
        }
    }
}
