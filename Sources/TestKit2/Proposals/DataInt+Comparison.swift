//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Data Int x Comparison
//*============================================================================*

extension DataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Performs a three-way comparson of `lhs` versus `rhs` where the mode
    /// of each instance is determined by `lhsSignedness` and `rhsSignedness`.
    @inlinable public static func compare<OtherElement>(
        lhs: consuming Self, mode lhsSignedness: Signedness,
        rhs: consuming DataInt<OtherElement>, mode rhsSignedness: Signedness
    )   -> Signum {
        
        if  Self.Element.size <= OtherElement.size {
            rhs.reinterpret(as:  Self.Element.self) { rhs in
                DataInt<Self.Element>.compare(
                    lhs: lhs, mode: lhsSignedness,
                    rhs: rhs, mode: rhsSignedness
                )
            }
            
        }   else {
            lhs.reinterpret(as:  OtherElement.self) { lhs in
                DataInt<OtherElement>.compare(
                    lhs: lhs, mode: lhsSignedness,
                    rhs: rhs, mode: rhsSignedness
                )
            }
        }
    }
}
