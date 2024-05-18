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
        
        func unidirectional(_ lhs: T, _ rhs: T, _ expectation: Fallible<T>) {
            same(lhs.times(rhs),             expectation)
            same(lhs.times(rhs.veto(false)), expectation)
            same(lhs.times(rhs.veto(true )), expectation.veto())
            
            same(lhs.veto(false).times(rhs),             expectation)
            same(lhs.veto(false).times(rhs.veto(false)), expectation)
            same(lhs.veto(false).times(rhs.veto(true )), expectation.veto())
            same(lhs.veto(true ).times(rhs),             expectation.veto())
            same(lhs.veto(true ).times(rhs.veto(false)), expectation.veto())
            same(lhs.veto(true ).times(rhs.veto(true )), expectation.veto())
        }
        
        always: do {
            unidirectional(lhs, rhs, expectation)
            unidirectional(rhs, lhs, expectation)
        }
        
        if  lhs == rhs {
            same(lhs.squared(),             expectation)
            same(lhs.veto(false).squared(), expectation)
            same(lhs.veto(true ).squared(), expectation.veto())
        }
    }
}
