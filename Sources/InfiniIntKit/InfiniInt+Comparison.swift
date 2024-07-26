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
// MARK: * Infini Int x Comparison
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.compared(to: rhs) == Signum.same
    }
    
    @inlinable public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.compared(to: rhs) == Signum.less
    }
    
    @inlinable public borrowing func compared(to other: borrowing Self) -> Signum {
        self.withUnsafeBinaryIntegerElements { lhs in
            other.withUnsafeBinaryIntegerElements { rhs in
                DataInt.compare(
                    lhs: lhs, mode: Self.mode,
                    rhs: rhs, mode: Self.mode
                )
            }
        }
    }
    
    @inlinable public borrowing func hash(into hasher: inout Hasher) {
        self.withUnsafeBinaryIntegerElements {
            hasher.combine(bytes: $0.body.bytes())
            hasher.combine($0.appendix)
        }
    }
}
