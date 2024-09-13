//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Stdlib Int x Factorial
//*============================================================================*

extension StdlibInt {
    
    /// The `factorial` of `self` or `nil`.
    ///
    /// ```swift
    /// U8(0).factorial() // U8.exactly(   1)
    /// U8(1).factorial() // U8.exactly(   1)
    /// U8(2).factorial() // U8.exactly(   2)
    /// U8(3).factorial() // U8.exactly(   6)
    /// U8(4).factorial() // U8.exactly(  24)
    /// U8(5).factorial() // U8.exactly( 120)
    /// U8(6).factorial() // U8.exactly( 720)
    /// U8(7).factorial() // U8.exactly(5040)
    /// ```
    ///
    /// - Note: It returns `nil` if the operation is `lossy`.
    ///
    /// - Note: It returns `nil` if the operation is `undefined`.
    ///
    @inlinable public /*borrowing*/ func factorial() -> Optional<Self> {
        self.base.factorial().map(Self.init)
    }
}
