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
)   where T: SystemsIntegerWhereIsUnsigned {
    
    let quotient: T = expectation.quotient
    #expect(dividend.division(divider) == expectation, "T/division(_:)", sourceLocation: location)
    #expect(dividend.quotient(divider) == quotient,    "T/quotient(_:)", sourceLocation: location)
}

@inlinable public func Ɣexpect<T>(
    _  dividend: Doublet<T>,
    division divider: Divider21<T>,
    is expectation: Fallible<Division<T, T>>,
    at location: SourceLocation = #_sourceLocation
)   where T: SystemsIntegerWhereIsUnsigned {
    
    let quotient: Fallible<T> = expectation.map({ $0.quotient })
    #expect(divider.division(dividing: dividend) == expectation, "Divider21/division(dividing:)", sourceLocation: location)
    #expect(divider.quotient(dividing: dividend) == quotient,    "Divider21/quotient(dividing:)", sourceLocation: location)
}

//*============================================================================*
// MARK: * Expect x Division x Data Integer
//*============================================================================*

@inlinable public func Ɣexpect<T>(
    _  dividend: [T],
    division divisor: Nonzero<T>,
    is quotient: [T],
    and remainder: T,
    at location: SourceLocation = #_sourceLocation
)   throws where T: SystemsIntegerWhereIsUnsigned {
    //=--------------------------------------=
    try #require(dividend.count >= quotient.count, sourceLocation: location)
    //=--------------------------------------=
    let divider21 = Divider21(divisor)
    //=--------------------------------------=
    // division: 1-by-1
    //=--------------------------------------=
    if  dividend.count == 1 {
        let expectation: Division = dividend.first!.division(divisor)
        #expect([expectation.quotient ] == quotient,  "BinaryInteger/division(_:)", sourceLocation: location)
        #expect((expectation.remainder) == remainder, "BinaryInteger/division(_:)", sourceLocation: location)
    }
    //=--------------------------------------=
    // division: remainder
    //=--------------------------------------=
    remainder: do {
        var i = dividend
        let o = i.withUnsafeMutableBinaryIntegerBody {
            $0.remainder(divisor)
        }
        
        #expect(i == dividend,  "DataInt/remainder(_:)", sourceLocation: location)
        #expect(o == remainder, "DataInt/remainder(_:)", sourceLocation: location)
    }
    
    remainder: do {
        var i = dividend
        let o = i.withUnsafeMutableBinaryIntegerBody {
            $0.remainder(divider21)
        }
        
        #expect(i == dividend,  "DataInt/remainder(_:) - Divider21", sourceLocation: location)
        #expect(o == remainder, "DataInt/remainder(_:) - Divider21", sourceLocation: location)
    }
    //=--------------------------------------=
    // division: quotient and remainder
    //=--------------------------------------=
    division: do {
        var i = dividend
        let o = i.withUnsafeMutableBinaryIntegerBody {
            $0.divisionSetQuotientGetRemainder(divisor)
        }
        
        #expect(i == quotient,  "DataInt/divisionSetQuotientGetRemainder(_:)", sourceLocation: location)
        #expect(o == remainder, "DataInt/divisionSetQuotientGetRemainder(_:)", sourceLocation: location)
    }
    
    division: do {
        var i = dividend
        let o = i.withUnsafeMutableBinaryIntegerBody {
            $0.divisionSetQuotientGetRemainder(divider21)
        }
        
        #expect(i == quotient,  "DataInt/divisionSetQuotientGetRemainder(_:) - Divider21", sourceLocation: location)
        #expect(o == remainder, "DataInt/divisionSetQuotientGetRemainder(_:) - Divider21", sourceLocation: location)
    }
}
