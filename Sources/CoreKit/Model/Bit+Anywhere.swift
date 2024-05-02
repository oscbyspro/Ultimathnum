//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit x Anywhere
//*============================================================================*

extension Bit {
    
    //*========================================================================*
    // MARK: * Anywhere
    //*========================================================================*

    @frozen public struct Anywhere<Target>: BitSelection where Target: BitCountable {
                
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let bit: Bit
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ bit: Bit) {
            self.bit = bit
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func count(in source: borrowing Target) -> Target.BitCount {
            source.count(self.bit, where: Self.self)
        }
    }
}
