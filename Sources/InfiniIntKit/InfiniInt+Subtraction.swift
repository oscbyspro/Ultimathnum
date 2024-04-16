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
        var carry = false
        
        self.storage.resize(minCount: other.storage.count)
        self.storage.withUnsafeMutableBinaryIntegerBody { lhs in
            other.withUnsafeBinaryIntegerElements { rhs in
                for index in rhs.body.indices {
                    carry = lhs[unchecked: index][{ $0.minus(rhs.body[unchecked: index], plus: carry) }]
                }
                
                if  carry != Bool(rhs.appendix) {
                    let predicate = carry
                    let increment = carry ? 1 : ~0 as Element.Magnitude
                    
                    var index = rhs.body.count
                    while index < lhs.count, carry == predicate {
                        carry = lhs[unchecked: index][{ $0.minus(increment) }]
                        index = index.incremented().assert()
                    }
                }
            }
        }
                
        var last = Element(repeating: self.appendix)
        (last, carry) = last.minus(Element(repeating: other.appendix), plus: carry).components
        //=--------------------------------------=
        self.storage.appendix = Element.Signitude(bitPattern: last).appendix
        self.storage.normalize(appending: Element.Magnitude(bitPattern: last))
        //=--------------------------------------=
        return self.combine(carry)
    }
    
    @inlinable public consuming func minus(_ other: consuming Element) -> Fallible<Self> {
        //=--------------------------------------=
        // TODO: improve it
        //=--------------------------------------=
        return self.minus(Self(load: other))
    }
}
