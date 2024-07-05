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
    
    @inlinable public var bitWidth: Swift.Int {
        borrowing get {
            self.base.withUnsafeBinaryIntegerElements {
                Swift.Int($0.entropy().natural().unchecked())
            }
        }
    }
    
    @inlinable public var trailingZeroBitCount: Swift.Int {
        borrowing get {
            self.base.withUnsafeBinaryIntegerElements {
                Swift.assert($0.isNormal, "IXL")
                
                if  $0.body.isEmpty {
                    return Swift.Int(IX($0.appendix.toggled()))
                }   else {
                    return Swift.Int($0.body.ascending(0).natural().unchecked())
                }
            }
        }
    }
}
