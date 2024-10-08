//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Sign x Text
//*============================================================================*

extension Sign {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A textual representation of `self`.
    ///
    /// ```swift
    /// Sign.plus .description // "+" (ASCII: 43)
    /// Sign.minus.description // "-" (ASCII: 45)
    /// ```
    ///
    @inlinable public var description: String {
        switch self {
        case  .plus: "+"
        case .minus: "-"
        }
    }
}
