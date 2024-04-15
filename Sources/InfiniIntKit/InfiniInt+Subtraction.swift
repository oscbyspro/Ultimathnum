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
                for index in lhs.indices {
                    overflow = lhs[unchecked: index].capture {
                        $0.minus(rhs[UX(bitPattern: index)], carrying: overflow)
                    }
                }
            }
        }
                
        var last = Element(repeating: self.appendix)
        (last, overflow) = last.minus(Element(repeating: other.appendix), carrying: overflow).components

        self.storage.appendix = Element.Signitude(bitPattern: last).appendix
        self.storage.normalize(appending: Element.Magnitude(bitPattern: last))

        return self.combine(overflow)
    }
    
    @inlinable public consuming func minus(_ other: consuming Element) -> Fallible<Self> {
        fatalError("TODO")
    }
}
