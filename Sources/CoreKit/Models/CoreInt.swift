//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int
//*============================================================================*

/// The stuff integers are made of.
///
/// This protocol is meant to reduce code duplication.
///
/// ### Models
///
/// Only the following types conform to this protocol:
///
/// - `IX`
/// - `I8`
/// - `I16`
/// - `I32`
/// - `I64`
/// - `UX`
/// - `U8`
/// - `U16`
/// - `U32`
/// - `U64`
///
@usableFromInline protocol CoreInteger: 
    Interoperable,
    SystemsInteger
where 
    BitPattern == Stdlib.BitPattern,
    Element == Self,
    IntegerLiteralType == Stdlib,
    Signitude: CoreInteger,
    Stdlib: BitCastable,
    Stdlib: Swift.FixedWidthInteger,
    Stdlib: Swift.Sendable,
    Magnitude: CoreInteger,
    Magnitude.Stdlib == Stdlib.Magnitude
{
    
    @inlinable var base: Stdlib { get }
}

//=----------------------------------------------------------------------------=
// MARK: + Composition
//=----------------------------------------------------------------------------=

@usableFromInline protocol CoreIntegerWhereIsNotByte:  CoreInteger { }
@usableFromInline protocol CoreIntegerWhereIsNotToken: CoreInteger { }
@usableFromInline protocol CoreIntegerWhereIsSigned:   CoreInteger &   SignedInteger where Stdlib: Swift  .SignedInteger { }
@usableFromInline protocol CoreIntegerWhereIsUnsigned: CoreInteger & UnsignedInteger where Stdlib: Swift.UnsignedInteger { }

//*============================================================================*
// MARK: * Core Int x IX
//*============================================================================*

/// A pointer-bit signed binary integer.
@frozen public struct IX: CoreIntegerWhereIsSigned, CoreIntegerWhereIsNotByte {
    
    public typealias Stdlib = Swift.Int
    
    public typealias BitPattern = Stdlib.BitPattern
    
    public typealias Element = Self
        
    public typealias Signitude = Self
    
    public typealias Magnitude = UX
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Stdlib
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Stdlib) {
        self.base = source
    }
    
    @inlinable public init(raw source: BitPattern) {
        self.base = Stdlib(bitPattern: source)
    }
    
    @inlinable public init(integerLiteral source: Stdlib) {
        self.base = source
    }
    
    @inlinable public consuming func stdlib() -> Stdlib {
        self.base
    }
}

//*============================================================================*
// MARK: * Core Int x I8
//*============================================================================*

/// An 8-bit signed binary integer.
@frozen public struct I8: CoreIntegerWhereIsSigned, CoreIntegerWhereIsNotToken {
    
    public typealias Stdlib = Swift.Int8
    
    public typealias BitPattern = Stdlib.BitPattern
    
    public typealias Element = Self
    
    public typealias Signitude = Self
    
    public typealias Magnitude = U8
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Stdlib
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Stdlib) {
        self.base = source
    }
    
    @inlinable public init(raw source: BitPattern) {
        self.base = Stdlib(bitPattern: source)
    }
    
    @inlinable public init(integerLiteral source: Stdlib) {
        self.base = source
    }
    
    @inlinable public consuming func stdlib() -> Stdlib {
        self.base
    }
}

//*============================================================================*
// MARK: * Core Int x I16
//*============================================================================*

/// A 16-bit signed binary integer.
@frozen public struct I16: CoreIntegerWhereIsSigned, CoreIntegerWhereIsNotByte, CoreIntegerWhereIsNotToken {
    
    public typealias Stdlib = Swift.Int16
    
    public typealias BitPattern = Stdlib.BitPattern
    
    public typealias Element   = Self
    
    public typealias Signitude = Self
    
    public typealias Magnitude = U16
            
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Stdlib
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Stdlib) {
        self.base = source
    }
    
    @inlinable public init(raw source: BitPattern) {
        self.base = Stdlib(bitPattern: source)
    }
    
    @inlinable public init(integerLiteral source: Stdlib) {
        self.base = source
    }
    
    @inlinable public consuming func stdlib() -> Stdlib {
        self.base
    }
}

//*============================================================================*
// MARK: * Core Int x I32
//*============================================================================*

/// A 32-bit signed binary integer.
@frozen public struct I32: CoreIntegerWhereIsSigned, CoreIntegerWhereIsNotByte, CoreIntegerWhereIsNotToken {
    
    public typealias Stdlib = Swift.Int32
    
    public typealias BitPattern = Stdlib.BitPattern
    
    public typealias Element = Self
        
    public typealias Signitude = Self
    
    public typealias Magnitude = U32
            
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Stdlib
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Stdlib) {
        self.base = source
    }
    
    @inlinable public init(raw source: BitPattern) {
        self.base = Stdlib(bitPattern: source)
    }
    
    @inlinable public init(integerLiteral source: Stdlib) {
        self.base = source
    }
    
    @inlinable public consuming func stdlib() -> Stdlib {
        self.base
    }
}

//*============================================================================*
// MARK: * Core Int x I64
//*============================================================================*

/// A 64-bit signed binary integer.
@frozen public struct I64: CoreIntegerWhereIsSigned, CoreIntegerWhereIsNotByte, CoreIntegerWhereIsNotToken {
    
    public typealias Stdlib = Swift.Int64
    
    public typealias BitPattern = Stdlib.BitPattern
    
    public typealias Element = Self
        
    public typealias Signitude = Self
    
    public typealias Magnitude = U64
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Stdlib
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Stdlib) {
        self.base = source
    }
    
    @inlinable public init(raw source: BitPattern) {
        self.base = Stdlib(bitPattern: source)
    }
    
    @inlinable public init(integerLiteral source: Stdlib) {
        self.base = source
    }
    
    @inlinable public consuming func stdlib() -> Stdlib {
        self.base
    }
}

//*============================================================================*
// MARK: * Core Int x UX
//*============================================================================*

/// A pointer-bit unsigned binary integer.
@frozen public struct UX: CoreIntegerWhereIsUnsigned, CoreIntegerWhereIsNotByte {
    
    public typealias Stdlib = Swift.UInt
    
    public typealias BitPattern = Stdlib.BitPattern
    
    public typealias Element = Self
    
    public typealias Signitude = IX
    
    public typealias Magnitude = Self
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Stdlib
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Stdlib) {
        self.base = source
    }
    
    @inlinable public init(raw source: BitPattern) {
        self.base = source
    }
    
    @inlinable public init(integerLiteral source: Stdlib) {
        self.base = source
    }
    
    @inlinable public consuming func stdlib() -> Stdlib {
        self.base
    }
}

//*============================================================================*
// MARK: * Core Int x U8
//*============================================================================*

/// An 8-bit unsigned binary integer.
@frozen public struct U8: CoreIntegerWhereIsUnsigned, CoreIntegerWhereIsNotToken {
    
    public typealias Stdlib = Swift.UInt8
    
    public typealias BitPattern = Stdlib.BitPattern
    
    public typealias Element = Self

    public typealias Signitude = I8
    
    public typealias Magnitude = Self
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Stdlib
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Stdlib) {
        self.base = source
    }
    
    @inlinable public init(raw source: BitPattern) {
        self.base = source
    }
    
    @inlinable public init(integerLiteral source: Stdlib) {
        self.base = source
    }
    
    @inlinable public consuming func stdlib() -> Stdlib {
        self.base
    }
}

//*============================================================================*
// MARK: * Core Int x U16
//*============================================================================*

/// A 16-bit unsigned binary integer.
@frozen public struct U16: CoreIntegerWhereIsUnsigned, CoreIntegerWhereIsNotByte, CoreIntegerWhereIsNotToken {
    
    public typealias Stdlib = Swift.UInt16
    
    public typealias BitPattern = Stdlib.BitPattern
    
    public typealias Element = Self
            
    public typealias Signitude = I16
    
    public typealias Magnitude = Self
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Stdlib
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Stdlib) {
        self.base = source
    }
    
    @inlinable public init(raw source: BitPattern) {
        self.base = source
    }
    
    @inlinable public init(integerLiteral source: Stdlib) {
        self.base = source
    }
    
    @inlinable public consuming func stdlib() -> Stdlib {
        self.base
    }
}

//*============================================================================*
// MARK: * Core Int x U32
//*============================================================================*

/// A 32-bit unsigned binary integer.
@frozen public struct U32: CoreIntegerWhereIsUnsigned, CoreIntegerWhereIsNotByte, CoreIntegerWhereIsNotToken {
    
    public typealias Stdlib = Swift.UInt32
    
    public typealias BitPattern = Stdlib.BitPattern
    
    public typealias Element = Self
            
    public typealias Signitude = I32
    
    public typealias Magnitude = Self
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Stdlib
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Stdlib) {
        self.base = source
    }
    
    @inlinable public init(raw source: BitPattern) {
        self.base = source
    }
    
    @inlinable public init(integerLiteral source: Stdlib) {
        self.base = source
    }
    
    @inlinable public consuming func stdlib() -> Stdlib {
        self.base
    }
}

//*============================================================================*
// MARK: * Core Int x U64
//*============================================================================*

/// A 64-bit unsigned binary integer.
@frozen public struct U64: CoreIntegerWhereIsUnsigned, CoreIntegerWhereIsNotByte, CoreIntegerWhereIsNotToken {
    
    public typealias Stdlib = Swift.UInt64
    
    public typealias BitPattern = Stdlib.BitPattern
    
    public typealias Element = Self
            
    public typealias Signitude = I64
    
    public typealias Magnitude = Self
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Stdlib
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Stdlib) {
        self.base = source
    }
    
    @inlinable public init(raw source: BitPattern) {
        self.base = source
    }
    
    @inlinable public init(integerLiteral source: Stdlib) {
        self.base = source
    }
    
    @inlinable public consuming func stdlib() -> Stdlib {
        self.base
    }
}
