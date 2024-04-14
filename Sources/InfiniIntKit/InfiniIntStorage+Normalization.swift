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
// MARK: * Infini Int Storage x Normalization
//*============================================================================*

extension InfiniIntStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable var isNormal: Bool {
        let element = Element.Magnitude(repeating: self.appendix)
        return self.body.last != element
    }
    
    @inlinable mutating func normalize() {
        let element = Element.Magnitude(repeating: self.appendix)
        while self.body.last == element {
            ((self.body)).removeLast()
        }
    }
}
