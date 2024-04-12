//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Systems Integer x Bit
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var lsb: Self {
        Self(bitPattern: 1 as Magnitude)
    }
    
    @inlinable public static var msb: Self {
        Self(bitPattern: 1 as Magnitude &<< (size &- 1))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Machine Word
//=----------------------------------------------------------------------------=

extension SystemsInteger where BitPattern == UX.BitPattern {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns the bit width of the given type as an un/signed machine word.
    ///
    /// - Note: A systems integer's bit width must fit in this type per definition.
    ///
    @inlinable public init<T>(size type: T.Type) where T: SystemsInteger {
        self = T.size.load(as: Self.self)
    }
}
