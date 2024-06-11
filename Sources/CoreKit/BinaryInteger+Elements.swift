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
    
    /// Creates a validated instance from the given `source` and `mode`.
    @inlinable public static func exactly(
        _ source: DataInt<U8>, mode: some Signedness
    )   -> Fallible<Self> {
        //=--------------------------------------=
        let instance = Self(load: source)
        var success  = Bit(instance.appendix == source.appendix)
        //=--------------------------------------=
        if !Self.mode.matches(signedness: mode) {
            success &= source.appendix.toggled()
        }
        
        if  let size  = UX(size: Self.self) {
            let ratio = size / UX(size: U8.self)
            let suffix: DataInt<U8> = source[ratio...]
            success = success & Bit(suffix.normalized().body.count.isZero)
        }
        //=--------------------------------------=
        return instance.veto(!Bool(success))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a validated instance from the given `source` and `mode`.
    @inlinable public static func exactly(
        _ source: DataInt<Element.Magnitude>, mode: some Signedness
    )   -> Fallible<Self> {
        //=--------------------------------------=
        let instance = Self(load: source)
        var success  = Bit(instance.appendix == source.appendix)
        //=--------------------------------------=
        if !Self.mode.matches(signedness: mode) {
            success &= source.appendix.toggled()
        }
        
        if  let size  = UX(size: Self.self) {
            let ratio = size / UX(size: Element.Magnitude.self)
            let suffix: DataInt<Element.Magnitude> = source[ratio...]
            success = success & Bit(suffix.normalized().body.count.isZero)
        }
        //=--------------------------------------=
        return instance.veto(!Bool(success))
    }
    
    /// Creates a validated instance from the given `source` and `mode`.
    @inlinable public static func exactly<OtherElement>(
        _ source: DataInt<OtherElement>, mode: some Signedness
    )   -> Fallible<Self> {
                
        if  UX(size: OtherElement.self) >= UX(size: Self.Element.Magnitude.self) {
            return source.reinterpret(as: Self.Element.Magnitude.self) {
                return Self.exactly($0, mode: mode)
            }
            
        }   else {
            return source.reinterpret(as: U8.self) {
                return Self.exactly($0, mode: mode)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given `source` and `mode` by trapping on failure.
    @inlinable public init<OtherElement>(_ source: DataInt<OtherElement>, mode: some Signedness) {
        self = Self.exactly(source, mode: mode).unwrap()
    }
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    @inlinable public init<OtherElement>(load source: DataInt<OtherElement>) {
        if  UX(size: OtherElement.self) >= UX(size: Self.Element.Magnitude.self) {
            self = source.reinterpret(as: Self.Element.Magnitude.self, perform: Self.init(load:))
        }   else {
            self = source.reinterpret(as: U8.self, perform: Self.init(load:))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    @inlinable public init<T>(load source: consuming T) where T: SystemsInteger<UX.BitPattern> {
        if  T.isSigned {
            self.init(load: UX.Signitude(raw: source))
        }   else {
            self.init(load: UX.Magnitude(raw: source))
        }
    }
    
    /// Returns instance of `type` from the bit pattern of `self` that fits.
    @inlinable public borrowing func load<T>(as type: T.Type) -> T where T: SystemsInteger<UX.BitPattern> {
        T(raw: self.load(as: UX.BitPattern.self))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    @inlinable public init<T>(load source: consuming T) where T: SystemsInteger<Element.BitPattern> {
        if  T.isSigned {
            self.init(load: Element.Signitude(raw: source))
        }   else {
            self.init(load: Element.Magnitude(raw: source))
        }
    }
    
    /// Returns instance of `type` from the bit pattern of `self` that fits.
    @inlinable public borrowing func load<T>(as type: T.Type) -> T where T: SystemsInteger<Element.BitPattern> {
        T(raw: self.load(as: Element.BitPattern.self))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializeres
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    @inlinable public init<Other>(load source: borrowing Other) where Other: BinaryInteger {
        let lhsIsSmall = UX(size: Self .self).map({ $0 <= UX.size }) == true
        let rhsIsSmall = UX(size: Other.self).map({ $0 <= UX.size }) == true
        
        if  lhsIsSmall || rhsIsSmall {
            if  Other.isSigned  {
                self.init(load: IX(load: source))
            }   else {
                self.init(load: UX(load: source))
            }

        }   else {
            self = source.withUnsafeBinaryIntegerElements(Self.init(load:))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
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
    // MARK: Utilities
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
// MARK: * Binary Integer x Elements x Systems
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    @inlinable public init<T>(load source: borrowing T) where T: BinaryInteger, BitPattern == UX.BitPattern {
        self = source.load(as: Self.self)
    }
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    @inlinable public init<T>(load source: borrowing T) where T: BinaryInteger, BitPattern == T.Element.BitPattern {
        self = source.load(as: Self.self)
    }
}
