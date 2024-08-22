//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Text Int x Letters
//*============================================================================*

extension TextInt {
    
    /// A `lowercase` or `uppercase` indicator.
    @frozen public enum Letters: Equatable, Sendable {
        
        case uppercase
        
        case lowercase
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension TextInt.Letters {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable var start: U8 {
        switch self {
        case .uppercase: return 65
        case .lowercase: return 97
        }
    }
}
