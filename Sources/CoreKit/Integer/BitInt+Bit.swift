//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Int x Bit x Signed
//*============================================================================*

extension BitInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public func count(_ bit: BitInt.Magnitude, option: BitInt.Selection) -> Magnitude {
        self.magnitude.count(bit, option: option)
    }
}

//*============================================================================*
// MARK: * Bit Int x Bit x Unsigned
//*============================================================================*

extension BitInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public func count(_ bit: BitInt.Magnitude, option: BitInt.Selection) -> Magnitude {
        if bit == 0 { ~self } else { self }
    }
}
