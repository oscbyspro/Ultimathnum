//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Metadata x Signed
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
 
    @inlinable public static var mode: Signed {
        Signed()
    }
}

//*============================================================================*
// MARK: * Binary Integer x Metadata x Unsigned
//*============================================================================*

extension UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
 
    @inlinable public static var mode: Unsigned {
        Unsigned()
    }
}
