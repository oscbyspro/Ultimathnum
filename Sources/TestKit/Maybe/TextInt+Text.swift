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
// MARK: * Text Int x Text
//*============================================================================*

extension TextInt: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        self.numerals.description
    }
}

//*============================================================================*
// MARK: * Text Int x Text x Numerals
//*============================================================================*

extension TextInt.Numerals: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        "\(self.radix)x\(self.letters.start)"
    }
}
