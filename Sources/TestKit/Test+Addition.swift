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
// MARK: * Test x Addition
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func addition<T>(
        _ lhs: T,
        _ rhs: T,
        _ expectation: Fallible<T>,
        identifier: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        
        always: do {
            same(lhs &+ rhs, expectation.value)
            same(rhs &+ lhs, expectation.value)
        };  if !expectation.error {
            same(lhs  + rhs, expectation.value)
            same(rhs  + lhs, expectation.value)
        }
        
        always: do {
            same({ var x = lhs; x &+= rhs; return x }(), expectation.value)
            same({ var x = rhs; x &+= lhs; return x }(), expectation.value)
        };  if !expectation.error {
            same({ var x = lhs; x  += rhs; return x }(), expectation.value)
            same({ var x = rhs; x  += lhs; return x }(), expectation.value)
        }
        
        if  rhs == 0 {
            same(lhs.plus(false),               expectation)
            same(lhs.veto(false).plus(false),   expectation)
            same(lhs.veto(true ).plus(false),   expectation.veto())
        }
        
        if  rhs == 1 {
            same(lhs.plus(true),                expectation)
            same(lhs.veto(false).plus(true),    expectation)
            same(lhs.veto(true ).plus(true),    expectation.veto())
            
            same(lhs.incremented(),             expectation)
            same(lhs.veto(false).incremented(), expectation)
            same(lhs.veto(true ).incremented(), expectation.veto())
        }
        
        func unidirectional(_ lhs: T, _ rhs: T, _ expectation: Fallible<T>) {
            same(lhs.plus(rhs),             expectation)
            same(lhs.plus(rhs.veto(false)), expectation)
            same(lhs.plus(rhs.veto(true )), expectation.veto())
            
            same(lhs.veto(false).plus(rhs),             expectation)
            same(lhs.veto(false).plus(rhs.veto(false)), expectation)
            same(lhs.veto(false).plus(rhs.veto(true )), expectation.veto())
            same(lhs.veto(true ).plus(rhs),             expectation.veto())
            same(lhs.veto(true ).plus(rhs.veto(false)), expectation.veto())
            same(lhs.veto(true ).plus(rhs.veto(true )), expectation.veto())
        }
        
        always: do {
            unidirectional(lhs, rhs, expectation)
            unidirectional(rhs, lhs, expectation)
        }
    }
}
