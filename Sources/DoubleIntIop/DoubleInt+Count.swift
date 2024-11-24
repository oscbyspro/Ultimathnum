//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit

//*============================================================================*
// MARK: * Double Int x Count x Stdlib
//*============================================================================*

extension DoubleInt.Stdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var trailingZeroBitCount: Int {
        Swift.Int(raw: self.base.ascending(Bit.zero))
    }
}

//*============================================================================*
// MARK: * Double Int x Count x Stdlib x Swift Fixed Width Integer
//*============================================================================*

extension DoubleInt.Stdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var nonzeroBitCount: Int {
        Swift.Int(raw: self.base.count(Bit.one))
    }
    
    @inlinable public var leadingZeroBitCount: Int {
        Swift.Int(raw: self.base.descending(Bit.zero))
    }
}
