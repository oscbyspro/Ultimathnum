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
    
    @inlinable public borrowing func size() -> Magnitude {
        Self.size
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The number of bits in `self` that match the `selection`.
    ///
    /// ```swift
    /// I8(-2).count(.appendix) // 7
    /// I8(-1).count(.appendix) // 8
    /// I8( 0).count(.appendix) // 8
    /// I8( 1).count(.appendix) // 7
    /// ```
    ///
    @inlinable public func count(_ selection: Bit.Appendix) -> Magnitude {
        self.count(.descending(self.appendix)) // await borrowing fix
    }
    
    /// The number of bits in `self` that match the `selection`.
    ///
    /// ```swift
    /// I8(-2).count(.nonappendix) // 1
    /// I8(-1).count(.nonappendix) // 0
    /// I8( 0).count(.nonappendix) // 0
    /// I8( 1).count(.nonappendix) // 1
    /// ```
    ///
    @inlinable borrowing public func count(_ selection: Bit.Nonappendix) -> Magnitude {
        self.size().minus(self.count(.appendix)).unchecked("inverse bit count")
    }
    
    /// The number of bits in `self` that match the `selection`.
    ///
    /// ```swift
    /// I8(11).count(.nonascending(0)) // 8
    /// I8(11).count(.nonascending(1)) // 6
    /// I8(22).count(.nonascending(0)) // 7
    /// I8(22).count(.nonascending(1)) // 8
    /// ```
    ///
    @inlinable borrowing public func count(_ selection: Bit.Nonascending) -> Magnitude {
        self.size().minus(self.count( .ascending(selection.bit))).unchecked("inverse bit count")
    }
    
    /// The number of bits in `self` that match the `selection`.
    ///
    /// ```swift
    /// I8(11).count(.nondescending(0)) // 4
    /// I8(11).count(.nondescending(1)) // 8
    /// I8(22).count(.nondescending(0)) // 5
    /// I8(22).count(.nondescending(1)) // 8
    /// ```
    ///
    @inlinable borrowing public func count(_ selection: Bit.Nondescending) -> Magnitude {
        self.size().minus(self.count(.descending(selection.bit))).unchecked("inverse bit count")
    }
}
