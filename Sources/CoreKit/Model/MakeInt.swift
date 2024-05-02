//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Make Int
//*============================================================================*

@frozen public struct MakeInt: ExpressibleByIntegerLiteral, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var mode: Signed {
        Signed()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Swift.StaticBigInt
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Swift.StaticBigInt) {
        self.base = base
    }
    
    @inlinable public init(integerLiteral: Swift.StaticBigInt) {
        self.init(integerLiteral)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The number of bits needed to represent `self`.
    ///
    /// ```
    /// ┌──────┬──────────── → ────────┐
    /// │ self │ bit pattern │ entropy │
    /// ├──────┼──────────── → ────────┤
    /// │ -4   │ 00........1 │ 3       │
    /// │ -3   │ 10........1 │ 3       │
    /// │ -2   │ 0.........1 │ 2       │
    /// │ -1   │ ..........1 │ 1       │
    /// │  0   │ ..........0 │ 1       │
    /// │  1   │ 1.........0 │ 2       │
    /// │  2   │ 01........0 │ 3       │
    /// │  3   │ 11........0 │ 3       │
    /// └──────┴──────────── → ────────┘
    /// ```
    ///
    @inlinable public var entropy: UX {
        UX(IX(self.base.bitWidth))
    }
    
    /// The bit that extends the body of this integer.
    @inlinable public var appendix: Bit {
        Bit(self.base.signum() < 0)
    }
    
    /// A three-way comparison against zero.
    @inlinable public func signum() -> Signum {
        IX(self.base.signum()).signum()
    }
}
