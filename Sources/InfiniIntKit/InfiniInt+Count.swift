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
// MARK: * Infini Int x Count
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func count(_ bit: Bit) -> Count<IX> {
        self.withUnsafeBinaryIntegerElements {
            $0.count(bit)
        }
    }
    
    @inlinable public borrowing func ascending(_ bit: Bit) -> Count<IX> {
        self.withUnsafeBinaryIntegerElements {
            $0.ascending(bit)
        }
    }
    
    @inlinable public borrowing func descending(_ bit: Bit) -> Count<IX> {
        self.withUnsafeBinaryIntegerElements {
            $0.descending(bit)
        }
    }
}
