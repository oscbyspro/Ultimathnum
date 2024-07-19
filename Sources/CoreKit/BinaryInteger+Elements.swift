//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Elements
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance by manually initializing memory, but only if
    /// this is an arbitrary integer type and the given arguments are valid.
    ///
    /// - Parameter count: The number of uninitialized elements that will be
    ///   passed to the `delegate`. It must not be negative or exceed the entropy
    ///   limit.
    ///
    /// - Parameter appendix: The bit that extends the bit pattern initialized
    ///   by the `delegate`. Its significance depends on the signedness of this
    ///   binary integer type.
    ///
    /// - Parameter delegate: A process that manually initializes a prefix in
    ///   the buffer passed to it. It must return the initialized prefix length
    ///   at the end of its execution. Note that `Void` is automatically
    ///   reinterpreted as the given `count` by a convenient function overload.
    ///
    @inlinable public static func arbitrary(
        uninitialized  count:  IX,
        repeating   appendix:  Bit,
        initializer delegate: (MutableDataInt<Element.Magnitude>.Body) -> Void
    )   -> Optional<Self> {
        
        self.arbitrary(uninitialized: count, repeating: appendix) {
            delegate($0)
            return count
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x DataInt
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    @inlinable public init<OtherElement>(load source: DataInt<OtherElement>) {
        if  Self.Element.Magnitude.size <= OtherElement.size {
            self = source.reinterpret(as: Self.Element.Magnitude.self, perform: Self.init(load:))
        }   else {
            self = source.reinterpret(as: U8.self, perform: Self.init(load:))
        }
    }
    
    /// Creates a new instance from the given `source` and `signedness` by trapping on failure.
    @inlinable public init<OtherElement>(_ source: DataInt<OtherElement>, mode signedness: Signedness) {
        self = Self.exactly(source, mode: signedness).unwrap()
    }
    
    /// Creates a validated instance from the given `source` and `signedness`.
    @inlinable public static func exactly<OtherElement>(_ source: DataInt<OtherElement>, mode signedness: Signedness) -> Fallible<Self> {
        if  Self.Element.Magnitude.size <= OtherElement.size {
            return source.reinterpret(as: Self.Element.Magnitude.self) {
                Self.exactly($0, mode: signedness)
            }
            
        }   else {
            return source.reinterpret(as: U8.self) {
                Self.exactly($0, mode: signedness)
            }
        }
    }
    
    /// Creates a validated instance from the given `source` and `signedness`.
    @inlinable public static func exactly(_ source: DataInt<U8>, mode signedness: Signedness) -> Fallible<Self> {
        let instance = Self(load: source)
        let appendix = instance.appendix
        var success  = appendix == source.appendix
        
        if  success, signedness != Self.mode {
            success  = appendix == Bit .zero
        }
        
        if  success, let size = UX(size: Self.self) {
            let end  =   size / UX(size:   U8.self)
            success  = source[end...].normalized().body.isEmpty
        }
        
        return instance.veto(!Bool(success))
    }
    
    /// Creates a validated instance from the given `source` and `signedness`.
    @inlinable public static func exactly(_ source: DataInt<Element.Magnitude>, mode signedness: Signedness) -> Fallible<Self> {
        let instance = Self(load: source)
        let appendix = instance.appendix
        var success  = appendix == source.appendix
        
        if  success, signedness != Self.mode {
            success  = appendix == Bit .zero
        }
        
        if  success, let size = UX(size: Self.self) {
            let end  =   size / UX(size: Element.Magnitude.self)
            success  = source[end...].normalized().body.isEmpty
        }
        
        return instance.veto(!Bool(success))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x BinaryInteger
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    @inlinable public init<Other>(load source: borrowing Other) where Other: BinaryInteger {
        if  Other.size <= Swift.min(Element.size, UX.size) {
            if  Other.isSigned {
                self.init(load: Element.Signitude(load: IX(load: source)))
            }   else {
                self.init(load: Element.Magnitude(load: UX(load: source)))
            }
            
        }   else if Self.size <= UX.size || Other.size <= UX.size {
            if  Other.isSigned {
                self.init(load: IX(load: source))
            }   else {
                self.init(load: UX(load: source))
            }
            
        }   else {
            self = source.withUnsafeBinaryIntegerElements(Self.init(load:))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Elements
    //=------------------------------------------------------------------------=
    //=------------------------------------------------------------------------=
    // TODO: await appendix { borrowing get } fixes then make these borrowing
    //=------------------------------------------------------------------------=
    
    
    /// Performs the `action` on the `body` and `appendix` of `self`.
    @inlinable public func withUnsafeBinaryIntegerElements<Value>(
        _ action: (DataInt<Element.Magnitude>) throws -> Value
    )   rethrows -> Value {
        
        let appendix = self.appendix
        
        return try self.withUnsafeBinaryIntegerBody {
            try action(DataInt($0, repeating: appendix))
        }
    }  
    
    /// Performs the `action` on the mutable `body` and `appendix` of `self`.
    @inlinable public mutating func withUnsafeMutableBinaryIntegerElements<Value>(
        _ action: (MutableDataInt<Element.Magnitude>) throws -> Value
    )   rethrows -> Value {
        
        let appendix: Bit = self.appendix
        
        return try self.withUnsafeMutableBinaryIntegerBody {
            try action(MutableDataInt($0, repeating: appendix))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Elements x Downsized
    //=------------------------------------------------------------------------=
    
    /// Performs the `action` on the `body` of `self` and temporarily 
    /// rebinds each element to the given `type`.
    ///
    /// Any attempt to rebind the elements of `self` to a larger element `type`
    /// triggers a precondition failure. In other words, you may only downsize
    /// elements with this method.
    ///
    /// - Requires: `Element.size >= Destination.size`
    ///
    /// - Note: You may always reinterpret its elements as bytes (`U8`).
    ///
    @inlinable public borrowing func withUnsafeBinaryIntegerBody<OtherElement, Value>(
        as type: OtherElement.Type,
        perform action: (DataInt<OtherElement>.Body) throws -> Value
    )   rethrows -> Value {
        
        try self.withUnsafeBinaryIntegerBody {
            try $0.reinterpret(as: OtherElement.self, perform: action)
        }
    }
    
    /// Performs the `action` on the mutable `body` of `self` and temporarily
    /// rebinds each element to the given `type`.
    ///
    /// Any attempt to rebind the elements of `self` to a larger element `type`
    /// triggers a precondition failure. In other words, you may only downsize
    /// elements with this method.
    ///
    /// - Requires: `Element.size >= Destination.size`
    ///
    /// - Note: You may always reinterpret its elements as bytes (`U8`).
    ///
    @inlinable public mutating func withUnsafeMutableBinaryIntegerBody<OtherElement, Value>(
        as type: OtherElement.Type,
        perform action: (MutableDataInt<OtherElement>.Body) throws -> Value
    )   rethrows -> Value {
        
        try self.withUnsafeMutableBinaryIntegerBody {
            try $0.reinterpret(as: OtherElement.self, perform: action)
        }
    }
    
    /// Performs the `action` on the `body` and `appendix` of `self` and temporarily
    /// rebinds each element to the given `type`.
    ///
    /// Any attempt to rebind the elements of `self` to a larger element `type`
    /// triggers a precondition failure. In other words, you may only downsize
    /// elements with this method.
    ///
    /// - Requires: `Element.size >= Destination.size`
    ///
    /// - Note: You may always reinterpret its elements as bytes (`U8`).
    ///
    @inlinable public borrowing func withUnsafeBinaryIntegerElements<OtherElement, Value>(
        as type: OtherElement.Type,
        perform action: (DataInt<OtherElement>) throws -> Value
    )   rethrows -> Value {
        
        try self.withUnsafeBinaryIntegerElements {
            try $0.reinterpret(as: OtherElement.self, perform: action)
        }
    }
    
    /// Performs the `action` on the mutable `body` and `appendix` of `self` and temporarily
    /// rebinds each element to the given `type`.
    ///
    /// Any attempt to rebind the elements of `self` to a larger element `type`
    /// triggers a precondition failure. In other words, you may only downsize
    /// elements with this method.
    ///
    /// - Requires: `Element.size >= Destination.size`
    ///
    /// - Note: You may always reinterpret its elements as bytes (`U8`).
    ///
    @inlinable public mutating func withUnsafeMutableBinaryIntegerElements<OtherElement, Value>(
        as type: OtherElement.Type,
        perform action: (MutableDataInt<OtherElement>) throws -> Value
    )   rethrows -> Value {
        
        try self.withUnsafeMutableBinaryIntegerElements {
            try $0.reinterpret(as: OtherElement.self, perform: action)
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Elements x Arbitrary
//*============================================================================*

extension ArbitraryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given `body` and `appendix`.
    ///
    /// - Note: This is a convenience derived from `init<T>(DataInt<T>)`.
    ///
    @inlinable public init<T>(_ body: borrowing T, repeating appendix: Bit = .zero)
    where T: Sequence, T.Element: SystemsInteger & UnsignedInteger {
        
        let instance = body.withContiguousStorageIfAvailable {
            Self(load: DataInt($0, repeating: appendix)!)
        }
                
        if  let    instance {
            self = instance
        }   else {
            self = ContiguousArray(copy body).withUnsafeBufferPointer {
                Self(load: DataInt($0, repeating: appendix)!)
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Elements x Systems
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func arbitrary(
        uninitialized  count:  IX,
        repeating   appendix:  Bit,
        initializer delegate: (MutableDataInt<Element.Magnitude>.Body) -> IX
    )   -> Optional<Self> {
        
        nil // SystemsInteger != ArbitraryInteger
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    ///
    /// - Note: This is the generic version of `BinaryInteger/load(as:)`.
    ///
    @inlinable public init<Other>(load source: borrowing Other) where Other: BinaryInteger, BitPattern == UX.BitPattern {
        self.init(raw: source.load(as: BitPattern.self))
    }
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    ///
    /// - Note: This is the generic version of `BinaryInteger/load(as:)`.
    ///
    @inlinable public init<Other>(load source: borrowing Other) where Other: BinaryInteger, BitPattern == Other.Element.BitPattern {
        self.init(raw: source.load(as: BitPattern.self))
    }
}
