//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Strict Unsigned Integer x Complement x Sub Sequence
//*============================================================================*

extension Namespace.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @discardableResult @inlinable package static func formTwosComplementSubSequence(_ base: inout Base, increment: Bool) -> Bool {
        var increment = increment
        
        for index in base.indices {
            increment = base[index].capture({ (~$0).plus(Base.Element(Bit(increment))) })
        }
        
        return increment as Bool
    }
}
