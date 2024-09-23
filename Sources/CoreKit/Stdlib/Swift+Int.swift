//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Swift x Int
//*============================================================================*

extension Int: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming Magnitude) {
        self.init(bitPattern: source)
    }
    
    @inlinable public consuming func load(as type: Magnitude.Type) -> Magnitude {
        Magnitude(bitPattern: self)
    }
}

//*============================================================================*
// MARK: * Swift x Int8
//*============================================================================*

extension Int8: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming Magnitude) {
        self.init(bitPattern: source)
    }
    
    @inlinable public consuming func load(as type: Magnitude.Type) -> Magnitude {
        Magnitude(bitPattern: self)
    }
}

//*============================================================================*
// MARK: * Swift x Int16
//*============================================================================*

extension Int16: BitCastable {
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming Magnitude) {
        self.init(bitPattern: source)
    }
    
    @inlinable public consuming func load(as type: Magnitude.Type) -> Magnitude {
        Magnitude(bitPattern: self)
    }
}

//*============================================================================*
// MARK: * Swift x Int32
//*============================================================================*

extension Int32: BitCastable {
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming Magnitude) {
        self.init(bitPattern: source)
    }
    
    @inlinable public consuming func load(as type: Magnitude.Type) -> Magnitude {
        Magnitude(bitPattern: self)
    }
}

//*============================================================================*
// MARK: * Swift x Int64
//*============================================================================*

extension Int64: BitCastable {
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming Magnitude) {
        self.init(bitPattern: source)
    }
    
    @inlinable public consuming func load(as type: Magnitude.Type) -> Magnitude {
        Magnitude(bitPattern: self)
    }
}
