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
// MARK: * Normal Int x Complement
//*============================================================================*

extension NormalInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformatinos
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func irreversibleOnesComplement() -> Self {
        self.storage.withUnsafeMutableBufferPointer {
            SBISS.formOnesComplement(&$0)
        }
        
        self.storage.normalize()
        return consume self as Self
    }
    
    @inlinable public consuming func irreversibleTwosComplement() -> Self {
        self.storage.withUnsafeMutableBufferPointer {
            SBISS.formTwosComplement(&$0)
        }
        
        self.storage.normalize()
        return consume self as Self
    }
}
