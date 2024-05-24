//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Castable + Bit Cast
//*============================================================================*

extension BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inline(__always) // performance: please fold it like a paper airplane
    @inlinable public init(raw source: consuming some BitCastable<BitPattern>) {
        self.init(raw: source.load(as: BitPattern.self))
    }
}
