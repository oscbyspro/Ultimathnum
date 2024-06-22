//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit

//*============================================================================*
// MARK: * Stdlib Int x Count
//*============================================================================*

extension StdlibInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var bitWidth: Int {
        borrowing get {
            Int(self.base.withUnsafeBinaryIntegerElements({ $0.entropy() }))
        }
    }
    
    @inlinable public var trailingZeroBitCount: Int {
        borrowing get {
            Int(self.base.withUnsafeBinaryIntegerElements({ $0.isZero ? 1 : $0.body.ascending(0) }))
        }
    }
}
