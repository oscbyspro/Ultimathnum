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
    /// ### Development
    ///
    /// - Note: Protocol requirements can't declare default values yet...
    ///
    @inlinable public static func arbitrary(
        uninitialized  count:  IX,
        initializer delegate: (MutableDataInt<Element.Magnitude>.Body) -> IX
    )   -> Optional<Self> {
        
        Self.arbitrary(uninitialized: count, repeating: .zero, initializer: delegate)
    }
    
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
        repeating   appendix:  Bit = .zero,
        initializer delegate: (MutableDataInt<Element.Magnitude>.Body) -> Void
    )   -> Optional<Self> {
        
        Self.arbitrary(uninitialized: count, repeating: appendix) {
            delegate($0)
            return count
        }
    }
    
    /// Creates a new instance by manually initializing memory, but only if
    /// this is an systems integer type.
    ///
    /// - Parameter delegate: A process that manually initializes each element
    ///   passed to it. It is always given the maximum number of elements that
    ///   fit in the body of this binary integer type.
    ///
    @inlinable public static func systems(
        initializer delegate: (MutableDataInt<Element.Magnitude>.Body) -> Void
    )   -> Optional<Self> {
        
        if  Self.isArbitrary {
            return nil
            
        }   else {
            var instance = Self()
            instance.withUnsafeMutableBinaryIntegerBody(delegate)
            return instance
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Performs the `action` on the `body` and `appendix` of `self`.
    @inlinable public borrowing func withUnsafeBinaryIntegerElements<Value>(
        _ action: (DataInt<Element.Magnitude>) throws -> Value
    )   rethrows -> Value {
        
        let appendix: Bit = self.appendix
        
        return try self.withUnsafeBinaryIntegerBody {
            try action(DataInt($0, repeating: appendix))
        }
    }  
    
    /// Performs the `action` on the `body` and `appendix` of `self`.
    @inlinable public mutating func withUnsafeMutableBinaryIntegerElements<Value>(
        _ action: (MutableDataInt<Element.Magnitude>) throws -> Value
    )   rethrows -> Value {
        
        let appendix: Bit = self.appendix
        
        return try self.withUnsafeMutableBinaryIntegerBody {
            try action(MutableDataInt($0, repeating: appendix))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Reinterpreting
    //=------------------------------------------------------------------------=
    
    /// Performs the `action` on the `body` of `self` and temporarily 
    /// rebinds each element to the given `type`.
    ///
    /// Any attempt to rebind the elements of `self` to a larger element `type`
    /// triggers a precondition failure. In other words, you may only downsize
    /// elements with this method.
    ///
    /// - Requires: `Element.size >= OtherElement.size`
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
    
    /// Performs the `action` on the `body` of `self` and temporarily
    /// rebinds each element to the given `type`.
    ///
    /// Any attempt to rebind the elements of `self` to a larger element `type`
    /// triggers a precondition failure. In other words, you may only downsize
    /// elements with this method.
    ///
    /// - Requires: `Element.size >= OtherElement.size`
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
    /// - Requires: `Element.size >= OtherElement.size`
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
    
    /// Performs the `action` on the `body` and `appendix` of `self` and temporarily
    /// rebinds each element to the given `type`.
    ///
    /// Any attempt to rebind the elements of `self` to a larger element `type`
    /// triggers a precondition failure. In other words, you may only downsize
    /// elements with this method.
    ///
    /// - Requires: `Element.size >= OtherElement.size`
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
}
