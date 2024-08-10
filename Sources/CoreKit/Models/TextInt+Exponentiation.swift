//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Text Int x Exponentiation
//*============================================================================*

extension TextInt {
    
    @frozen @usableFromInline package struct Exponentiation {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let power: UX
        public let exponent: IX
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ radix: UX) throws {
            if  radix < 2 {
                throw Error.invalid
            }
            
            var power = radix as UX
            var exponent = 01 as IX
            
            while true {
                let next = power.multiplication(radix)
                
                if  next.high.isZero || (next.high == 1 && next.low.isZero) {
                    power = next.low
                    exponent &+= 1
                }
                
                guard next.high.isZero else { break }
            }
            
            self.power    = power
            self.exponent = exponent
        }
    }
}
