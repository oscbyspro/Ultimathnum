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

@frozen public struct CoreInt<Base: BaseInteger>: SystemsInteger {
    
    public typealias Element = Self
    
    public typealias Magnitude = CoreInt<Base.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        Base.isSigned
    }
    
    @inlinable public static var bitWidth: Magnitude {
        Magnitude(Base.Magnitude(Base.Magnitude.bitWidth))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var base: Base
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: consuming Base) {
        self.base = base
    }
    
    @inlinable public init(integerLiteral: consuming Base.IntegerLiteralType) {
        self.init(Base(integerLiteral: integerLiteral))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Un/signed
//=----------------------------------------------------------------------------=

extension CoreInt:   SignedInteger where Base: Swift  .SignedInteger  { }
extension CoreInt: UnsignedInteger where Base: Swift.UnsignedInteger, Base.Magnitude == Base { }

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

public typealias IX  = CoreInt<Swift.Int>
public typealias I8  = CoreInt<Swift.Int8>
public typealias I16 = CoreInt<Swift.Int16>
public typealias I32 = CoreInt<Swift.Int32>
public typealias I64 = CoreInt<Swift.Int64>

public typealias UX  = CoreInt<Swift.UInt>
public typealias U8  = CoreInt<Swift.UInt8>
public typealias U16 = CoreInt<Swift.UInt16>
public typealias U32 = CoreInt<Swift.UInt32>
public typealias U64 = CoreInt<Swift.UInt64>
