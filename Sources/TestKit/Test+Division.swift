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
        self.division(dividend, divisor,  division.veto(error))
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
        quotient: if !expectation.error {
            same(dividend / divisor.value, expectation.value.quotient)
            same({ var x = dividend; x /= divisor.value; return x }(), expectation.value.quotient)
        }
        
        remainder: do {
            same(dividend % divisor.value, expectation.value.remainder)
            same({ var x = dividend; x %= divisor.value; return x }(), expectation.value.remainder)
        }
        
        quotient: do {
            same(dividend.quotient (divisor), expectation.map(\.quotient))
        }
        
        remainder: do {
            same(dividend.remainder(divisor), expectation.value.remainder)
        }
        
        division: do {
            same(dividend.division (divisor), expectation)
        }
        
        invariant: do {
            let (lhs) = dividend
            let (rhs) = expectation.map({ divisor.value &* $0.quotient &+ $0.remainder }).value
            same(lhs, rhs, "dividend == divisor &* quotient &+ remainder")
        }
        
        invariant: do {
            let (lhs) = dividend.minus(expectation.value.remainder).value
            let (rhs) = expectation.map({ divisor.value &* $0.quotient }).value
            same(lhs, rhs, "dividend &- remainder == dividend &* quotient")
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
        same(T.division(dividend, by: divisor), expectation, "2 by 1 division")
        //=--------------------------------------=
        invariant: if !expectation.error {
            var bit = false
            let lhs = dividend
            var rhs = expectation.value.quotient.multiplication(divisor.value)
            
            (rhs.low,  bit) = rhs.low .plus(T.Magnitude.init(raw: expectation.value.remainder), plus: bit).components()
            (rhs.high, bit) = rhs.high.plus(T(repeating: expectation.value.remainder.appendix), plus: bit).components()
            
            same(bit, false, "dividend == divisor * quotient + remainder [0]")
            same(lhs, (rhs), "dividend == divisor * quotient + remainder [1]")
        }
        
        invariant: if !expectation.error {
            var bit = false
            var lhs = dividend
            let rhs = expectation.value.quotient.multiplication(divisor.value)
            
            (lhs.low,  bit) = lhs.low .minus(T.Magnitude.init(raw: expectation.value.remainder), plus: bit).components()
            (lhs.high, bit) = lhs.high.minus(T(repeating: expectation.value.remainder.appendix), plus: bit).components()
            
            same(bit, false, "dividend - remainder == divisor * quotient [0]")
            same(lhs, (rhs), "dividend - remainder == divisor * quotient [1]")
        }
    }
}
