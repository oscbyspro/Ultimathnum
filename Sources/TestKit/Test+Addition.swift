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
        brr: do {
            same(lhs &+ rhs, expectation.value)
            same(rhs &+ lhs, expectation.value)
        };  if !expectation.error {
            same(lhs  + rhs, expectation.value)
            same(rhs  + lhs, expectation.value)
        }
        
        brr: do {
            same({ var x = lhs; x &+= rhs; return x }(), expectation.value)
            same({ var x = rhs; x &+= lhs; return x }(), expectation.value)
        };  if !expectation.error {
            same({ var x = lhs; x  += rhs; return x }(), expectation.value)
            same({ var x = rhs; x  += lhs; return x }(), expectation.value)
        }
        
        if  rhs == T.exactly(1).optional() {
            incrementation(lhs, expectation)
        }
        
        brr: do {
            same(lhs.plus(rhs),                     expectation)
            same(lhs.plus(Fallible(rhs)),           expectation)
            same(Fallible(lhs).plus(rhs),           expectation)
            same(Fallible(lhs).plus(Fallible(rhs)), expectation)
        }
        
        brr: do {
            same(rhs.plus(lhs),                     expectation)
            same(rhs.plus(Fallible(lhs)),           expectation)
            same(Fallible(rhs).plus(lhs),           expectation)
            same(Fallible(rhs).plus(Fallible(lhs)), expectation)
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
    
    public func incrementation<T>(
        _ instance: T, 
        _ expectation: Fallible<T>,
        identifier: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        same(instance.incremented(),           expectation)
        same(Fallible(instance).incremented(), expectation)
    }
}
