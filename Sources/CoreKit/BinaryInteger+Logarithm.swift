//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Logarithm x Development
//*============================================================================*

extension Nonzero where Value: SystemsInteger & UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - TODO: Make something like this public.
    ///
    @inlinable internal borrowing func log2() -> Count<IX> {
        let mask = UX(raw: Value.size).minus(1).unchecked()
        let dzbc = UX(raw: self.value.descending(Bit.zero))
        return Count.init(raw: mask.minus(dzbc).unchecked())
    }
}
