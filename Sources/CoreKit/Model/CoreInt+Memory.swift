//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Memory
//*============================================================================*

extension CoreInt {
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming Base.BitPattern) {        
        self.init(Base(raw: source))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: consuming  UX.Signitude) {
        self.init(Base(truncatingIfNeeded: UInt.Signitude(source)))
    }
    
    @inlinable public init(load source: consuming  UX.Magnitude) {
        self.init(Base(truncatingIfNeeded: UInt.Magnitude(source)))
    }
    
    @_disfavoredOverload // required because this model is generic
    @inlinable public borrowing func load(as type: UX.BitPattern.Type) -> UX.BitPattern {
        UInt(truncatingIfNeeded: self.base)
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: consuming  Element.Signitude) {
        self.init(Base(truncatingIfNeeded: source.base))
    }
    
    @inlinable public init(load source: consuming  Element.Magnitude) {
        self.init(Base(truncatingIfNeeded: source.base))
    }
        
    @inlinable public borrowing func load(as type: Element.BitPattern.Type) -> Element.BitPattern {
        self.base.load(as: Element.BitPattern.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    @inlinable public init(load source: LoadInt<Element.Magnitude>) {
        self.init(raw: source[UX.zero])
    }
    
    @inlinable public init(load source: DataInt<Element.Magnitude>) {
        self.init(raw: source[UX.zero])
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
        
        try Swift.withUnsafePointer(to: self) {
            try $0.withMemoryRebound(to: Element.Magnitude.self, capacity: 1) {
                try action(DataInt.Body($0, count: 1))
            }
        }
    }
    
    @inlinable public mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (MutableDataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T {
        
        try Swift.withUnsafeMutablePointer(to: &self) {
            try $0.withMemoryRebound(to: Element.Magnitude.self, capacity: 1) {
                try action(MutableDataInt.Body($0, count: 1))
            }
        }
    }
}
