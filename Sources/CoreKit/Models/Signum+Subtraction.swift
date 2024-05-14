//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Signum x Subtraction
//*============================================================================*

extension Signum {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> Self {
        switch self {
        case .less: .more
        case .same: .same
        case .more: .less
        }
    }
    
    @inlinable public static prefix func -(instance: consuming Self) -> Self {
        instance.negated()
    }
}
