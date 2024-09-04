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
        
        case lowercase
        
        case uppercase
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(uppercase: Bool) {
            self = switch uppercase {
            case  true: Self.uppercase
            case false: Self.lowercase
            }
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        /// The ASCII value of `"A"` or `"a"`.
        @inlinable package var start: U8 {
            switch self {
            case Self.lowercase: return 97
            case Self.uppercase: return 65
            }
        }
    }
}
