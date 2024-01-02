//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x UMNSign
//*============================================================================*

@frozen public enum UMNSign: Hashable, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    case plus
    case minus
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ bit: Bool) {
        self = bit ? Self.minus : Self.plus
    }
    
    @inlinable public init(_ stdlib: FloatingPointSign) {
        self.init(stdlib == FloatingPointSign.minus)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func toggled() -> Self {
        self ^ Self.minus
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        lhs == rhs ? lhs : Self.plus
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        lhs == Self.plus ? rhs : lhs
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        lhs == rhs ? Self.plus : Self.minus
    }
}
