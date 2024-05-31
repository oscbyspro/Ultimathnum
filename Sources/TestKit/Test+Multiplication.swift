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
// MARK: * Test x Multiplication
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func multiplication<T>(
        _ lhs: T, 
        _ rhs: T,
        _ expectation: Fallible<Doublet<T>>,
        _ id: SystemsIntegerID = .init()
    )   where T: SystemsInteger {
        //=--------------------------------------=
        same(lhs.multiplication(rhs), expectation.value)
        //=--------------------------------------=
        multiplication(
            lhs,
            rhs,
            expectation.map(\.low).map(T.init(raw:)),
            BinaryIntegerID()
        )
    }
    
    public func multiplication<T>(
        _ lhs: T, 
        _ rhs: T, 
        _ expectation: Fallible<T>,
        _ id: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        
        always: do {
            same(lhs &* rhs, expectation.value)
            same(rhs &* lhs, expectation.value)
        };  if !expectation.error {
            same(lhs  * rhs, expectation.value)
            same(rhs  * lhs, expectation.value)
        }
        
        always: do {
            same({ var x = lhs; x &*= rhs; return x }(), expectation.value)
            same({ var x = rhs; x &*= lhs; return x }(), expectation.value)
        };  if !expectation.error {
            same({ var x = lhs; x  *= rhs; return x }(), expectation.value)
            same({ var x = rhs; x  *= lhs; return x }(), expectation.value)
        }
        
        always: do {
            same(lhs.times(rhs), expectation)
            same(rhs.times(lhs), expectation)
        }
        
        square: if lhs == rhs {
            same(lhs.squared(), expectation)
        }
        
        complement: do {
            let lhsComplement = lhs.complement()
            let rhsComplement = rhs.complement()
            let expectationComplement = expectation.value.complement()
            
            same(lhs.times(rhsComplement).value, expectationComplement, "complement [0]")
            same(lhsComplement.times(rhs).value, expectationComplement, "complement [1]")
            same(rhs.times(lhsComplement).value, expectationComplement, "complement [2]")
            same(rhsComplement.times(lhs).value, expectationComplement, "complement [3]")
            same(lhsComplement.times(rhsComplement).value, expectation.value, "complement [4]")
            
            if  lhsComplement == rhsComplement {
                same(lhsComplement.squared().value, expectation.value)
            }
        }
        
        division: if !expectation.error {
            if  let divisor  = Divisor(exactly: rhs) {
                let division = expectation.value.division(divisor)
                same(division.value.quotient,  lhs, "product / rhs == lhs")
                same(division.value.remainder, 000, "product % rhs == 000")
            }
            
            if  let divisor  = Divisor(exactly: lhs) {
                let division = expectation.value.division(divisor)
                same(division.value.quotient,  rhs, "product / lhs == rhs")
                same(division.value.remainder, 000, "product % lhs == 000")
            }
        }
    }
}
