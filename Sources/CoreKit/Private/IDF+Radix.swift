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
    
    @frozen public struct Radix {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let exponent: IX
        public let power:    UX
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init() {
            var exponent = 01 as IX
            var power = 00010 as UX
            
            while let next = try? power.times(10) {
                exponent = exponent &+ 01; power = next
            }
            
            self.exponent = exponent; self.power = power
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable public var base: UX {
            10
        }
        
        @inlinable public func divisibilityByPowerUpperBound(magnitude: some Collection<UX>) -> IX {
            IX(magnitude.count) * UX.bitWidth.load(as: IX.self) / base.count(0, option: .descending).load(as: IX.self) + 1
        }
    }
}
