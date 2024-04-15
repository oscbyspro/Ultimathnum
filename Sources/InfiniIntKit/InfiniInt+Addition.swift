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
                for index in rhs.body.indices {
                    overflow = lhs[unchecked: index].capture {
                        $0.plus(rhs.body[unchecked: index], and: overflow)
                    }
                }
                
                if  overflow != Bool(rhs.appendix) {
                    let predicate = overflow
                    let increment = overflow ? 1 : ~0 as Element.Magnitude
                    
                    var index = rhs.body.count
                    while index < lhs.count, overflow == predicate {
                        overflow = lhs[unchecked: index].capture {
                            $0.plus(increment)
                        }
                        
                        index = index.incremented().assert()
                    }
                }
            }
        }
                
        var last = Element(repeating: self.appendix)
        (last, overflow) = last.plus(Element(repeating: other.appendix), and: overflow).components

        self.storage.appendix = Element.Signitude(bitPattern: last).appendix
        self.storage.normalize(appending: Element.Magnitude(bitPattern: last))

        return self.combine(overflow)
    }
    
    @inlinable public consuming func plus(_ other: consuming Element) -> Fallible<Self> {
        //=--------------------------------------=
        // TODO: improve it
        //=--------------------------------------=
        return self.plus(Self(load: other))
    }
}
