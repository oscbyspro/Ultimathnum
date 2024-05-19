//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Black Hole
//*============================================================================*

/// Opaquely uses the argument.
///
/// Optimizer folklore has it that its secrets are revealed only to the supreme architect.
///
@_optimize(none) public func blackHole<T>(_ x: T) {  }

/// Opaquely returns the argument.
///
/// Optimizer folklore has it that its secrets are revealed only to the supreme architect.
///
@_optimize(none) public func blackHoleIdentity<T>(_ x: T) -> T { x }

/// Opaquely mutates the argument.
///
/// Optimizer folklore has it that its secrets are revealed only to the supreme architect.
///
@_optimize(none) public func blackHoleInoutIdentity<T>(_ x: inout T) { }
