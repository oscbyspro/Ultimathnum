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
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func normalize() {
        let appendix = Element(repeating: self.appendix)
        while self.body.last == appendix {
            ((self.body)).removeLast()
        }
    }
    
    @inlinable mutating func normalize(appending element: Element) {
        let appendix = Element(repeating: self.appendix)
        if  element != appendix {
            self.body.append(element)
        }   else {
            self.normalize()
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable var isNormal: Bool {
        let appendix = Element(repeating: self.appendix)
        return self.body.last != appendix
    }
}
