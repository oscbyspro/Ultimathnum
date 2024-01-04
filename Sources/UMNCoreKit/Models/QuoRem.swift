//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Quo(tient) Rem(ainder)
//*============================================================================*

@frozen public struct QuoRem<Quotient, Remainder> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let quotient:  Quotient
    public let remainder: Remainder
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(quotient: Quotient, remainder: Remainder) {
        self.quotient  = quotient
        self.remainder = remainder
    }
}
