//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Infini Int x Subtraction x Signed
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() throws -> Self {
        fatalError("TODO")
    }
    
    @inlinable public consuming func minus(_ increment: borrowing Self) throws -> Self {
        fatalError("TODO")
    }
}

//*============================================================================*
// MARK: * Infini Int x Subtraction x Unsigned
//*============================================================================*

extension InfiniInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() throws -> Self {
        fatalError("TODO")
    }
    
    @inlinable public consuming func minus(_ increment: borrowing Self) throws -> Self {
        fatalError("TODO")
    }
}
