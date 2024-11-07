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
// MARK: * Expect x Division x Binary Integer
//*============================================================================*

@inlinable public func Ɣexpect<T>(
    bidirectional dividend: T,
    by divisor:  T,
    at location: SourceLocation = #_sourceLocation
)   where T: BinaryInteger {
    
    let division = Nonzero(exactly: divisor).flatMap {
        dividend.division($0)
    }
    
    Ɣexpect(bidirectional: dividend, by: divisor, is: division)
}

@inlinable public func Ɣexpect<T>(
    bidirectional dividend: T,
    by divisor:  T,
    is division: Optional<Fallible<Division<T, T>>>,
    at location: SourceLocation = #_sourceLocation
)   where T: BinaryInteger {
    
    if  let  division, let  divisor = Nonzero(exactly: divisor) {
        Ɣexpect(bidirectional: dividend, by: divisor, is: division, at: location)
    }   else {
        #expect(division == nil,                        sourceLocation: location)
        #expect(dividend.isInfinite || divisor.isZero,  sourceLocation: location)
    }
}

@inlinable public func Ɣexpect<T>(
    bidirectional dividend: T,
    by divisor:  Nonzero<T>,
    is division: Fallible<Division<T, T>>,
    at location: SourceLocation = #_sourceLocation
)   where T: BinaryInteger {
    //=------------------------------------------=
    let quotient  = division.map(\.quotient)
    let remainder = division.value.remainder
    let product   = division.value.quotient.times(divisor.value).value
    //=------------------------------------------=
    always: do {
        #expect(dividend.division (divisor) == division,  "BinaryInteger/division(_:)",  sourceLocation: location)
        #expect(dividend.quotient (divisor) == quotient,  "BinaryInteger/quotient(_:)",  sourceLocation: location)
        #expect(dividend.remainder(divisor) == remainder, "BinaryInteger/remainder(_:)", sourceLocation: location)
    }
    
    if !division.error {
        #expect((dividend / divisor.value) == quotient.value, "BinaryInteger./(_:_:)", sourceLocation: location)
        #expect((dividend % divisor.value) == remainder,      "BinaryInteger.%(_:_:)", sourceLocation: location)
        
        #expect({ var x = dividend; x /= divisor.value; return x }() == quotient.value, "BinaryInteger./=(_:_:)", sourceLocation: location)
        #expect({ var x = dividend; x %= divisor.value; return x }() == remainder,      "BinaryInteger.%=(_:_:)", sourceLocation: location)
    }
            
    invariant: do {
        let lhs = dividend
        let rhs = product.plus(remainder).value
        #expect(lhs == rhs, "dividend == divisor * quotient + remainder [low]", sourceLocation: location)
    }
    
    invariant: do {
        let lhs = dividend.minus(remainder).value
        let rhs = product
        #expect(lhs == rhs, "dividend - remainder == divisor * quotient [low]", sourceLocation: location)
    }
}

@inlinable public func Ɣexpect<T>(
    bidirectional dividend: Doublet<T>,
    by divisor:  T,
    at location: SourceLocation = #_sourceLocation
)   where T: SystemsInteger {
    
    let division = Nonzero(exactly: divisor).map {
        T.division(dividend, by: $0)
    }
    
    Ɣexpect(bidirectional: dividend, by: divisor, is: division)
}

@inlinable public func Ɣexpect<T>(
    bidirectional dividend: Doublet<T>,
    by divisor:  T,
    is division: Optional<Fallible<Division<T, T>>>,
    at location: SourceLocation = #_sourceLocation
)   where T: SystemsInteger {
    
    if  let  division, let  divisor = Nonzero(exactly: divisor) {
        Ɣexpect(bidirectional: dividend, by: divisor, is: division)
    }   else {
        #expect(divisor.isZero,  sourceLocation: location)
        #expect(division == nil, sourceLocation: location)
    }
}

@inlinable public func Ɣexpect<T>(
    bidirectional dividend: Doublet<T>,
    by divisor:  Nonzero<T>,
    is division: Fallible<Division<T, T>>,
    at location: SourceLocation = #_sourceLocation
)   where T: SystemsInteger {
    //=------------------------------------------=
    let product = division.value.quotient.multiplication(divisor.value)
    //=------------------------------------------=
    #expect(T.division(dividend, by: divisor) == division, "BinaryInteger.division(_:by:)", sourceLocation: location)
    
    invariant: do {
        let lhs = Fallible(dividend)
        var rhs = Fallible(product)
        (rhs.value.low,  rhs.error) = rhs.value.low .plus(T.Magnitude.init(raw: division.value.remainder), plus: rhs.error).components()
        (rhs.value.high, rhs.error) = rhs.value.high.plus(T(repeating: division.value.remainder.appendix), plus: rhs.error).components()
        #expect(lhs.value.low  == rhs.value.low,  "dividend == divisor * quotient + remainder [low]",  sourceLocation: location)
        guard !division.error else { break invariant }
        #expect(lhs.value.high == rhs.value.high, "dividend == divisor * quotient + remainder [high]", sourceLocation: location)
    }
    
    invariant: do {
        var lhs = Fallible(dividend)
        let rhs = Fallible(product)
        (lhs.value.low,  lhs.error) = lhs.value.low .minus(T.Magnitude.init(raw: division.value.remainder), plus: lhs.error).components()
        (lhs.value.high, lhs.error) = lhs.value.high.minus(T(repeating: division.value.remainder.appendix), plus: lhs.error).components()
        #expect(lhs.value.low  == rhs.value.low,  "dividend - remainder == divisor * quotient [low]",  sourceLocation: location)
        guard !division.error else { break invariant }
        #expect(lhs.value.high == rhs.value.high, "dividend - remainder == divisor * quotient [high]", sourceLocation: location)
    }
}

//*============================================================================*
// MARK: * Expect x Division x Data Integer
//*============================================================================*

@inlinable public func Ɣexpect<Element>(
    _  dividend: [Element],
    division divisor: Nonzero<Element>,
    is quotient: [Element],
    and remainder: Element,
    at location: SourceLocation = #_sourceLocation
)   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
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
