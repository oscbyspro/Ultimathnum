//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Minimi Int x Token x Signed
//*============================================================================*

extension MinimiInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(load source: T) where T: BitCastable<UX.BitPattern> {
        self.init(bitPattern: UX(bitPattern: source) & 1 == 1)
    }
        
    @inlinable public func load<T>(as type: T.Type) -> T where T: BitCastable<UX.BitPattern> {
        T(bitPattern: self.bitPattern ? 1 as UX : 0 as UX)
    }
}

//*============================================================================*
// MARK: * Minimi Int x Token x Unsigned
//*============================================================================*

extension MinimiInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(load source: T) where T: BitCastable<UX.BitPattern> {
        self.init(bitPattern: UX(bitPattern: source) & 1 == 1)
    }
        
    @inlinable public func load<T>(as type: T.Type) -> T where T: BitCastable<UX.BitPattern> {
        T(bitPattern: self.bitPattern ? 1 as UX : 0 as UX)
    }
}
