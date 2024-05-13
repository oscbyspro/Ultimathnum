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
    // NOTE: The compiler wants to convert integer literals to Bit in init(_:).
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - Note: This method is **important** for performance.
    ///
    @_disfavoredOverload @inlinable public init(_ bit: Bit) {
        self = Bool(bit) ?  1 : 0
    }
    
    @inlinable public init(repeating bit: Bit) {
        self = Bool(bit) ? ~0 : 0
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func complement() -> Self {
        self.complement(true).value
    }
    
    @inlinable public consuming func magnitude() -> Magnitude {
        Magnitude(raw: self.isNegative ? self.complement() : self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The least significant bit in its bit pattern.
    ///
    /// It returns `0` when this value is even, and `1` when it is odd.
    ///
    /// - Note: This accessor tests only the least significant element.
    ///
    @inlinable public var leastSignificantBit: Bit {
        Bit(self.load(as: Element.self) & Element.lsb != 0)
    }
}

//*============================================================================*
// MARK: * Binary Integer x Bitwise x Systems
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns an instance with this value on an `endianess` system.
    ///
    /// - Note: This operation is equivalent to a conditional byte swap.
    ///
    @inlinable public consuming func endianness(_ endianess: some Endianness) -> Self {
        if  endianess.matches(endianness: .system) {
            return self
        }   else {
            return self.reversed(U8.self)
        }
    }
}
