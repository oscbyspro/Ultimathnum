//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Memory
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<OtherElement>(load source: consuming MemoryInt<OtherElement>) {
        if  MemoryIntBody<OtherElement>.memoryCanBeRebound(to: Self.Element.Magnitude.self) {
            
            self = source.withMemoryRebound(to: Self.Element.Magnitude.self) {
                var stream = $0.stream(); return Self.init(load: &stream)
            }
            
        }   else {
            
            self = source.withMemoryRebound(to: I8.Magnitude.self) {
                var stream = $0.stream(); return Self.init(load: &stream)
            }
            
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(load source: consuming T) where T: SystemsInteger<UX.BitPattern> {
        if  T.isSigned {
            self.init(load: UX.Signitude(bitPattern: source))
        }   else {
            self.init(load: UX.Magnitude(bitPattern: source))
        }
    }
    
    @inlinable public borrowing func load<T>(as type: T.Type) -> T where T: SystemsInteger<UX.BitPattern> {
        T(bitPattern: self.load(as: UX.BitPattern.self))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(load source: consuming T) where T: SystemsInteger<Element.BitPattern> {
        if  T.isSigned {
            self.init(load: Element.Signitude(bitPattern: source))
        }   else {
            self.init(load: Element.Magnitude(bitPattern: source))
        }
    }
    
    @inlinable public borrowing func load<T>(as type: T.Type) -> T where T: SystemsInteger<Element.BitPattern> {
        T(bitPattern: self.load(as: Element.BitPattern.self))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializeres
    //=------------------------------------------------------------------------=
    
    @inlinable public init<Other>(load source: consuming Other) where Other: BinaryInteger {
        let lhsIsSmall = !Self .bitWidth.isInfinite && UX(load: Self .bitWidth) <= UX.bitWidth
        let rhsIsSmall = !Other.bitWidth.isInfinite && UX(load: Other.bitWidth) <= UX.bitWidth
        
        if  lhsIsSmall || rhsIsSmall {
            
            if  Self.isSigned {
                self.init(load: IX(load: source))
            }   else {
                self.init(load: UX(load: source))
            }
                        
        }   else {
            
            self = source.withUnsafeBinaryIntegerMemory(Self.init(load:))
            
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func withUnsafeBinaryIntegerMemory<T>(_ action: (MemoryInt<U8>) throws -> T) rethrows -> T {
        let appendix: Bit = self.appendix
        return try self.withUnsafeBinaryIntegerBody {
            try $0.withMemoryRebound(to: U8.self) {
                try action(MemoryInt($0, repeating: appendix))
            }
        }
    }
}
