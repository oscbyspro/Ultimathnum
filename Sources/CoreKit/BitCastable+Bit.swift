//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Castable x Bit
//*============================================================================*

extension BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern source: consuming some BitCastable<BitPattern>) {
        self.init(bitPattern: source.bitPattern)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Bit Pattern is Self
//=----------------------------------------------------------------------------=

extension BitCastable where BitPattern == Self {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming BitPattern) {
        self = bitPattern
    }
    
    @inlinable public var bitPattern: BitPattern {
        consuming get { consume self }
    }
}
