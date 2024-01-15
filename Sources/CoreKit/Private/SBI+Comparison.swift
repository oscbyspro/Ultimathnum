//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Strict Binary Integer x Comparison x Sub Sequence
//*============================================================================*

extension Namespace.StrictBinaryInteger.SubSequence {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func isLessThanZero(_ base: Base, isSigned: Bool) -> Bool {
        isSigned && base.last.map({ $0 & Base.Element.msb != Base.Element() }) == true
    }
}
