//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Numbers
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var zero: Self {
        Self()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() {
        self = 0
    }
    
    @inlinable public init(_ source: consuming Self) {
        self = source
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func exactly(
        sign: consuming Sign = .plus,
        magnitude: consuming Magnitude
    )   -> Fallible<Self> {
        
        var isLessThanZero = Bool(sign)
        if  isLessThanZero {
            isLessThanZero = magnitude.capture({ $0.negated() })
        }
        
        let value = Self(bitPattern: magnitude)
        return value.combine(value.isLessThanZero != isLessThanZero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(_ source: consuming T) where T: BinaryInteger {
        self = Self.exactly(source).unwrap()
    }
    
    #warning("add appropriate fast paths")
    @inlinable public init<T>(truncating source: consuming T) where T: BinaryInteger {
        self = source.withUnsafeBinaryIntegerData {
            var stream = $0.stream()
            return Self(load: &stream)
        }
    }
    
    @inlinable public static func exactly<T>(_ source: consuming T) -> Fallible<Self> where T: BinaryInteger {
        source.withUnsafeBinaryIntegerData {
            Self.exactly(elements: $0, isSigned: T.isSigned)
        }
    }
    
    /// ### Development
    ///
    /// - TODO: Add appropriate fast paths based on element size.
    ///
    /// - TODO: Make the isSigned parameter generic.
    ///
    @inlinable public static func exactly<T>(elements: consuming MemoryInt<T>, isSigned: Bool) -> Fallible<Self> {
        elements.withMemoryRebound(to: U8.self) {
            let appendix = $0.appendix
            var (stream) = $0.stream()
            let instance = Self(load: &stream)
            
            let success = (instance.appendix == appendix)
            && (Self.isSigned == isSigned || appendix == Bit.zero)
            && stream.normalized().body.count == IX.zero
            
            return instance.combine(!success)
        }
    }
        
    @inlinable public static func exactly<T>(body: consuming Array<T>, isSigned: Bool) -> Fallible<Self> where T: SystemsInteger & UnsignedInteger {
        body.withUnsafeBufferPointer {
            let body = MemoryIntBody($0.baseAddress!, count: IX($0.count))
            let elements = MemoryInt(body, isSigned: isSigned)
            return Self.exactly(elements: elements , isSigned: isSigned)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func complement() -> Self {
        self.complement(true).value
    }
    
    @inlinable public consuming func magnitude() -> Magnitude {
        Magnitude(bitPattern: self.isLessThanZero ? self.complement() : self)
    }
}
