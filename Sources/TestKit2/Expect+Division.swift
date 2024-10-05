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

//*============================================================================*
// MARK: * Expect x Division x Data Integer
//*============================================================================*

@inlinable public func Ɣexpect<T>(
    bidirectional dividend: [T],
    division divisor: Nonzero<T>,
    at location: SourceLocation = #_sourceLocation
)   throws where T: SystemsIntegerWhereIsUnsigned {
    //=--------------------------------------=
    var i = dividend
    let o = i.withUnsafeMutableBufferPointer {
        MutableDataInt.Body($0)!.divisionSetQuotientGetRemainder(divisor)
    }
    //=--------------------------------------=
    try Ɣexpect(bidirectional: dividend, division: divisor, is: i, o, at: location)
}

///- Note: It also checks that: `dividend == divisor * quotient + remainder`.
@inlinable public func  Ɣexpect<T>(
    bidirectional dividend: [T],
    division divisor: Nonzero<T>,
    is quotient: [T],
    _  remainder: T,
    at location: SourceLocation = #_sourceLocation
)   throws where T: SystemsIntegerWhereIsUnsigned {
    //=--------------------------------------=
    try #require(dividend.count >= quotient.count, sourceLocation: location)
    //=--------------------------------------=
    let divider21 = Divider21(divisor)
    //=--------------------------------------=
    // reversed: divisor * quotient + remainder
    //=--------------------------------------=
    reversed: do {
        var i = quotient
        let o = i.withUnsafeMutableBufferPointer {
            MutableDataInt.Body($0)!.multiply(by: divisor.value, add: remainder)
        }
        
        if  i.count < dividend.count {
            i.append(o)
            i.append(contentsOf: repeatElement(T.zero, count: dividend.count - i.count))
        }
        
        #expect(i == dividend, "divisor * quotient + remainder", sourceLocation: location)
    }
    //=--------------------------------------=
    // division: remainder
    //=--------------------------------------=
    remainder: do {
        var i = dividend
        let o = i.withUnsafeMutableBufferPointer {
            MutableDataInt.Body($0)!.remainder(divisor)
        }
        
        #expect(i == dividend,  sourceLocation: location)
        #expect(o == remainder, sourceLocation: location)
    }
    //=--------------------------------------=
    // division: quotient and remainder
    //=--------------------------------------=
    division: do {
        var i = dividend
        let o = i.withUnsafeMutableBufferPointer {
            MutableDataInt.Body($0)!.divisionSetQuotientGetRemainder(divisor)
        }
        
        #expect(i == quotient,  sourceLocation: location)
        #expect(o == remainder, sourceLocation: location)
    }
    
    division: do {
        var i = dividend
        let o = i.withUnsafeMutableBufferPointer {
            MutableDataInt.Body($0)!.divisionSetQuotientGetRemainder(divider21)
        }
        
        #expect(i == quotient,  sourceLocation: location)
        #expect(o == remainder, sourceLocation: location)
    }
}
