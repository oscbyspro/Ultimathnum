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
// MARK: * Test x Subtraction
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func subtraction<T>(
        _ lhs: T, 
        _ rhs: T,
        _ expectation: Fallible<T>,
        _ id: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        brr: do {
            same(lhs &- rhs, expectation.value)
        };  if !expectation.error {
            same(lhs  - rhs, expectation.value)
        }
        
        brr: do {
            same({ var x = lhs; x &-= rhs; return x }(), expectation.value)
        };  if !expectation.error {
            same({ var x = lhs; x  -= rhs; return x }(), expectation.value)
        }
        
        if !expectation.error {
            let abc: T = rhs.minus(lhs).value.negated().value
            let xyz: T = lhs.minus(rhs).value
            same(abc, xyz, "binary integer subtraction must be reversible")
        }   else {
            let abc: T = rhs.minus(lhs).value
            let xyz: T = lhs.minus(rhs).value.negated().value
            same(abc, xyz, "binary integer subtraction must be reversible")
        }
        
        if  let one = T.exactly(1).optional(), rhs == one {
            decrementation(lhs, expectation)
        }
        
        brr: do {
            same(lhs.minus(rhs),                     expectation)
            same(lhs.minus(Fallible(rhs)),           expectation)
            same(Fallible(lhs).minus(rhs),           expectation)
            same(Fallible(lhs).minus(Fallible(rhs)), expectation)
        }
        
        if  !expectation.error {
            let expectation = expectation.negated()
            same(rhs.minus(lhs),                     expectation)
            same(rhs.minus(Fallible(lhs)),           expectation)
            same(Fallible(rhs).minus(lhs),           expectation)
            same(Fallible(rhs).minus(Fallible(lhs)), expectation)
        }
        //=--------------------------------------=
        // same as rhs negation when lhs is zero
        //=--------------------------------------=
        if  lhs == 0 {
            same(expectation, rhs.negated())
            same(expectation, Fallible(rhs).negated())
        }
        
        if  lhs == 0 && !expectation.error {
            same(-rhs, expectation.value)
            same(-expectation.value, rhs)
        }
        
        if  lhs == 0 && !expectation.error {
            same(Fallible(rhs), expectation.value.negated())
            same(Fallible(rhs), Fallible(expectation.value).negated())
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Stride
//=----------------------------------------------------------------------------=

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func decrementation<T>(
        _ instance: T,
        _ expectation: Fallible<T>,
        _ id: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        same(instance.decremented(),           expectation)
        same(Fallible(instance).decremented(), expectation)
    }
}
