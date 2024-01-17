//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Integer Description Format x Radix
//*============================================================================*

extension Namespace.IntegerDescriptionFormat {
    
    @frozen public struct Radix<Element> where Element: SystemInteger & UnsignedInteger, Element.BitPattern == Word.BitPattern {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let exponent: Element
        public let power:    Element
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init() {
            var exponent = 01 as Element
            var power = 00010 as Element
            
            while let next = try? power.times(10) {
                exponent = exponent &+ 01; power = next
            }
            
            self.exponent = exponent; self.power = power
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable public var base: Element {
            10
        }
        
        @inlinable public func divisibilityByPowerUpperBound(magnitude: some Collection<Element>) -> Int {
            magnitude.count * Element.bitWidth.load(as: Int.self) / base.load(as: Int.self).leadingZeroBitCount &+ 1
        }
    }
}
