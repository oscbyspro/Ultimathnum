//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit x Entropy
//*============================================================================*

extension Bit {
    
    //*========================================================================*
    // MARK: * Entropy
    //*========================================================================*

    @frozen public struct Entropy<Target>: BitSelection where Target: BitCountable {
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init() {
            
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func count(in source: borrowing Target) -> Target.BitCount {
            Nonappendix().count(in: source).incremented().assert()
        }
    }
}
