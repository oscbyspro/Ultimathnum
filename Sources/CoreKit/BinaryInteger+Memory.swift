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
    
    @inlinable public init<Source>(load source: consuming MemoryInt<Source>) {
        if  Source.memoryCanBeRebound(to: Self.Section.Magnitude.self) {
            self = (source).withMemoryRebound(to: Self.Section.Magnitude.self) {
                var stream = $0.stream()
                return Self.init(load: &stream)
            }
            
        }   else if Source.memoryCanBeRebound(to: Self.Element.Magnitude.self) {
            self = (source).withMemoryRebound(to: Self.Element.Magnitude.self) {
                var stream = $0.stream()
                return Self.init(load: &stream)
            }
            
        }   else {
            self = (source).withMemoryRebound(to: U8.self) {
                var stream = $0.stream()
                return Self.init(load: &stream)
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
    
    /// ### Development
    ///
    /// - TODO: Consider BinaryInteger.Largest asseociated type fast path.
    ///
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
            self = source.withUnsafeBinaryIntegerMemory(perform: Self.init(load:))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func withUnsafeBinaryIntegerMemory<Value>(
        perform action: (MemoryInt<Section.Magnitude>) throws -> Value
    )   rethrows -> Value {
        //=--------------------------------------=
        let appendix: Bit = self.appendix
        //=--------------------------------------=
        return try self.withUnsafeBinaryIntegerBody {
            try action(MemoryInt($0, repeating: appendix))
        }
    }
    
    @inlinable public func withUnsafeBinaryIntegerMemoryAsBytes<Value>(
        perform action: (MemoryInt<U8.Magnitude>) throws -> Value
    )   rethrows -> Value {
        
        try self.withUnsafeBinaryIntegerMemory(as: U8.self, perform: action)!
    }
    
    @inlinable public func withUnsafeBinaryIntegerMemoryAsElements<Value>(
        perform action: (MemoryInt<Element.Magnitude>) throws -> Value
    )   rethrows -> Value {
        
        try self.withUnsafeBinaryIntegerMemory(as: Element.Magnitude.self, perform: action)!
    }
    
    @inlinable public func withUnsafeBinaryIntegerMemory<Destination, Value>(
        as type: Destination.Type,
        perform action: (MemoryInt<Destination>) throws -> Value
    )   rethrows -> Optional<Value> {
        
        if  Self.memoryCanBeRebound(to: Destination.self) {
            return try self.withUnsafeBinaryIntegerMemory {
                try $0.withMemoryRebound(to: Destination.self, perform: action)
            }
        
        }   else if !Self.bitWidth.isInfinite, UX(load: Self.bitWidth) <= UX(bitWidth: Destination.self) {
            if  Self.isSigned {
                return try Destination(load: self).withUnsafeBinaryIntegerMemory(perform: action)
            }   else {
                return try Destination(load: self).withUnsafeBinaryIntegerMemory(perform: action)
            }
            
        }   else {
            
            return nil
            
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func memoryCanBeRebound<Destination>(to type: Destination.Type) -> Bool where Destination: SystemsInteger {
        //=--------------------------------------=
        let size      = Int.zero == MemoryLayout<Section>.size      % MemoryLayout<Destination>.size
        let stride    = Int.zero == MemoryLayout<Section>.stride    % MemoryLayout<Destination>.stride
        let alignment = Int.zero == MemoryLayout<Section>.alignment % MemoryLayout<Destination>.alignment
        //=--------------------------------------=
        return Bool(Bit(size) & Bit(stride) & Bit(alignment))
    }
}
