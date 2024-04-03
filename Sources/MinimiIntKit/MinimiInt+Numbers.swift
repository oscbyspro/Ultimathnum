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
// MARK: * Minimi Int x Numbers
//*============================================================================*

extension MinimiInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(integerLiteral: Signedness.IntegerLiteralType) {
        if  Signedness(integerLiteral: integerLiteral) == 0 {
            self.base = 0
        }   else if Signedness(integerLiteral: integerLiteral) == (Self.isSigned ? -1 : 1) {
            self.base = 1
        }   else {
            fatalError(.overflow())
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public var complement: Self {
        self
    }
    
    @inlinable public var magnitude: Magnitude {
        Magnitude(bitPattern: self.bitPattern)
    }
}
