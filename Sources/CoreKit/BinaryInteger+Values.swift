//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Values
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// A value with its least significant bit set to `1`
    ///
    /// - Note: This value equals `1` for all valid binary integer types.
    ///
    /// - Note: A 1-bit signed integer type cannot represent `1`.
    ///
    @inlinable public static var lsb: Self {
        Self(raw: 1 as Magnitude)
    }
    
    /// The additive identity element: `zero`.
    @inline(__always) // performance: please fold it like a paper airplane
    @inlinable public static var zero: Self {
        Self()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns the additive identity element: `zero`.
    @inline(__always) // performance: please fold it like a paper airplane
    @inlinable public init() {
        self = 0
    }
}

//*============================================================================*
// MARK: * Binary Integer x Values x Edgy
//*============================================================================*

extension EdgyInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var min: Self {
        if  isSigned {
            return Self(raw: Magnitude.lsb.up(Shift(unchecked: size.decremented().unchecked())))
        }   else {
            return Self()
        }
    }
    
    @inlinable public static var max: Self {
        min.toggled()
    }
}

//*============================================================================*
// MARK: * Binary Integer x Values x Systems
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// A value with its most significant bit set to `1`
    @inlinable public static var msb: Self {
        Self(raw: Magnitude.lsb.up(Shift(unchecked: size.decremented().unchecked())))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Machine Word
//=----------------------------------------------------------------------------=

extension SystemsInteger where BitPattern == UX.BitPattern {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns the size of the given type as a machine word.
    ///
    /// - Note: A finite integer size must fit in this type per protocol.
    ///
    /// - Important: A binary integer's size is measured in bits.
    ///
    @inlinable public init<Other>(size type: Other.Type) where Other: SystemsInteger {
        self.init(load: Other.size)
    }
    
    /// Returns the size of the given type as a machine word, if possible.
    ///
    /// - Note: A finite integer size must fit in this type per protocol.
    ///
    /// - Important: A binary integer's size is measured in bits.
    ///
    @inlinable public init?<Other>(size type: Other.Type) where Other: BinaryInteger {
        if  Other.size.isInfinite {
            return nil
        }   else {
            self.init(load: Other.size)
        }
    }
}
