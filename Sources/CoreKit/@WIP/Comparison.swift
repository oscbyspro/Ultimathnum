//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Comparison
//*============================================================================*

@inlinable public func compare<LHS, RHS>(_ lhs: LHS, to rhs: RHS) -> Signum where LHS: BinaryInteger, RHS: BinaryInteger {
    lhs.withUnsafeBinaryIntegerData { lhs in
        rhs.withUnsafeBinaryIntegerData { rhs in
            MemoryInt.compare(
                lhs: lhs, lhsIsSigned: LHS.isSigned,
                rhs: rhs, rhsIsSigned: RHS.isSigned
            )
        }
    }
}
