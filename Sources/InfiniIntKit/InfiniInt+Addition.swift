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
// MARK: * Infini Int x Addition
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ other: borrowing Self) -> Fallible<Self> {
        var overflow = false
                
        self.storage.resize(minCount: other.storage.count)
        self.storage.withUnsafeMutableBinaryIntegerBody { lhs in
            other.withUnsafeBinaryIntegerElements { rhs in
                var lhs  = consume lhs
                overflow = lhs[{ $0.incrementSubSequence(by: rhs.body,  plus: overflow) }]
                overflow = lhs.increment(repeating: Bool(rhs.appendix), plus: overflow)
            }
        }
        
        var last = Element(repeating: self.appendix)
        overflow = last[{ $0.plus(Element(repeating: other.appendix), plus: overflow) }]
        self.storage.appendix = Element.Signitude(raw: last).appendix
        self.storage.normalize(appending: Element.Magnitude(raw: last))
        
        return self.combine(overflow)
    }
}
