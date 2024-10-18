//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Utilities x Reduce
//*============================================================================*

@inlinable public func reduce<T>(
    _ transform: (consuming T) throws -> T,
    _ rhs: T
)   rethrows -> T {
    try transform(rhs)
}

@inlinable public func reduce<T>(
    _ lhs: consuming T,
    _ transform: (consuming T, borrowing T) throws -> T,
    _ rhs: borrowing T
)   rethrows -> T {
    try transform(lhs, rhs)
}

@inlinable public func reduce<T>(
    _ lhs: consuming T,
    _ transform: (inout T, borrowing T) throws -> Void,
    _ rhs: borrowing T
)   rethrows -> T {
    try transform(&lhs, rhs)
    return lhs
}
