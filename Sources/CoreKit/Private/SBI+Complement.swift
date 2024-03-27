//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Strict Binary Integer x Complement x Sub Sequence
//*============================================================================*

extension Namespace.StrictBinaryInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable package static func formOnesComplement(_ base: inout Base) {
        for index in base.indices {
            base[index] = ~base[index]
        }
    }
    
    @inlinable package static func formTwosComplement(_ base: inout Base) {
        Unsigned.formTwosComplementSubSequence(&base, increment: true)
    }
}
