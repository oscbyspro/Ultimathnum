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

@inlinable public func reduce<A, B>(
    _ transform: (consuming A) throws -> B,
    _ rhs: A
)   rethrows -> B {
    try transform(rhs)
}

@inlinable public func reduce<A, B>(
    _ lhs: A,
    _ transform: (consuming A) throws -> B
)   rethrows -> B {
    try transform(lhs)
}

@inlinable public func reduce<A, B, C>(
    _ lhs: consuming A,
    _ transform: (consuming A, borrowing B) throws -> C,
    _ rhs: borrowing B
)   rethrows -> C {
    try transform(lhs, rhs)
}

//=----------------------------------------------------------------------------=
// MARK: + Inout
//=----------------------------------------------------------------------------=

@inlinable public func reduce<A>(
    _ lhs: consuming A,
    _ transform: (inout A) throws -> Void
)   rethrows -> A {
    try transform(&lhs)
    return lhs
}

@inlinable public func reduce<A, B>(
    _ lhs: consuming A,
    _ transform: (inout A, borrowing B) throws -> Void,
    _ rhs: borrowing B
)   rethrows -> A {
    try transform(&lhs, rhs)
    return lhs
}
