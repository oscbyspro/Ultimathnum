//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit x Selection
//*============================================================================*

extension Bit {
    
    /// Some selection options for the bits in a binary integer.
    ///
    /// ```swift
    /// I64.min.count(0, option:  .ascending) // 63
    /// I64.min.count(1, option: .descending) // 01
    /// ```
    ///
    @frozen public enum Selection {
        case all
        case ascending
        case descending
    }
}
