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
    // MARK: * Appendix
    //*========================================================================*

    @frozen public struct Appendix<Target>: BitSelection where Target: BitCountable {
                
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init() {
            
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func count(in source: borrowing Target) -> Target.BitCount {
            Descending((copy source).appendix).count(in: source)
        }
    }

    //*========================================================================*
    // MARK: * Nonappendix
    //*========================================================================*

    @frozen public struct Nonappendix<Target>: BitSelection where Target: BitCountable {
                
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init() {
            
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func count(in source: borrowing Target) -> Target.BitCount {
            Nondescending<Target>((copy source).appendix).count(in: source)
        }
    }
}
