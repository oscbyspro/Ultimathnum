//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit x Selection
//*============================================================================*
        
extension Bit {
    
    /// Some selection options for the bits in a binary integer.
    ///
    /// ```swift
    /// I64.min.count(0, where:   .anywhere) // 64
    /// I64.min.count(0, where:  .ascending) // 63
    /// I64.min.count(1, where: .descending) // 01
    /// ```
    ///
    @frozen public enum Selection {
        
        case anywhere
        
        case ascending
        
        case descending
        
        //*====================================================================*
        // MARK: * Body
        //*====================================================================*
        
        @frozen public enum Body {
            
            case bit
            
            case each(Bit)
            
            case ascending(Bit)
            
            case nonascending(Bit)
            
            case descending(Bit)
            
            case nondescending(Bit)
        }
        
        //*====================================================================*
        // MARK: * Integer
        //*====================================================================*
        
        @frozen public enum Integer {
            
            case bit
            
            case each(Bit)
            
            case ascending(Bit)
            
            case nonascending(Bit)
            
            case descending(Bit)
            
            case nondescending(Bit)
            
            case appendix
            
            case nonappendix
        }
    }
}
