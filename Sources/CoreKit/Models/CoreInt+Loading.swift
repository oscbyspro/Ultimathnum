//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Loading
//*============================================================================*

extension CoreInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: DataInt<Element.Magnitude>) {
        self.init(raw: source.first)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Self is not IX or UX
//=----------------------------------------------------------------------------=

extension CoreIntegerWhereIsNotToken {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: Element.Signitude) {
        self.init(Stdlib(truncatingIfNeeded: source.stdlib()))
    }
    
    @inlinable public init(load source: Element.Magnitude) {
        self.init(Stdlib(truncatingIfNeeded: source.stdlib()))
    }
        
    @inlinable public func load(as type: Element.BitPattern.Type) -> Element.BitPattern {
        self.stdlib().load(as: Element.BitPattern.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: UX.Signitude) {
        self.init(Stdlib(truncatingIfNeeded: source.stdlib()))
    }
    
    @inlinable public init(load source: UX.Magnitude) {
        self.init(Stdlib(truncatingIfNeeded: source.stdlib()))
    }
    
    @inlinable public func load(as type: UX.BitPattern.Type) -> UX.BitPattern {
        UX.BitPattern(truncatingIfNeeded: self.stdlib())
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Self is not I8 or U8
//=----------------------------------------------------------------------------=

extension CoreIntegerWhereIsNotByte {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    @inlinable public init(load source: DataInt<U8>) {
        self.init(raw: source.load(as: Element.Magnitude.self))
    }
}

//*============================================================================*
// MARK: * Core Int x Loading x IX
//*============================================================================*

extension IX {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: UX.Signitude) {
        self = source
    }
    
    @inlinable public init(load source: UX.Magnitude) {
        self.init(Stdlib(bitPattern: source.stdlib()))
    }
    
    @inlinable public func load(as type: UX.BitPattern.Type) -> UX.BitPattern {
        UInt(bitPattern: self.stdlib())
    }
}

//*============================================================================*
// MARK: * Core Int x Loading x UX
//*============================================================================*

extension UX {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: UX.Signitude) {
        self.init(Stdlib(bitPattern: source.stdlib()))
    }
    
    @inlinable public init(load source: UX.Magnitude) {
        self = source
    }
    
    @inlinable public func load(as type: UX.BitPattern.Type) -> UX.BitPattern {
        self.stdlib()
    }
}
