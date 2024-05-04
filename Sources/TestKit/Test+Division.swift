//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import XCTest

//*============================================================================*
// MARK: * Test x Division
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func division<T>(
        _ dividend:  T,
        _ divisor:   T,
        _ quotient:  T,
        _ remainder: T,
        _ error: Bool = false,
        _ id: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        
        let expctation = Fallible(quotient: quotient, remainder: remainder, error: error)
        self.division(dividend, divisor, expctation)
    }
    
    public func division<T>(
        _ dividend: T, 
        _ divisor:  T,
        _ expectation: Fallible<Division<T, T>>?,
        _ id: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        //=--------------------------------------=
        guard let expectation else {
            return same(divisor, 0,  "division by zero is undefined [0]")
        }
        
        guard let divisor = Divisor(exactly: divisor) else {
            return none(expectation, "division by zero is undefined [1]")
        }
        //=--------------------------------------=
        checkSameSizeInverseInvariant: do {
            let reversed = expectation.map({ $0.quotient &* divisor.value &+ $0.remainder }).value
            same(dividend, reversed, "dividend != divisor &* quotient &+ remainder")
        }
        
        quotient: if !expectation.error {
            same(dividend / divisor.value, expectation.value.quotient)
            same({ var x = dividend; x /= divisor.value; return x }(), expectation.value.quotient)
        }
        
        remainder: do {
            same(dividend % divisor.value, expectation.value.remainder)
            same({ var x = dividend; x %= divisor.value; return x }(), expectation.value.remainder)
        }
        
        quotient: do {
            let expectation = expectation.map(\.quotient)
            same(dividend.quotient(divisor), expectation)
            same(Fallible(dividend, error: false).quotient(divisor), expectation)
            same(Fallible(dividend, error: true ).quotient(divisor), expectation.invalidated(true))
        }
        
        remainder: do {
            let expectation = expectation.value.remainder
            same(dividend.remainder(divisor), expectation)
            same(Fallible(dividend, error: false).remainder(divisor), Fallible(expectation, error: false))
            same(Fallible(dividend, error: true ).remainder(divisor), Fallible(expectation, error: true ))
        }
        
        division: do {
            same(dividend.division(divisor), expectation)
            same(Fallible(dividend, error: false).division(divisor), expectation)
            same(Fallible(dividend, error: true ).division(divisor), expectation.invalidated(true))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + 2 vs 1
//=----------------------------------------------------------------------------=

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func division<T>(
        _ dividend: Doublet<T>, 
        _ divisor: T,
        _ expectation: Fallible<Division<T, T>>?,
        _ id: BinaryIntegerID = .init()
    )   where T: SystemsInteger {
        //=--------------------------------------=
        guard let expectation else {
            return same(divisor, 0,  "division by zero is undefined [0]")
        }
        
        guard let divisor = Divisor(exactly: divisor) else {
            return none(expectation, "division by zero is undefined [1]")
        }
        //=--------------------------------------=
        let result = T.division(dividend, by: divisor)
        //=--------------------------------------=
        recover: if !expectation.error {
            var bit = false
            var reversed = expectation.value.quotient.multiplication(divisor.value)
            bit = reversed.low [{ $0.plus(T.Magnitude.init(raw: expectation.value.remainder), plus: bit) }]
            bit = reversed.high[{ $0.plus(T(repeating: expectation.value.remainder.appendix), plus: bit) }]
            same(bit,      false,    "dividend != divisor * quotient + remainder [0]")
            same(dividend, reversed, "dividend != divisor * quotient + remainder [1]")
        }
        //=--------------------------------------=
        same(result, expectation, "2 by 1 division")
    }
}
