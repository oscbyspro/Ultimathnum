//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit

//*============================================================================*
// MARK: * Stdlib Int x Geometry
//*============================================================================*

extension StdlibInt {
    
    /// Returns the integer square root of `self`.
    ///
    /// ```swift
    /// I8( 4).isqrt() // 2
    /// I8( 3).isqrt() // 1
    /// I8( 2).isqrt() // 1
    /// I8( 1).isqrt() // 1
    /// I8( 0).isqrt() // 0
    /// I8(-1).isqrt() // nil
    /// I8(-2).isqrt() // nil
    /// I8(-3).isqrt() // nil
    /// I8(-4).isqrt() // nil
    /// ```
    ///
    /// - Note: `Natural<T>` guarantees nonoptional results.
    ///
    /// ### Algorithm
    ///
    /// - Seealso: https://en.wikipedia.org/wiki/newton's_method
    ///
    /// - Seealso: https://en.wikipedia.org/wiki/integer_square_root
    ///
    @inlinable public func isqrt() -> Optional<Self> {
        self.base.isqrt().map(Self.init)
    }
}
