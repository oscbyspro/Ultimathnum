//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Utilities x Conditional
//*============================================================================*

@inlinable public func conditional<T>(
    debug:   @autoclosure () throws -> T,
    release: @autoclosure () throws -> T
)   rethrows -> T {
    #if DEBUG
    return try debug()
    #else
    return try release()
    #endif
}
