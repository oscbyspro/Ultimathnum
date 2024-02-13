//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Bit
//*============================================================================*

extension BinaryInteger {
 
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - Note: This method is **important** for performance.
    ///
    @inlinable public init(_ bit: Bit) {
        self = Bool(bitPattern: bit) ?  1 : 0
    }
    
    @inlinable public init(repeating bit: Bit) {
        self = Bool(bitPattern: bit) ? ~0 : 0
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
        Bit(bitPattern: self.load(as: Element.self) & Element.lsb != 0)
    }
}
