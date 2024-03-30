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
// MARK: * Test x Comparison
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func comparison<T, U>(
        _ lhs: T,
        _ rhs: U, 
        _ expectation: Signum
    )   where T: BinaryInteger, U: BinaryInteger {
        //=--------------------------------------=
        comparison(
            ExchangeInt(lhs, as: T.Element.self),
            ExchangeInt(rhs, as: U.Element.self),
            expectation
        )
        //=--------------------------------------=
        guard let rhs = rhs as? T else { return }
        //=--------------------------------------=
        for (lhs, rhs, expectation) in [(lhs, rhs, expectation), (rhs, lhs, expectation.negated())] {
            signum: if rhs.signum() == Signum.same {
                let result:  Signum = lhs.signum()
                let success: Bool = result == expectation
                check(success, "\(lhs).signum() -> \(result)")
            }
            
            comparison: do {
                let result:  Signum = lhs.compared(to: rhs)
                let success: Bool = result == expectation
                check(success, "\(lhs).compared(to: \(rhs)) -> \(result)")
            }
            
            less: do {
                let result:  Bool = lhs < rhs
                let success: Bool = result == (expectation == .less)
                check(success, "\(lhs) <  \(rhs) -> \(result)")
            }
            
            same: do {
                let result:  Bool = lhs == rhs
                let success: Bool = result == (expectation == .same)
                check(success, "\(lhs) == \(rhs) -> \(result)")
            }
            
            more: do {
                let result:  Bool = lhs >  rhs
                let success: Bool = result == (expectation == .more)
                check(success, "\(lhs) >  \(rhs) -> \(result)")
            }
            
            nonless: do {
                let result:  Bool = lhs >= rhs
                let success: Bool = result == (expectation != .less)
                check(success, "\(lhs) >= \(rhs) -> \(result)")
            }
            
            nonsame: do {
                let result:  Bool = lhs != rhs
                let success: Bool = result == (expectation != .same)
                check(success, "\(lhs) != \(rhs) -> \(result)")
            }
            
            nonmore: do {
                let result:  Bool = lhs <= rhs
                let success: Bool = result == (expectation != .more)
                check(success, "\(lhs) <= \(rhs) -> \(result)")
            }
        }
    }
    
    public func comparison <A, B, C, D>(_ lhs: ExchangeInt<A, B>, _ rhs: ExchangeInt<C, D>, _ expectation: Signum) {
        func unidirectional<E, F, G, H>(_ lhs: ExchangeInt<E, F>, _ rhs: ExchangeInt<G, H>, _ expectation: Signum) {
            signum: if rhs.signum() == Signum.same {
                let result:  Signum = lhs.signum()
                let success: Bool = result == expectation
                check(success, "\(lhs).signum() -> \(result)")
            }
            
            comparison: do {
                let result:  Signum = lhs.compared(to: rhs)
                let success: Bool = result == expectation
                check(success, "\(lhs).compared(to: \(rhs)) -> \(result)")
            }
            
            less: do {
                let result:  Bool = lhs < rhs
                let success: Bool = result == (expectation == .less)
                check(success, "\(lhs) <  \(rhs) -> \(result)")
            }
            
            same: do {
                let result:  Bool = lhs == rhs
                let success: Bool = result == (expectation == .same)
                check(success, "\(lhs) == \(rhs) -> \(result)")
            }
            
            more: do {
                let result:  Bool = lhs >  rhs
                let success: Bool = result == (expectation == .more)
                check(success, "\(lhs) >  \(rhs) -> \(result)")
            }
            
            nonless: do {
                let result:  Bool = lhs >= rhs
                let success: Bool = result == (expectation != .less)
                check(success, "\(lhs) >= \(rhs) -> \(result)")
            }
            
            nonsame: do {
                let result:  Bool = lhs != rhs
                let success: Bool = result == (expectation != .same)
                check(success, "\(lhs) != \(rhs) -> \(result)")
            }
            
            nonmore: do {
                let result:  Bool = lhs <= rhs
                let success: Bool = result == (expectation != .more)
                check(success, "\(lhs) <= \(rhs) -> \(result)")
            }
        }
        
        unidirectional(lhs, rhs, expectation)
        unidirectional(rhs, lhs, expectation.negated())
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Memory Layout
//=----------------------------------------------------------------------------=

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func equal<T, U>(_ lhs: MemoryLayout<T>.Type, _ rhs: MemoryLayout<U>.Type) {
        same(lhs.size,      rhs.size,      "MemoryLayout: \(T.self) != \(U.self) [size]")
        same(lhs.stride,    rhs.stride,    "MemoryLayout: \(T.self) != \(U.self) [stride]")
        same(lhs.alignment, rhs.alignment, "MemoryLayout: \(T.self) != \(U.self) [alignment]")
    }
}
