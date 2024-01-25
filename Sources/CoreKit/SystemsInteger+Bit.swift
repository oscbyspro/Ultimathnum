//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
        Self(bitPattern: 1 as Magnitude &<< (bitWidth &- 1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        Bit(bitPattern: self.isLessThanZero)
    }
}
