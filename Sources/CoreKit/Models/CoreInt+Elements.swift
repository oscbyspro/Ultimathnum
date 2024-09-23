//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Elements
//*============================================================================*

extension CoreInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: DataInt<Element.Magnitude>) {
        self.init(raw: source.first)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        Bit(Self.isSigned && self < 0)
    }
    
    @inlinable public borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (DataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T {
        
        try Swift .withUnsafePointer(to: self) {
            try $0.withMemoryRebound(to: Element.Magnitude.self, capacity: 1) {
                try action(DataInt.Body($0, count: 1))
            }
        }
    }
    
    @inlinable public mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (MutableDataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T {
        
        try Swift .withUnsafeMutablePointer(to: &self) {
            try $0.withMemoryRebound(to: Element.Magnitude.self, capacity: 1) {
                try action(MutableDataInt.Body($0, count: 1))
            }
        }
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
// MARK: * Core Int x Elements x IX
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
// MARK: * Core Int x Elements x UX
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
