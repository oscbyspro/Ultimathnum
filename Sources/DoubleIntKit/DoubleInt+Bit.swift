//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Double Int x Bit
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func count(_ bit: Bit, option: Bit.Selection) -> Magnitude {
        var count: Magnitude
        
        switch option {
        case .all:
            
            brr: do {
                count = /*-*/   Magnitude(low: self.low .count(bit, option: option))
                count = count + Magnitude(low: self.high.count(bit, option: option))
            }
        
        case .ascending:
                        
            brr: do {
                count = /*-*/   Magnitude(low: self.low .count(bit, option: option))
            };  if count.low == Low.bitWidth {
                count = count + Magnitude(low: self.high.count(bit, option: option))
            }
            
        case .descending:
            
            brr: do {
                count = /*-*/   Magnitude(low: self.high.count(bit, option: option))
            };  if count.low == High.bitWidth {
                count = count + Magnitude(low: self.low .count(bit, option: option))
            }
            
        }
        
        return count as Magnitude
    }
}
