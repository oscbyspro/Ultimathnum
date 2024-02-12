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
    
    @inlinable public init(bitPattern: Bool) {
        self.bitPattern = bitPattern
    }

    @inlinable public init(integerLiteral: Swift.Int.IntegerLiteralType) {
        if  integerLiteral == 0 {
            self.bitPattern = false
        }   else if integerLiteral == 1 {
            self.bitPattern = true
        }   else {
            fatalError(.overflow())
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: consuming Self) -> Self {
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

//*============================================================================*
// MARK: * Bit x Extension
//*============================================================================*

extension Bit {
    
    /// A system integer with its bits set to only `0` or only `1`.
    ///
    /// - Note: It's a nice compile-time gurantee for something rather common.
    ///
    @frozen public struct Extension<Element>: BitCastable, Comparable, Hashable where Element: SystemsInteger {
        
        public typealias Element = Element
        
        public typealias BitPattern = Bit.Extension<Element.Magnitude>
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let element: Element
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(repeating bit: Bit) {
            self.init(unchecked: Element(repeating: bit))
        }
        
        @inlinable public init(bitPattern: consuming BitPattern) {
            self.init(unchecked: Element(bitPattern: bitPattern.element))
        }
        
        @inlinable internal init(unchecked element: Element) {
            Swift.assert(element.count(1, option: .all) % Element.bitWidth == 0)
            Swift.assert(element.count(0, option: .all) % Element.bitWidth == 0)
            self.element = element
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var bit: Bit {
            Bit(bitPattern: self.element != 0)
        }
        
        @inlinable public var bitPattern: BitPattern {
            consuming get {
                BitPattern(unchecked: BitPattern.Element(bitPattern: self.element))
            }
        }
        
        @inlinable public static func <(lhs: Self, rhs: Self) -> Bool {
            lhs.element < rhs.element
        }
    }
}

//*============================================================================*
// MARK: * Bit x Selection
//*============================================================================*

extension Bit {
    
    
    /// Some selection options for bits in a binary integer.
    ///
    /// ```swift
    /// I64.min.count(0, option: .ascending) // 63
    /// ```
    ///
    @frozen public enum Selection {
        case all
        case ascending
        case descending
    }
}
