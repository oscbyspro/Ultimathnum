//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Sign
//*============================================================================*

@frozen public enum Sign: BitCastable, BitOperable, Hashable, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    case plus
    case minus
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_  source: Bit) {
        self.init(bitPattern: source)
    }
    
    @inlinable public init(_  source: Bool) {
        self.init(bitPattern: source)
    }
    
    @inlinable public init(_  source: FloatingPointSign) {
        self.init(bitPattern: source)
    }
    
    @inlinable public init(bitPattern: Bool) {
        self = bitPattern ? Self.minus : Self.plus
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public var bitPattern: Bool {
        self == Self.minus
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: Self) -> Self {
        instance ^ minus
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        lhs == rhs ? lhs : plus
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        lhs == plus ? rhs : lhs
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        lhs == rhs ? plus : minus
    }
}
