//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Int
//*============================================================================*

extension Int: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: IX) {
        self = source.base
    }
    
    @inlinable public init(raw source: consuming Magnitude) {
        self.init(bitPattern: source)
    }
    
    @inlinable public consuming func load(as type: Magnitude.Type) -> Magnitude {
        Magnitude(bitPattern: self)
    }
}

//*============================================================================*
// MARK: * Int x 8
//*============================================================================*

extension Int8: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: I8) {
        self = source.base
    }
    
    @inlinable public init(raw source: consuming Magnitude) {
        self.init(bitPattern: source)
    }
    
    @inlinable public consuming func load(as type: Magnitude.Type) -> Magnitude {
        Magnitude(bitPattern: self)
    }
}

//*============================================================================*
// MARK: * Int x 16
//*============================================================================*

extension Int16: BitCastable {
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: I16) {
        self = source.base
    }
    
    @inlinable public init(raw source: consuming Magnitude) {
        self.init(bitPattern: source)
    }
    
    @inlinable public consuming func load(as type: Magnitude.Type) -> Magnitude {
        Magnitude(bitPattern: self)
    }
}

//*============================================================================*
// MARK: * Int x 32
//*============================================================================*

extension Int32: BitCastable {
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: I32) {
        self = source.base
    }
    
    @inlinable public init(raw source: consuming Magnitude) {
        self.init(bitPattern: source)
    }
    
    @inlinable public consuming func load(as type: Magnitude.Type) -> Magnitude {
        Magnitude(bitPattern: self)
    }
}

//*============================================================================*
// MARK: * Int x 64
//*============================================================================*

extension Int64: BitCastable {
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: I64) {
        self = source.base
    }
    
    @inlinable public init(raw source: consuming Magnitude) {
        self.init(bitPattern: source)
    }
    
    @inlinable public consuming func load(as type: Magnitude.Type) -> Magnitude {
        Magnitude(bitPattern: self)
    }
}
