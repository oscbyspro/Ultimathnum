//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Bit
//*============================================================================*

@frozen public struct UMNBit: Hashable, ExpressibleByIntegerLiteral {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Bool) {
        self.base = base
    }
    
    @inlinable public init(integerLiteral: UInt.IntegerLiteralType) {
        if  integerLiteral == 0 {
            self.base = false
        }   else if integerLiteral == 1 {
            self.base = true
        }   else {
            fatalError(UMN.callsiteOverflowInfo())
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Logic
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(operand: Self) -> Self {
        operand ^ 1
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        lhs == rhs ? lhs : 0
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        lhs == 0 ? rhs : lhs
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        lhs == rhs ? 0 : 1
    }
    
    //*========================================================================*
    // MARK: * Selection
    //*========================================================================*
    
    @frozen public enum Selection {
        case all
        case ascending
        case descending
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension Bool {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializes
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ bit: UMNBit) {
        self = bit.base
    }
}
