//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Integers
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Self
    //=------------------------------------------------------------------------=
    
    /// Loads the `source` by trapping on `error`
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: This particular overload cannot fail.
    ///
    @inline(__always) @inlinable public init(_ source: consuming Self) {
        self = source
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Binary Integer
    //=------------------------------------------------------------------------=
        
    /// Loads the `source` by trapping on `error`
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public init<Other>(_ source: borrowing Other) where Other: BinaryInteger {
        self = Self.exactly(source).unwrap()
    }
    
    /// Loads the `source` and returns an `error` indicator.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static func exactly<Other>(_ source: borrowing Other) -> Fallible<Self> where Other: BinaryInteger {
        if  let size = IX(size: Self.self), !Other.size.isInfinite {
            if  Self.size > Other.size, Self.isSigned {
                return Fallible(Self(load: source))
                
            }   else if Self.size >= Other.size, Self.isSigned == Other.isSigned {
                return Fallible(Self(load: source))
                
            }   else if Self.size >= Other.size {
                Swift.assert(Self.isSigned != Other.isSigned)
                let rhsIsNegative = source.isNegative
                let result = Self(load: source)
                let lhsIsNegative = result.isNegative
                return result.veto(lhsIsNegative != rhsIsNegative)
                
            }   else {
                Swift.assert(Self.size < Other.size)
                let bit   = Bit.init(((Self.isSigned ? source.isNegative : false)))
                let limit = Count(raw: size.decremented(Self.isSigned).unchecked())
                let count = source.nondescending(bit)
                return Self(load: source).veto(limit < count)
            }
            
        }   else {
            return source.withUnsafeBinaryIntegerElements {
                Self.exactly($0, mode: Other.mode)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Contiguous
    //=------------------------------------------------------------------------=
    
    /// Loads the `body` and `appendix` by trapping on `error`.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: The `signedness` determines the significance of the `appendix`.
    ///
    @inlinable public init<Body: Contiguous>(
        _ body: borrowing Body,
        repeating appendix: Bit = .zero,
        mode signedness: Signedness = Self.mode
    )   where Body.Element: SystemsInteger & UnsignedInteger {
        
        self = body.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: Body.Element.Element.self) {
                Self(DataInt($0, repeating: appendix)!, mode: signedness)
            }
        }
    }
    
    /// Loads the `body` and `appendix` and returns an `error` indicator.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: The `signedness` determines the significance of the `appendix`.
    ///
    @inlinable public static func exactly<Body: Contiguous>(
        _ body: borrowing Body,
        repeating appendix: Bit = .zero,
        mode signedness: Signedness = Self.mode
    )   -> Fallible<Self> where Body.Element: SystemsInteger & UnsignedInteger {
        
        body.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: Body.Element.Element.self) {
                Self.exactly(DataInt($0, repeating: appendix)!, mode: signedness)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Data Integer
    //=------------------------------------------------------------------------=
    
    /// Loads the `source` by trapping on `error`.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: The `signedness` determines the significance of the `appendix`.
    ///
    @inlinable public init<OtherElement>(
        _ source: DataInt<OtherElement>,
        mode signedness: Signedness = Self.mode
    )   {
        
        self = Self.exactly(source, mode: signedness).unwrap()
    }
    
    /// Loads the `source` and returns an `error` indicator.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: The `signedness` determines the significance of the `appendix`.
    ///
    @inlinable public static func exactly<OtherElement>(
        _ source: DataInt<OtherElement>,
        mode signedness: Signedness = Self.mode
    )   -> Fallible<Self> {
        
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
    
    /// Loads the `source` and returns an `error` indicator.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: The `signedness` determines the significance of the `appendix`.
    ///
    @inlinable public static func exactly(
        _ source: DataInt<U8>,
        mode signedness: Signedness = Self.mode
    )   -> Fallible<Self> {
        
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
    
    /// Loads the `source` and returns an `error` indicator.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: The `signedness` determines the significance of the `appendix`.
    ///
    @inlinable public static func exactly(
        _ source: DataInt<Element.Magnitude>,
        mode signedness: Signedness = Self.mode
    )   -> Fallible<Self> {
        
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
    // MARK: Initializers x Sign & Magnitude
    //=------------------------------------------------------------------------=
    
    /// Loads the `sign` and `magnitude` by trapping on `error`.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public init<Other>(
        sign: consuming Sign = .plus,
        magnitude: consuming Other
    )   where Other: UnsignedInteger {
        self = Self.exactly(sign: sign, magnitude: magnitude).unwrap()
    }
    
    /// Loads the `sign` and `magnitude` and returns an `error` indicator.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static func exactly(
        sign: consuming Sign = .plus,
        magnitude: consuming Magnitude
    )   -> Fallible<Self> {
        
        var isNegative = Bool(sign)
        if  isNegative {
            (magnitude, isNegative) = magnitude.negated().components()
        }
        
        let value = Self(raw: magnitude)
        let error = value.isNegative != isNegative
        return value.veto(error)
    }
    
    /// Loads the `sign` and `magnitude` and returns an `error` indicator.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static func exactly<Other>(
        sign: consuming Sign = .plus,
        magnitude: consuming Other
    )   -> Fallible<Self> where Other: UnsignedInteger {
        let magnitude = Magnitude.exactly(magnitude)
        let result = Self.exactly(sign: sign, magnitude: magnitude.value)
        return result.veto(magnitude.error)
    }
}
