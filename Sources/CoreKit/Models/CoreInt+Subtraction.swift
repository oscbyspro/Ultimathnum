//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Subtraction
//*============================================================================*

extension CoreInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> Fallible<Self> {
        let result = (~self).plus(1) as Fallible<Self>
        return Fallible(result.value, error: result.error == Self.isSigned)
    }
    
    @inlinable public consuming func minus(_ decrement: borrowing Self) -> Fallible<Self> {
        let result = self.base.subtractingReportingOverflow(decrement.base)
        return Fallible(Self(result.partialValue), error: result.overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
        
    @inlinable public consuming func minus(_ increment: borrowing Self, carrying error: consuming Bool) -> Fallible<Self> {
        let a = self.base.subtractingReportingOverflow(increment.base)
        let b = a.partialValue.subtractingReportingOverflow(Self(Bit(bitPattern: error)).base)
        return Fallible(Self(b.partialValue), error: a.overflow != b.overflow)
    }
}
