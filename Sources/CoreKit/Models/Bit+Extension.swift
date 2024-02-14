//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit x Extension
//*============================================================================*

extension Bit {
    
    /// A system integer with all bits set to only `0` or only `1`.
    @frozen public struct Extension<Element>: BitCastable, BitOperable, Comparable, Hashable where Element: SystemsInteger {
        
        public typealias Element = Element
        
        public typealias BitPattern = Bit.Extension<Element.Magnitude>
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let element: Element
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
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
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Bit
//=----------------------------------------------------------------------------=

extension Bit.Extension {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(repeating bit: Bit) {
        self.init(unchecked: Element(repeating: bit))
    }
    
    @inlinable public init<T>(repeating other: Bit.Extension<T>) {
        let bitCastOrLoad = T.isSigned || UX(bitWidth: Element.self) <= UX(bitWidth: T.self)
        self.init(unchecked: bitCastOrLoad ? Element.tokenized(bitCastOrLoad: other.element) : Element(repeating: other.bit))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Comparison
//=----------------------------------------------------------------------------=

extension Bit.Extension {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func compared(to other: Self) -> Signum {
        self.element.compared(to: other.element)
    }
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.element == rhs.element
    }
    
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.element <  rhs.element
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Logic
//=----------------------------------------------------------------------------=

extension Bit.Extension {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: consuming Self) -> Self {
        Self(unchecked: ~instance.element)
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        Self(unchecked: lhs.element & rhs.element)
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        Self(unchecked: lhs.element | rhs.element)
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        Self(unchecked: lhs.element | rhs.element)
    }
}
