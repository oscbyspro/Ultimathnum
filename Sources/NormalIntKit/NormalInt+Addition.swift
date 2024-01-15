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
// MARK: * Normal Int x Addition
//*============================================================================*

extension NormalInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: Self) -> Self {
        if  increment != 0 {
            self.storage.resize(minCount: increment.storage.count)
            
            let overflow = self.storage.withUnsafeMutableBufferPointer { instance in
                increment.storage.withUnsafeBufferPointer { increment in
                    SUISS.increment(&instance, by: increment).overflow
                }
            }
            
            if  overflow {
                self.storage.append(1)
            }
        }
        
        Swift.assert(self.storage.isNormal)
        return consume self as Self as Self
    }    
}
