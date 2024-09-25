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
// MARK: * Expect x Division x Divider
//*============================================================================*

@inlinable public func Ɣexpect<T>(
    _  dividend: T,
    division divider: Divider<T>,
    is expectation: Division<T, T>,
    at location: SourceLocation = #_sourceLocation
)   where T: UnsignedInteger & SystemsInteger {
    
    let quotient: T = expectation.quotient
    #expect(dividend.division(divider) == expectation, "T/division(_:)", sourceLocation: location)
    #expect(dividend.quotient(divider) == quotient,    "T/quotient(_:)", sourceLocation: location)
}


@inlinable public func Ɣexpect<T>(
    _  dividend: Doublet<T>,
    division divider: Divider21<T>,
    is expectation: Fallible<Division<T, T>>,
    at location: SourceLocation = #_sourceLocation
)   where T: UnsignedInteger & SystemsInteger {
    
    let quotient: Fallible<T> = expectation.map({ $0.quotient })
    #expect(divider.division(dividing: dividend) == expectation, "Divider21/division(dividing:)", sourceLocation: location)
    #expect(divider.quotient(dividing: dividend) == quotient,    "Divider21/quotient(dividing:)", sourceLocation: location)
}
