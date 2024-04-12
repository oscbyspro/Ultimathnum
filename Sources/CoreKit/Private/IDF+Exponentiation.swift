//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Integer Description Format x Exponentiation
//*============================================================================*

extension Namespace.IntegerDescriptionFormat {
    
    @frozen public struct Exponentiation {
        
        //=------------------------------------------------------------------------=
        // MARK: State
        //=------------------------------------------------------------------------=
        
        public let exponent: IX
        public let power: UX
        
        //=------------------------------------------------------------------------=
        // MARK: Initializers
        //=------------------------------------------------------------------------=
        
        @inlinable public init() {
            var exponent = 01 as IX
            var power = 00010 as UX
            
            while let next = power.times(10).optional() {
                exponent &+= 1
                power = next
            }
            
            self.exponent = exponent
            self.power = power
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable public var base: UX {
            10
        }
        
        @inlinable public func divisibilityByPowerUpperBound(magnitude: some Collection<UX>) -> IX {
            IX(magnitude.count) * IX(bitPattern: UX.size / self.base.count(.descending(0))) + 1
        }
    }
}
