//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit x Extension
//*============================================================================*
    
/// A system integer with all bits set to only `0` or only `1`.
@frozen public struct BitExtension<Element>: BitCastable, BitOperable, Comparable, Hashable where Element: SystemsInteger {
    
    public typealias Element = Element
    
    public typealias BitPattern = BitExtension<Element.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    public let element: Element
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init(bitPattern: consuming BitPattern) {
        self.init(unchecked: Element(bitPattern: bitPattern.element))
    }
    
    @inlinable internal init(unchecked element: consuming Element) {
        Swift.assert(element.count(1, option: .all) % Element.bitWidth == 0)
        Swift.assert(element.count(0, option: .all) % Element.bitWidth == 0)
        self.element = element
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable public var bit: Bit {
        Bit(bitPattern: self.element != 0)
    }
    
    @inlinable public var bitPattern: BitPattern {
        consuming get {
            BitPattern(unchecked: BitPattern.Element(bitPattern: self.element))
        }
    }
}
