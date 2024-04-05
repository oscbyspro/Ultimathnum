//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit
//*============================================================================*

@frozen public struct Bit: BitCastable, BitOperable, Comparable, Hashable, ExpressibleByIntegerLiteral {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    /// A bit set to `0`.
    ///
    /// - Note: A bit can only bet set to `0` or `1`.
    ///
    public static let zero = 0 as Self
    
    
    /// A bit set to `1`.
    ///
    /// - Note: A bit can only bet set to `0` or `1`.
    ///
    public static let one  = 1 as Self
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let bitPattern: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_  source: Sign) {
        self.init(bitPattern: source)
    }
    
    @inlinable public init(_  source: FloatingPointSign) {
        self.init(bitPattern: source)
    }
    
    @inlinable public init(_  source: Bool) {
        self.init(bitPattern: source)
    }
    
    @inlinable public init(bitPattern: Bool) {
        self.bitPattern = (bitPattern)
    }
    
    @inlinable public init(integerLiteral: Swift.Int.IntegerLiteralType) {
        if  integerLiteral == 0 {
            self.init(false)
        }   else if integerLiteral == 1 {
            self.init(true )
        }   else {
            preconditionFailure(String.overflow())
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: Self) -> Self {
        Self(bitPattern: !instance.bitPattern)
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        Self(bitPattern: lhs.bitPattern == rhs.bitPattern ? lhs.bitPattern : false)
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        Self(bitPattern: lhs.bitPattern == rhs.bitPattern ? lhs.bitPattern : true )
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        Self(bitPattern: lhs.bitPattern != rhs.bitPattern)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func compared(to other: Self) -> Signum {
        self == other ? 0 : self == 0 ? -1 : 1
    }
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.bitPattern == rhs.bitPattern
    }
    
    @inlinable public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        (lhs.bitPattern, rhs.bitPattern) == (false, true)
    }
}
