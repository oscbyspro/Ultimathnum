//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreIop
import CoreKit
import DoubleIntKit

//*============================================================================*
// MARK: * Infini Int x Stdlib
//*============================================================================*

extension DoubleInt: Interoperable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: consuming Stdlib) {
        self = source.base
    }
    
    @inlinable public consuming func stdlib() -> Stdlib {
        Stdlib(self)
    }
    
    //*========================================================================*
    // MARK: * Stdlib
    //*========================================================================*
    
    @frozen public struct Stdlib:
        BitCastable,
        Swift.FixedWidthInteger,
        Swift.LosslessStringConvertible,
        Swift.Sendable
    {
        
        public typealias Base = DoubleInt
        
        public typealias Magnitude = Base.Magnitude.Stdlib
        
        //=--------------------------------------------------------------------=
        // MARK: Metadata
        //=--------------------------------------------------------------------=
        
        @inlinable public static var isSigned: Bool {
            Base.isSigned
        }
        
        @inlinable public static var bitWidth: Swift.Int {
            Swift.Int(IX(size: Base.self))
        }
        
        @inlinable public static var max: Self {
            Base.max.stdlib()
        }
        
        @inlinable public static var min: Self {
            Base.min.stdlib()
        }
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var base: Base
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ base: consuming Base) {
            self.base = base
        }
        
        @inlinable public init(raw source: consuming Base.BitPattern) {
            self.init(Base(raw: source))
        }
        
        @inlinable public consuming func load(as type: Base.BitPattern.Type) -> Base.BitPattern {
            self.base.load(as: Base.BitPattern.self)
        }
        
        @inlinable public init(integerLiteral: Base.IntegerLiteralType) {
            self.init(Base(integerLiteral: integerLiteral))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conditional
//=----------------------------------------------------------------------------=

extension DoubleInt: CompactIntegerInteroperable where High: CompactIntegerInteroperable { }
extension DoubleInt:  FiniteIntegerInteroperable where High: SystemsIntegerInteroperable { }
extension DoubleInt: NaturalIntegerInteroperable where High: NaturalIntegerInteroperable { }
extension DoubleInt:  SignedIntegerInteroperable where High: CompactIntegerInteroperable { }
extension DoubleInt: SystemsIntegerInteroperable where High: SystemsIntegerInteroperable { }

extension DoubleInt.Stdlib: Swift  .SignedNumeric where Base:   SignedInteger { }
extension DoubleInt.Stdlib: Swift  .SignedInteger where Base:   SignedInteger { }
extension DoubleInt.Stdlib: Swift.UnsignedInteger where Base: UnsignedInteger { }
