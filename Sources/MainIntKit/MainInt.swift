//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Main Int
//*============================================================================*

@frozen public struct MainInt<Base: BaseInteger>: SystemInteger {
    
    public typealias Magnitude = MainInt<Base.Magnitude>
    
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
    
    @usableFromInline var base: Base
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: consuming Base) {
        self.base = base
    }
    
    @inlinable public init(bitPattern: consuming Base.BitPattern) {
        self.base =  .init(bitPattern: bitPattern)
    }
        
    @inlinable public init(integerLiteral: consuming Base.IntegerLiteralType) {
        self.base =  .init(integerLiteral: integerLiteral)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var stdlib: Base {
        consuming get { self.base }
    }
    
    @inlinable public var bitPattern: Base.BitPattern {
        consuming get { self.base.bitPattern }
    }
    
    @inlinable public var magnitude: MainInt<Base.Magnitude> {
        consuming get { Magnitude(self.base.magnitude) }
    }
    
    @inlinable public var words: some RandomAccessCollection<Word> {
        consuming get { BitCastSequence(self.base.words) }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Un/signed
//=----------------------------------------------------------------------------=

extension MainInt:   SignedInteger where Base: Swift  .SignedInteger  { }
extension MainInt: UnsignedInteger where Base: Swift.UnsignedInteger, Base.Magnitude == Base { }

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

public typealias IX  = MainInt<Swift.Int>
public typealias I8  = MainInt<Swift.Int8>
public typealias I16 = MainInt<Swift.Int16>
public typealias I32 = MainInt<Swift.Int32>
public typealias I64 = MainInt<Swift.Int64>

public typealias UX  = MainInt<Swift.UInt>
public typealias U8  = MainInt<Swift.UInt8>
public typealias U16 = MainInt<Swift.UInt16>
public typealias U32 = MainInt<Swift.UInt32>
public typealias U64 = MainInt<Swift.UInt64>
