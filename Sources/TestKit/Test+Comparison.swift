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
    
    public func same<T>(
        _ lhs: T,
        _ rhs: T,
        _ message: @autoclosure () -> String = ""
    )   where T: Equatable {
        XCTAssertEqual(lhs, rhs, message(), file: file, line: line)
    }
    
    public func nonequal<T>(
        _ lhs: T,
        _ rhs: T,
        _ message: @autoclosure () -> String = ""
    )   where T: Equatable {
        XCTAssertNotEqual(lhs, rhs, message(), file: file, line: line)
    }
    
    public func less<T>(
        _ lhs: T,
        _ rhs: T,
        _ message: @autoclosure () -> String = ""
    )   where T: Comparable {
        XCTAssertLessThan(lhs, rhs, message(), file: file, line: line)
    }
    
    public func nonless<T>(
        _ lhs: T,
        _ rhs: T,
        _ message: @autoclosure () -> String = ""
    )   where T: Comparable {
        XCTAssertGreaterThanOrEqual(lhs, rhs, message(), file: file, line: line)
    }
    
    public func more<T>(
        _ lhs: T,
        _ rhs: T,
        _ message: @autoclosure () -> String = ""
    )   where T: Comparable {
        XCTAssertGreaterThan(lhs, rhs, message(), file: file, line: line)
    }
    
    public func nonmore<T>(
        _ lhs: T,
        _ rhs: T,
        _ message: @autoclosure () -> String = ""
    )   where T: Comparable {
        XCTAssertLessThanOrEqual(lhs, rhs, message(), file: file, line: line)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Memory Layout
//=----------------------------------------------------------------------------=

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func same<T, U>(_ lhs: MemoryLayout<T>.Type, _ rhs: MemoryLayout<U>.Type) {
        func message(_ component: String) -> String {
            "MemoryLayout<\(T.self)>.\(component) != MemoryLayout<\(U.self)>.\(component)"
        }
        
        same(lhs.size,      rhs.size,      message("size"     ))
        same(lhs.stride,    rhs.stride,    message("stride"   ))
        same(lhs.alignment, rhs.alignment, message("alignment"))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Integer
//=----------------------------------------------------------------------------=

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
                raw(success, "\(lhs).signum() -> \(result)")
            }
            
            comparison: do {
                let result:  Signum = lhs.compared(to: rhs)
                let success: Bool = result == expectation
                raw(success, "\(lhs).compared(to: \(rhs)) -> \(result)")
            }
            
            less: do {
                let result:  Bool = lhs <  rhs
                let success: Bool = result == (expectation == .less)
                raw(success, "\(lhs) <  \(rhs) -> \(result)")
            }
            
            same: do {
                let result:  Bool = lhs == rhs
                let success: Bool = result == (expectation == .same)
                raw(success, "\(lhs) == \(rhs) -> \(result)")
            }
            
            more: do {
                let result:  Bool = lhs >  rhs
                let success: Bool = result == (expectation == .more)
                raw(success, "\(lhs) >  \(rhs) -> \(result)")
            }
            
            nonless: do {
                let result:  Bool = lhs >= rhs
                let success: Bool = result == (expectation != .less)
                raw(success, "\(lhs) >= \(rhs) -> \(result)")
            }
            
            nonsame: do {
                let result:  Bool = lhs != rhs
                let success: Bool = result == (expectation != .same)
                raw(success, "\(lhs) != \(rhs) -> \(result)")
            }
            
            nonmore: do {
                let result:  Bool = lhs <= rhs
                let success: Bool = result == (expectation != .more)
                raw(success, "\(lhs) <= \(rhs) -> \(result)")
            }
        }
    }
    
    public func  comparison<A, B, C, D>(_ lhs: ExchangeInt<A, B>, _ rhs: ExchangeInt<C, D>, _ expectation: Signum) {
        func unidirectional<E, F, G, H>(_ lhs: ExchangeInt<E, F>, _ rhs: ExchangeInt<G, H>, _ expectation: Signum) {
            signum: if rhs.signum() == Signum.same {
                let result:  Signum = lhs.signum()
                let success: Bool = result == expectation
                raw(success, "\(lhs).signum() -> \(result)")
            }
            
            comparison: do {
                let result:  Signum = lhs.compared(to: rhs)
                let success: Bool = result == expectation
                raw(success, "\(lhs).compared(to: \(rhs)) -> \(result)")
            }
            
            less: do {
                let result:  Bool = lhs < rhs
                let success: Bool = result == (expectation == .less)
                raw(success, "\(lhs) <  \(rhs) -> \(result)")
            }
            
            same: do {
                let result:  Bool = lhs == rhs
                let success: Bool = result == (expectation == .same)
                raw(success, "\(lhs) == \(rhs) -> \(result)")
            }
            
            more: do {
                let result:  Bool = lhs >  rhs
                let success: Bool = result == (expectation == .more)
                raw(success, "\(lhs) >  \(rhs) -> \(result)")
            }
            
            nonless: do {
                let result:  Bool = lhs >= rhs
                let success: Bool = result == (expectation != .less)
                raw(success, "\(lhs) >= \(rhs) -> \(result)")
            }
            
            nonsame: do {
                let result:  Bool = lhs != rhs
                let success: Bool = result == (expectation != .same)
                raw(success, "\(lhs) != \(rhs) -> \(result)")
            }
            
            nonmore: do {
                let result:  Bool = lhs <= rhs
                let success: Bool = result == (expectation != .more)
                raw(success, "\(lhs) <= \(rhs) -> \(result)")
            }
        }
        
        unidirectional(lhs, rhs, expectation)
        unidirectional(rhs, lhs, expectation.negated())
    }
}
