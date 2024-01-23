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
    
    @inlinable public init<T>(load source: T) where T: BitCastable<UX.BitPattern> {
        self.init(Base(truncatingIfNeeded: UInt(bitPattern: source)))
    }
        
    @inlinable public func load<T>(as type: T.Type) -> T where T: BitCastable<UX.BitPattern> {
        T(bitPattern: UInt(truncatingIfNeeded: self.base))
    }
}
