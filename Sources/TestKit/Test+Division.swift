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
    
    #warning("...")
    public func division<T>(
        _ dividend:  T,
        _ divisor:   T,
        _ quotient:  T,
        _ remainder: T,
        _ error: Bool = false,
        _ id: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        
        let division = Division(quotient: quotient, remainder: remainder)
        self.division(dividend, divisor, Fallible(division, error: error))
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
        
        guard let divisor = Divisor(divisor) else {
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
            #warning("...")
            //same(dividend.quotient(Fallible(divisor)),           expectation)
            same(Fallible(dividend, error: false).quotient(divisor), expectation)
            same(Fallible(dividend, error: true ).quotient(divisor), expectation.combine(true))
            //same(Fallible(dividend).quotient(Fallible(divisor)), expectation)
        }
        
        remainder: do {
            let expectation = expectation.value.remainder
            same(dividend.remainder(divisor), expectation)
            #warning("...")
            //same(dividend.remainder(Fallible(divisor)),           expectation)
            same(Fallible(dividend, error: false).remainder(divisor), Fallible(expectation, error: false))
            same(Fallible(dividend, error: true ).remainder(divisor), Fallible(expectation, error: true ))
            //same(Fallible(dividend).remainder(Fallible(divisor)), expectation)
        }
        
        division: do {
            same(dividend.division(divisor), expectation)
            #warning("...")
            //same(dividend.division(Fallible(divisor)),           expectation)
            same(Fallible(dividend, error: false).division(divisor), expectation)
            same(Fallible(dividend, error: true ).division(divisor), expectation.combine(true))
            //same(Fallible(dividend).division(Fallible(divisor)), expectation)
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
    
    #warning("TODO")
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
        
        guard let divisor = Divisor(divisor) else {
            return none(expectation, "division by zero is undefined [1]")
        }
        //=--------------------------------------=
        //=--------------------------------------=
        let result = T.division(dividend, by: divisor)
        //=--------------------------------------=
        // TODO: Doublet plus(_:) minus(_:)
        //=--------------------------------------=
        if !expectation.error {
            // TODO: reverse engineer the dividend
        }
        //=--------------------------------------=
        same(result, expectation)
    }
}
