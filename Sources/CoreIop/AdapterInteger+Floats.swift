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
// MARK: * Adapter Integer x Floats
//*============================================================================*

extension AdapterInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some Swift.BinaryFloatingPoint) {
        self.init(Base(source))
    }
    
    @inlinable public init?(exactly source: some Swift.BinaryFloatingPoint) {
        guard let base = Base.exactly(source) else { return nil }
        self.init(base)
    }
}
