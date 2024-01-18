//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Int x Words x Signed
//*============================================================================*

extension BitInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: UX) {
        self.init(bitPattern: source & 1 == 1)
    }
    
    @inlinable public init(load source: Pattern<some RandomAccessCollection<UX>>) {
        self.init(load: source.load(as: UX.self))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func load(as type: UX.Type) -> UX {
        UX(repeating: U1(bitPattern: self.bitPattern))
    }
}

//*============================================================================*
// MARK: * Bit Int x Words x Unsigned
//*============================================================================*

extension BitInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: UX) {
        self.init(bitPattern: source & 1 == 1)
    }
    
    @inlinable public init(load source: Pattern<some RandomAccessCollection<UX>>) {
        self.init(load: source.load(as: UX.self))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
        
    @inlinable public func load(as type: UX.Type) -> UX {
        self.bitPattern ? 1 as UX : 0 as UX
    }
}
