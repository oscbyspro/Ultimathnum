//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Castable
//*============================================================================*

public protocol BitCastable<BitPattern> {
    
    associatedtype BitPattern: BitCastable<BitPattern> & Sendable
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(raw: consuming BitPattern)
    
    @inlinable consuming func load(as type: BitPattern.Type) -> BitPattern
}

//=----------------------------------------------------------------------------=
// MARK: + where Bit Pattern is Self
//=----------------------------------------------------------------------------=

extension BitCastable where BitPattern == Self {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming BitPattern) {
        self = source
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        self
    }
}
