//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Utilities x Comparison
//*============================================================================*

/// Indicates whether raw bytes of `lhs` and `rhs` are equal.
@inlinable public func memeq(_ lhs: some Any, _ rhs: some Any) -> Bool {
    Swift.withUnsafeBytes(of: lhs) { lhs in
        Swift.withUnsafeBytes(of: rhs) { rhs in
            lhs.elementsEqual(rhs)
        }
    }
}
