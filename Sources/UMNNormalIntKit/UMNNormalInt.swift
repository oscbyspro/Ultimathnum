//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import UMNCoreKit

//*============================================================================*
// MARK: * UMN x Normal Int
//*============================================================================*

@frozen public struct UMNNormalInt<Element>: UnsignedInteger where Element: FixedWidthInteger & UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(storage: Storage) {
        self.storage = storage
    }
    
    //*========================================================================*
    // MARK: * Storage
    //*========================================================================*
    
    @frozen @usableFromInline enum Storage: Hashable {
        case element(Element)
        case array(ContiguousArray<Element>)
    }
}
