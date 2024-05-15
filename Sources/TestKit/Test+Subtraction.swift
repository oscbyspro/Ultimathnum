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
        
        always: do {
            same(lhs &- rhs, expectation.value)
        };  if !expectation.error {
            same(lhs  - rhs, expectation.value)
        }
        
        always: do {
            same({ var x = lhs; x &-= rhs; return x }(), expectation.value)
        };  if !expectation.error {
            same({ var x = lhs; x  -= rhs; return x }(), expectation.value)
        }
        
        if !expectation.error {
            let abc: T = rhs.minus(lhs).value.negated().value
            let xyz: T = lhs.minus(rhs).value
            same(abc, xyz, "binary integer subtraction must be reversible [0]")
        }   else {
            let abc: T = rhs.minus(lhs).value
            let xyz: T = lhs.minus(rhs).value.negated().value
            same(abc, xyz, "binary integer subtraction must be reversible [1]")
        }
        
        if  rhs == 0 {
            same(lhs.minus(false),              expectation)
            same(lhs.veto (false).minus(false), expectation)
            same(lhs.veto (true ).minus(false), expectation.veto())
        }
        
        if  rhs == 1 {
            same(lhs.minus(true),               expectation)
            same(lhs.veto (false).minus(true),  expectation)
            same(lhs.veto (true ).minus(true),  expectation.veto())
            
            same(lhs.decremented(),             expectation)
            same(lhs.veto(false).decremented(), expectation)
            same(lhs.veto(true ).decremented(), expectation.veto())
        }
        
        func unidirectional(_ lhs: T, _ rhs: T, _ expectation: Fallible<T>) {
            same(lhs.minus(rhs),             expectation)
            same(lhs.minus(rhs.veto(false)), expectation)
            same(lhs.minus(rhs.veto(true )), expectation.veto())
            
            same(lhs.veto (false).minus(rhs),             expectation)
            same(lhs.veto (false).minus(rhs.veto(false)), expectation)
            same(lhs.veto (false).minus(rhs.veto(true )), expectation.veto())
            same(lhs.veto (true ).minus(rhs),             expectation.veto())
            same(lhs.veto (true ).minus(rhs.veto(false)), expectation.veto())
            same(lhs.veto (true ).minus(rhs.veto(true )), expectation.veto())
        }
        
        always: do {
            unidirectional(lhs, rhs, expectation)
        }
        
        if !expectation.error {
            unidirectional(rhs, lhs, expectation.negated())
        }
        //=--------------------------------------=
        // same as rhs negation when lhs is zero
        //=--------------------------------------=
        if  lhs == 0 {
            same(rhs.negated(),             expectation)
            same(rhs.veto(false).negated(), expectation)
            same(rhs.veto(true ).negated(), expectation.veto())
        }
        
        if  lhs == 0 && !expectation.error {
            same(-rhs, expectation.value)
            same(-expectation.value, rhs)
        }
        
        if  lhs == 0 && !expectation.error {
            same(rhs.veto(false), expectation.value.negated())
            same(rhs.veto(false), expectation.value.veto(false).negated())
        }
    }
}
