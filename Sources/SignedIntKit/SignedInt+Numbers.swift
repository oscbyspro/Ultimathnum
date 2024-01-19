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
// MARK: * Signed Int x Numbers
//*============================================================================*

extension SignedInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(words: consuming some RandomAccessCollection<UX>, isSigned: consuming Bool) throws {
        fatalError("TODO")
    }
}

//*============================================================================*
// MARK: * Signed Int x Numbers x Systems
//*============================================================================*

extension SignedInt where Magnitude: SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var min: Self {
        try! Self(sign: Sign.minus, magnitude: Magnitude.max)
    }
    
    @inlinable public static var max: Self {
        try! Self(sign: Sign.plus,  magnitude: Magnitude.max)
    }
}
