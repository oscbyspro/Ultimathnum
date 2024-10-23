//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Complement
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the 2's complement of this value.
    ///
    /// ### Complements
    ///
    /// - Note: The 1's complement is defined as `self.toggled()`.
    ///
    /// - Note: The 2's complement is defined as `self.toggled() &+ 1`.
    ///
    /// ### Well-behaved arbitrary unsigned integers
    ///
    /// The notion of infinity keeps arbitrary unsigned integers well-behaved.
    ///
    /// ```swift
    /// UXL(repeating: Bit.zero) //  a
    /// UXL(repeating: Bit.one ) // ~a
    /// UXL(repeating: Bit.zero) // ~a &+ 1 == b
    /// UXL(repeating: Bit.one ) // ~b
    /// UXL(repeating: Bit.zero) // ~b &+ 1 == a
    /// ```
    ///
    /// ```swift
    /// UXL([~0] as [UX], repeating: Bit.zero) //  a
    /// UXL([ 0] as [UX], repeating: Bit.one ) // ~a
    /// UXL([ 1] as [UX], repeating: Bit.one ) // ~a &+ 1 == b
    /// UXL([~1] as [UX], repeating: Bit.zero) // ~b
    /// UXL([~0] as [UX], repeating: Bit.zero) // ~b &+ 1 == a
    /// ```
    ///
    /// ```swift
    /// UXL([ 0    ] as [UX], repeating: Bit.one ) //  a
    /// UXL([~0    ] as [UX], repeating: Bit.zero) // ~a
    /// UXL([ 0,  1] as [UX], repeating: Bit.zero) // ~a &+ 1 == b
    /// UXL([~0, ~1] as [UX], repeating: Bit.one ) // ~b
    /// UXL([ 0    ] as [UX], repeating: Bit.one ) // ~b &+ 1 == a
    /// ```
    ///
    @inlinable public consuming func complement() -> Self {
        self.complement(true).value
    }
    
    /// Returns the unsigned magnitude of this value.
    ///
    /// - Note: This is equivalent to a conditional 2's complement bit cast.
    ///
    @inlinable public consuming func magnitude() -> Magnitude {
        Magnitude(raw: self.isNegative ? self.complement() : self)
    }
}
