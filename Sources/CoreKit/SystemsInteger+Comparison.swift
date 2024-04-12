//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Systems Integer x Comparison
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func size<Other>(
        relativeTo other: Other.Type
    )   -> (comparison: Signum, ratio: UX) where Other: SystemsInteger {
        //=--------------------------------------=
        Swift.assert(Self .size.count(1) == 1)
        Swift.assert(Other.size.count(1) == 1)
        //=--------------------------------------=
        let lhs = UX(size: Self .self)
        let rhs = UX(size: Other.self)
        let comparison: Signum = lhs.compared(to: rhs)
        return switch comparison {
        case Signum.less: (comparison: comparison, ratio: rhs &>> lhs.count(.ascending(0)))
        case Signum.same: (comparison: comparison, ratio: 1)
        case Signum.more: (comparison: comparison, ratio: lhs &>> rhs.count(.ascending(0)))
        }
    }
}
