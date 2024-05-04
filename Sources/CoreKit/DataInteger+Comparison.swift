//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Integer x Comparison x Body
//*============================================================================*

extension BodyInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var isZero: Bool {
        self.buffer().allSatisfy({ $0 == Element.zero })
    }
    
    @inlinable public func compared(to other: some BodyInteger<Element>) -> Signum {
        DataInt.compare(
            lhs: DataInt(self),
            lhsIsSigned: false,
            rhs: DataInt(other),
            rhsIsSigned: false
        )
    }
}
