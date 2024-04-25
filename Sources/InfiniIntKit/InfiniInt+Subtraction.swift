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
// MARK: * Infini Int x Subtraction
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func minus(_ other: borrowing Self) -> Fallible<Self> {
        var overflow = false
        
        self.storage.resize(minCount: other.storage.count)
        self.storage.withUnsafeMutableBinaryIntegerBody { lhs in
            other.withUnsafeBinaryIntegerElements { rhs in
                var lhs  = consume lhs
                overflow = lhs[{ $0.decrementSubSequence(by: rhs.body,plus: overflow) }]
                overflow = lhs.decrement(by: overflow, plusOnRepeat: Bool(rhs.appendix))
            }
        }
                
        var last = Element(repeating: self.appendix)
        overflow = last[{ $0.minus(Element(repeating: other.appendix),plus: overflow) }]
        self.storage.appendix = Element.Signitude(bitPattern: last).appendix
        self.storage.normalize(appending: Element.Magnitude(bitPattern: last))
        
        return self.combine(overflow)
    }
}
