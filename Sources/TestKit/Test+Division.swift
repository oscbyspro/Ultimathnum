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
        let division = Division(quotient: quotient, remainder: remainder)
        let expectation = Fallible(division, error: error)
        self.division(dividend, divisor, expectation)
    }
    
    public func division<T>(
        _ dividend: T, 
        _ divisor:  T,
        _ expectation: Fallible<Division<T, T>>,
        _ id: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        
        checkSameSizeInverseInvariant: do {
            let reversed = expectation.map({ $0.quotient &* divisor &+ $0.remainder }).value
            same(dividend, reversed, "dividend != divisor &* quotient &+ remainder")
        }
        
        if !expectation.error {
            same(dividend / divisor, expectation.value.quotient )
            same(dividend % divisor, expectation.value.remainder)
        }
        
        if !expectation.error {
            same({ var x = dividend; x /= divisor; return x }(), expectation.value.quotient )
            same({ var x = dividend; x %= divisor; return x }(), expectation.value.remainder)
        }
        
        if !expectation.error {
            same({ var x = dividend; x /= divisor; return x }(), expectation.value.quotient )
            same({ var x = dividend; x %= divisor; return x }(), expectation.value.remainder)
        }
        
        quotient: do {
            let expectation = expectation.map(\.quotient)
            same(dividend.quotient(divisor),                     expectation)
            same(dividend.quotient(Fallible(divisor)),           expectation)
            same(Fallible(dividend).quotient(divisor),           expectation)
            same(Fallible(dividend).quotient(Fallible(divisor)), expectation)
        }
        
        remainder: do {
            let expectation = expectation.map(\.remainder)
            same(dividend.remainder(divisor),                     expectation)
            same(dividend.remainder(Fallible(divisor)),           expectation)
            same(Fallible(dividend).remainder(divisor),           expectation)
            same(Fallible(dividend).remainder(Fallible(divisor)), expectation)
        }
        
        division: do {
            same(dividend.division(divisor),                     expectation)
            same(dividend.division(Fallible(divisor)),           expectation)
            same(Fallible(dividend).division(divisor),           expectation)
            same(Fallible(dividend).division(Fallible(divisor)), expectation)
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
        _ expectation: Fallible<Division<T, T>>,
        _ id: BinaryIntegerID = .init()
    )   where T: SystemsInteger {
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
