//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Bitwise
//*============================================================================*

extension BinaryInteger {
 
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance that is equal to `1` or `0`.
    @_disfavoredOverload // disfavor: 1-bit integer literal demotion
    @inline(__always) // performance: please fold it like a paper airplane
    @inlinable public init(_ bit: Bit) {
        self = Bool(bit) ?  1 : 0
    }
    
    /// Creates a new instance from the repeating bit pattern of `bit` that fits.
    @inline(__always) // performance: please fold it like a paper airplane
    @inlinable public init(repeating bit: Bit) {
        self = Bool(bit) ? ~0 : 0
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the 2's complement of this value.
    ///
    /// - Note: The 2's complement is defined as `self.toggled() &+ 1`.
    ///
    /// ### Well-behaved arbitrary unsigned integers
    ///
    /// The notion of infinity keeps arbitrary unsigned integers well-behaved.
    ///
    /// ```swift
    /// UXL(repeating: 0) //  x
    /// UXL(repeating: 1) // ~x
    /// UXL(repeating: 0) // ~x &+ 1 == y
    /// UXL(repeating: 1) // ~y
    /// UXL(repeating: 0) // ~y &+ 1 == x
    /// ```
    ///
    /// ```swift
    /// UXL([~0] as [UX], repeating: 0) //  x
    /// UXL([ 0] as [UX], repeating: 1) // ~x
    /// UXL([ 1] as [UX], repeating: 1) // ~x &+ 1 == y
    /// UXL([~1] as [UX], repeating: 0) // ~y
    /// UXL([~0] as [UX], repeating: 0) // ~y &+ 1 == x
    /// ```
    ///
    /// ```swift
    /// UXL([ 0    ] as [UX], repeating: 1) //  x
    /// UXL([~0    ] as [UX], repeating: 0) // ~x
    /// UXL([ 0,  1] as [UX], repeating: 0) // ~x &+ 1 == y
    /// UXL([~0, ~1] as [UX], repeating: 1) // ~y
    /// UXL([ 0    ] as [UX], repeating: 1) // ~y &+ 1 == x
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
    
    /// Returns the least significant bit in its `body`, or the `appendix`.
    ///
    /// - Returns: The bit at index: `0`.
    ///
    /// - Note: A systems integer's `body` is never empty.
    ///
    /// - Note: It is `0` when `self` is even, and `1` when `self` is odd.
    ///
    @inlinable public var lsb: Bit {
        Bit(Element(load: self) & Element.lsb != Element.zero)
    }
    
    /// Returns the most significant bit in its `body`, or the `appendix`.
    ///
    /// - Returns: The bit at index: `log2(Magnitude.max + 1) - 1`.
    ///
    /// - Note: A systems integer's `body` is never empty.
    ///
    /// - Note: A signed integer's `msb` and `appendix` are always equal.
    ///
    @inlinable public var msb: Bit {
        if !Self.size.isInfinite {
            return Bit(self.withUnsafeBinaryIntegerBody({ $0.last! >= Element.Magnitude.msb }))
        }   else {
            return self.appendix
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Bitwise x Systems
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns an instance with this value on an `endianness` system.
    ///
    /// - Note: This operation is equivalent to a conditional byte swap.
    ///
    @inlinable public consuming func endianness(_ endianness: Order) -> Self {
        if  endianness == Order.endianess {
            return self
            
        }   else {
            return self.reversed(U8.self)
        }
    }
}
