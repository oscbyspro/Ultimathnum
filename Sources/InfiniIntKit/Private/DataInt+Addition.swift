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
// MARK: * Data Int x Addtion
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func increment(
        repeating pattern: consuming Bool,
        plus bit: consuming Bool
    )   -> Bool {
        
        if  bit != pattern {
            let predicate = copy bit
            let increment = copy bit ? 1 : ~0 as Element
            
            while self.count > 0, copy bit == predicate {
                (self, bit) = self.incrementSubSequence(by: increment).components()
            }
        }
        
        return bit as Bool as Bool as Bool as Bool
    }
    
    @inlinable public consuming func incrementSubSequence(complementOf elements: Immutable) {
        var bit: Bool = true
        
        for index in elements.indices {
            let element: Element = elements[unchecked: index].toggled()
            (self[unchecked: index], bit) =
            (self[unchecked: index]).plus(element, plus: bit).components()
        }
    }
}
