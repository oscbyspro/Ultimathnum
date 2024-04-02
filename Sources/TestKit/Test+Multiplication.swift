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
            expectation.map(\.low).map(T.init(bitPattern:)),
            BinaryIntegerID()
        )
    }
    
    public func multiplication<T>(
        _ lhs: T, 
        _ rhs: T, 
        _ expectation: Fallible<T>,
        _ id: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        
        brr: do {
            same(lhs &* rhs, expectation.value)
            same(rhs &* lhs, expectation.value)
        };  if !expectation.error {
            same(lhs  * rhs, expectation.value)
            same(rhs  * lhs, expectation.value)
        }
        
        brr: do {
            same({ var x = lhs; x &*= rhs; return x }(), expectation.value)
            same({ var x = rhs; x &*= lhs; return x }(), expectation.value)
        };  if !expectation.error {
            same({ var x = lhs; x  *= rhs; return x }(), expectation.value)
            same({ var x = rhs; x  *= lhs; return x }(), expectation.value)
        }
        
        brr: do {
            same(lhs.times(rhs),                     expectation)
            same(lhs.times(Fallible(rhs)),           expectation)
            same(Fallible(lhs).times(rhs),           expectation)
            same(Fallible(lhs).times(Fallible(rhs)), expectation)
        }
        
        brr: do {
            same(rhs.times(lhs),                     expectation)
            same(rhs.times(Fallible(lhs)),           expectation)
            same(Fallible(rhs).times(lhs),           expectation)
            same(Fallible(rhs).times(Fallible(lhs)), expectation)
        }
        
        if  lhs == rhs {
            same(rhs.squared(),           expectation)
            same(Fallible(lhs).squared(), expectation)
        }
        
        if  lhs == rhs {
            same(rhs.squared(),           expectation)
            same(Fallible(rhs).squared(), expectation)
        }
    }
}
