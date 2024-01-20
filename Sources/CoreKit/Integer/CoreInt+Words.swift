//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Words
//*============================================================================*

extension CoreInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: consuming UX) {
        self.init(Base(truncatingIfNeeded: UInt(bitPattern: source)))
    }
    
    @inlinable public func load(as type: UX.Type) -> UX {
        UX(bitPattern: UInt(truncatingIfNeeded: self.base))
    }
}
