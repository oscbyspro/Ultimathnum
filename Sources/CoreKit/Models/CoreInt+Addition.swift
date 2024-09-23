//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Addition
//*============================================================================*

extension CoreInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func plus(_ other: Self) -> Fallible<Self> {
        let result = self.stdlib().addingReportingOverflow(other.stdlib())
        return Self(result.partialValue).veto(result.overflow)
    }
    
    @inlinable public func minus(_ other: Self) -> Fallible<Self> {
        let result = self.stdlib().subtractingReportingOverflow(other.stdlib())
        return Self(result.partialValue).veto(result.overflow)
    }
}
