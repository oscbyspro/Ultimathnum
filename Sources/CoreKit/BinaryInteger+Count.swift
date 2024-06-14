//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Count
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The number of bits that fit in the `body` of this binary integer type.
    ///
    /// ```
    /// ┌──────┬───────────────────┐
    /// │ type │ size              │
    /// ├──────┼───────────────────┤
    /// │ I64  │ 64                │
    /// │ IXL  │ UXL(repeating: 1) │
    /// └──────┴───────────────────┘
    /// ```
    ///
    /// - Note: `log2(UXL.max + 1)` gets promoted to `UXL.max`.
    ///
    /// - Invariant: `Self.size == self.count(0) + self.count(1)`.
    ///
    @inlinable public borrowing func size() -> Magnitude {
        Self.size
    }
    
    /// The inverse ascending `bit` count in `self`.
    ///
    /// ```swift
    /// I8(11).nonascending(0) // 8
    /// I8(11).nonascending(1) // 6
    /// I8(22).nonascending(0) // 7
    /// I8(22).nonascending(1) // 8
    /// ```
    ///
    @inlinable borrowing public func nonascending(_ bit: Bit) -> Magnitude {
        self.size().minus(self.ascending(bit)).unchecked("inverse bit count")
    }
    
    /// The inverse descending `bit` count in `self`.
    ///
    /// ```swift
    /// I8(11).nondescending(0) // 4
    /// I8(11).nondescending(1) // 8
    /// I8(22).nondescending(0) // 5
    /// I8(22).nondescending(1) // 8
    /// ```
    ///
    @inlinable borrowing public func nondescending(_ bit: Bit) -> Magnitude {
        self.size().minus(self.descending(bit)).unchecked("inverse bit count")
    }
}
