//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreIop
import CoreKit
import InfiniIntKit

//*============================================================================*
// MARK: * Infini Int x Count x Stdlib
//*============================================================================*

extension InfiniInt.Stdlib {
    
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
                Swift.assert($0.isNormal, "InfiniInt")
                
                if  $0.body.isEmpty {
                    return Swift.Int(IX($0.appendix.toggled()))
                }   else {
                    return Swift.Int($0.body.ascending(Bit.zero).natural().unchecked())
                }
            }
        }
    }
}
