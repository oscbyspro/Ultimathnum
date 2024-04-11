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
        if Source.elementsCanBeRebound(to: Self.Element.Magnitude.self) {
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
            if  Other.isSigned  {
                self.init(load: IX(load: source))
            }   else {
                self.init(load: UX(load: source))
            }

        }   else {
            self = source.withUnsafeBinaryIntegerElements(perform: Self.init(load:))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func withUnsafeBinaryIntegerElements<Value>(
        perform action: (MemoryInt<Element.Magnitude>) throws -> Value
    )   rethrows -> Value {
        //=--------------------------------------=
        let appendix: Bit = self.appendix
        //=--------------------------------------=
        return try self.withUnsafeBinaryIntegerBody {
            try action(MemoryInt($0, repeating: appendix))
        }
    }
    
    @inlinable public func withUnsafeBinaryIntegerElementsAsBytes<Value>(
        perform action: (MemoryInt<U8.Magnitude>) throws -> Value
    )   rethrows -> Value {
        
        try self.withUnsafeBinaryIntegerElements(as: U8.self, perform: action)!
    }
    
    @inlinable public func withUnsafeBinaryIntegerElements<OtherElement, Value>(
        as type: OtherElement.Type,
        perform action: (MemoryInt<OtherElement>) throws -> Value
    )   rethrows -> Optional<Value> {
        
        if  Self.elementsCanBeRebound(to: OtherElement.self) {
            return try self.withUnsafeBinaryIntegerElements {
                try $0.withMemoryRebound(to: OtherElement.self, perform: action)
            }
            
        }   else {
            return nil
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func elementsCanBeRebound<OtherElement>(to type: OtherElement.Type) -> Bool where OtherElement: SystemsInteger {
        //=--------------------------------------=
        let size      = Int.zero == MemoryLayout<Self.Element>.size      % MemoryLayout<OtherElement>.size
        let stride    = Int.zero == MemoryLayout<Self.Element>.stride    % MemoryLayout<OtherElement>.stride
        let alignment = Int.zero == MemoryLayout<Self.Element>.alignment % MemoryLayout<OtherElement>.alignment
        //=--------------------------------------=
        return Bool(Bit(size) & Bit(stride) & Bit(alignment))
    }
}
