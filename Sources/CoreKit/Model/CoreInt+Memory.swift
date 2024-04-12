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
    
    @inlinable public init(bitPattern: consuming Base.BitPattern) {
        self.base = Base(bitPattern: bitPattern)
    }
    
    @inlinable public var bitPattern: Base.BitPattern {
        consuming get { self.base.bitPattern }
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
        (copy  self).bitPattern
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    @inlinable public init(load source: MemoryInt<I8.Magnitude>) {
        if  source.body.count >= IX(MemoryLayout<Self>.stride) {
            
            self = UnsafeRawPointer(source.body.start).loadUnaligned(as: Self.self)
                        
        }   else {
            self.init(repeating: source.appendix)
                        
            Swift.withUnsafeMutablePointer(to: &self) {
                $0.withMemoryRebound(to: U8.self, capacity: MemoryLayout<Self>.size) {
                    $0.initialize(from: source.body.start, count: Int(source.body.count))
                }
            }
        }
    }
    
    @inlinable public init(load source: MemoryInt<Element.Magnitude>) {
        self.init(bitPattern: source[UX.zero])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        Bit(Self.isSigned && self < 0)
    }
    
    @inlinable public borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (MemoryIntBody<Element.Magnitude>) throws -> T
    )   rethrows -> T {
        
        try Swift.withUnsafePointer(to: self) {
            try $0.withMemoryRebound(to: Element.Magnitude.self, capacity: 1) {
                try action(MemoryIntBody($0, count: 1))
            }
        }
    }
}
