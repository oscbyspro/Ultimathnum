//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit
//*============================================================================*

/// ### Development
///
/// - TODO: Consider BitPattern as Bool.
///
@frozen public struct Bit: BitCastable, BitOperable, Comparable,
Hashable, ExpressibleByIntegerLiteral, Sendable {
    
    public typealias BitPattern = Self
    
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
    
    @inlinable public init(integerLiteral: UX.IntegerLiteralType) {
        if  integerLiteral == 0 {
            self.base = false
        }   else if integerLiteral == 1 {
            self.base = true
        }   else {
            fatalError(.overflow())
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: Self) -> Self {
        instance ^ 1
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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func compared(to other: Self) -> Signum {
        self == other ? 0 : self < other ? -1 : 1
    }
    
    @inlinable public static func <(lhs: Self, rhs: Self) -> Bool {
        (lhs, rhs) == (0, 1)
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
    
    @inlinable public init(_ bit: Bit) {
        self = bit.base
    }
}
