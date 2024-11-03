//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Utilities x Bit
//*============================================================================*

extension Bit {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
        
    public static let all: [Self] = [zero, one]
    
    public static let nonpositives: [Self] = [zero]
}

//*============================================================================*
// MARK: * Utilities x Bit x Fallible
//*============================================================================*

extension Fallible<Bit> {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    public static let all: [Self] = [
        Self(Bit.zero, error: false),
        Self(Bit.zero, error: true ),
        Self(Bit.one,  error: false),
        Self(Bit.one,  error: true ),
    ]
}

//*============================================================================*
// MARK: * Utilities x Bit x Optional
//*============================================================================*

extension Optional<Bit> {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    public static let all: [Self] = [
        Self.none,
        Self.some(Bit.zero),
        Self.some(Bit.one ),
    ]
}
