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
        recursion: Bool = true,
        id: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        
        subtraction: if recursion {
            self.subtraction(expectation.value, rhs, Fallible(lhs, error: expectation.error), recursion: false)
            self.subtraction(expectation.value, lhs, Fallible(rhs, error: expectation.error), recursion: false)
        }
        
        always: do {
            same(lhs &+ rhs, expectation.value)
            same(rhs &+ lhs, expectation.value)
        }
        
        if !expectation.error {
            same(lhs  + rhs, expectation.value)
            same(rhs  + lhs, expectation.value)
        }
        
        always: do {
            same({ var x = lhs; x &+= rhs; return x }(), expectation.value)
            same({ var x = rhs; x &+= lhs; return x }(), expectation.value)
        }
        
        if !expectation.error {
            same({ var x = lhs; x  += rhs; return x }(), expectation.value)
            same({ var x = rhs; x  += lhs; return x }(), expectation.value)
        }
        
        always: do {
            same(lhs.plus(rhs), expectation)
            same(rhs.plus(lhs), expectation)
        }
        
        increment: if rhs == 0 {
            same(lhs.incremented(false), expectation)
        }
        
        increment: if rhs == 1 {
            same(lhs.incremented(true),  expectation)
            same(lhs.incremented(    ),  expectation)
        }
        
        comparison: if let exp = expectation.optional() {
            self.comparison(lhs, exp, rhs.isZero ? Signum.same : Signum.one(Sign(!rhs.isNegative)))
            self.comparison(rhs, exp, lhs.isZero ? Signum.same : Signum.one(Sign(!lhs.isNegative)))
        }
    }
    
    public func subtraction<T>(
        _ lhs: T,
        _ rhs: T,
        _ expectation: Fallible<T>,
        recursion: Bool = true,
        id: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        
        addition: if recursion {
            self.addition(expectation.value, rhs, lhs.veto(expectation.error), recursion: false)
        }
        
        addition: if let inverse = rhs.negated().optional() {
            self.addition(lhs, inverse, expectation, recursion: false)
        }
                
        always: do {
            same(lhs &- rhs, expectation.value)
        }
        
        if !expectation.error {
            same(lhs  - rhs, expectation.value)
        }
        
        always: do {
            same({ var x = lhs; x &-= rhs; return x }(), expectation.value)
        }
        
        if !expectation.error {
            same({ var x = lhs; x  -= rhs; return x }(), expectation.value)
        }
        
        always: do {
            same(lhs.minus(rhs), expectation)
        }
        
        if !expectation.error {
            same(rhs.minus(lhs), expectation.negated())
        }
        
        decrement: if rhs == 0 {
            same(lhs.decremented(false), expectation)
        }
        
        decrement: if rhs == 1 {
            same(lhs.decremented(true),  expectation)
            same(lhs.decremented(    ),  expectation)
        }
        
        negate: if lhs == 0 {
            same(rhs.negated(), expectation)
            same({ var i = rhs; let o = i.negate(); return i.veto(o.error) }(), expectation)
        }
        
        negate: if lhs == 0, !expectation.error {
            same(-rhs, expectation.value)
            same(-expectation.value, rhs)
        }
        
        recover: if !expectation.error {
            let abc: T = rhs.minus(lhs).value.negated().value
            let xyz: T = lhs.minus(rhs).value
            same(abc, xyz, "binary integer subtraction must be reversible [0]")
        }   else {
            let abc: T = rhs.minus(lhs).value
            let xyz: T = lhs.minus(rhs).value.negated().value
            same(abc, xyz, "binary integer subtraction must be reversible [1]")
        }
            
        comparison: if let exp = expectation.optional() {
            self.comparison(lhs, exp, rhs.isZero ? Signum.same : Signum.one(Sign(rhs.isNegative)))
            self.comparison(lhs, rhs, exp.isZero ? Signum.same : Signum.one(Sign(exp.isNegative)))
        }
    }
}
