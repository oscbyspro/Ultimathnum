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
    
    #warning("consider init(load:) name")
    #warning("add appropriate fast paths")
    @inlinable public init<T>(truncating source: consuming T) where T: BinaryInteger {
        self = source.withUnsafeBinaryIntegerMemory {
            var stream = $0.stream()
            return Self(load: &stream)
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
