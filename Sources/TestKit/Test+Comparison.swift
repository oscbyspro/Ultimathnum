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
    
    public func nonsame<T>(
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
// MARK: + Signum
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
        
        func unidirectional<A, B>(
            _ lhs: A,
            _ rhs: B,
            _ expectation: Signum
        )   where A: BinaryInteger, B: BinaryInteger {
            //=----------------------------------=
            let rhsIsZero = rhs.isZero
            //=----------------------------------=
            signum: if rhsIsZero {
                let result:  Signum = lhs.signum()
                let success: Bool = result == expectation
                expect(success, "\(lhs).signum() -> \(result)")
            }
            
            comparison: do {
                let result:  Signum = lhs.compared(to: rhs)
                let success: Bool = result == expectation
                expect(success, "\(lhs).compared(to: \(rhs)) -> \(result)")
            }
            
            less: do {
                let result:  Bool = lhs <  rhs
                let success: Bool = result == (expectation == .less)
                expect(success, "\(lhs) <  \(rhs) -> \(result)")
            }
            
            same: do {
                let result:  Bool = lhs == rhs
                let success: Bool = result == (expectation == .same)
                expect(success, "\(lhs) == \(rhs) -> \(result)")
            }
            
            more: do {
                let result:  Bool = lhs >  rhs
                let success: Bool = result == (expectation == .more)
                expect(success, "\(lhs) >  \(rhs) -> \(result)")
            }
            
            nonless: do {
                let result:  Bool = lhs >= rhs
                let success: Bool = result == (expectation != .less)
                expect(success, "\(lhs) >= \(rhs) -> \(result)")
            }
            
            nonsame: do {
                let result:  Bool = lhs != rhs
                let success: Bool = result == (expectation != .same)
                expect(success, "\(lhs) != \(rhs) -> \(result)")
            }
            
            nonmore: do {
                let result:  Bool = lhs <= rhs
                let success: Bool = result == (expectation != .more)
                expect(success, "\(lhs) <= \(rhs) -> \(result)")
            }
            
            func elements<E>(_ lhs: MutableDataInt<E>, _ rhs: MutableDataInt<E>) {
                always: do {
                    let result = DataInt.compare(
                        lhs: DataInt(lhs), mode: A.mode,
                        rhs: DataInt(rhs), mode: B.mode
                    )

                    same(result, expectation, "elements.compared(to:)")
                }
                    
                always: do {
                    same(rhs.isZero, rhsIsZero, "elements.isZero [0]")
                    same(DataInt(rhs).isZero, rhsIsZero, "elements.isZero [0]")
                }
                
                if  rhs.appendix == 0 {
                    same(rhs.body.isZero, rhsIsZero, "body.isZero [0]")
                    same(DataInt.Body(rhs.body).isZero, rhsIsZero, "body.isZero [1]")
                }
                                
                if  rhsIsZero {
                    same(DataInt.signum(of: DataInt(lhs), mode: A.mode), expectation, "elements.signum()")
                }
                                
                if  rhsIsZero, lhs.appendix == 0, rhs.appendix == 0 {
                    same(lhs.body.signum(), expectation, "body.signum()")
                }
                
                if  lhs.appendix == 0, rhs.appendix == 0 {
                    same((lhs.body).compared(to: rhs.body), expectation, "body.compared(to:) [0]")
                    same((lhs.body).compared(to: DataInt.Body(rhs.body)), expectation, "body.compared(to:) [1]")
                    same(DataInt.Body(lhs.body).compared(to:  rhs.body ), expectation, "body.compared(to:) [2]")
                    same(DataInt.Body(lhs.body).compared(to: DataInt.Body(rhs.body)), expectation, "body.compared(to:) [3]")
                }
            }
            
            elements: do { var lhs = lhs, rhs = rhs

                if  A.Element.Magnitude.size <= B.Element.Magnitude.size {
                    lhs.withUnsafeMutableBinaryIntegerElements { lhs in
                        rhs.withUnsafeMutableBinaryIntegerElements(as: A.Element.Magnitude.self) { rhs in
                            elements(lhs, rhs)
                        }
                    }
                                        
                }   else {
                    lhs.withUnsafeMutableBinaryIntegerElements(as: B.Element.Magnitude.self) { lhs in
                        rhs.withUnsafeMutableBinaryIntegerElements { rhs in
                            elements(lhs, rhs)
                        }
                    }
                }
            }
        }
        
        unidirectional(lhs, rhs, expectation)
        unidirectional(rhs, lhs, expectation.negated())
        
        if  T.self == U.self, expectation == Signum.same {
            same(lhs.hashValue, rhs.hashValue, "Hashable/hashValue")
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func comparison<T>(
        _ lhs: T,
        _ rhs: T,
        _ expectation: Signum,
        id: ComparableID
    )   where T: Comparable {

        func unidirectional<U>(
            _ lhs: U,
            _ rhs: U,
            _ expectation: Signum
        )   where U: Comparable {
            
            less: do {
                let result:  Bool = lhs <  rhs
                let success: Bool = result == (expectation == .less)
                expect(success, "\(lhs) <  \(rhs) -> \(result)")
            }
            
            same: do {
                let result:  Bool = lhs == rhs
                let success: Bool = result == (expectation == .same)
                expect(success, "\(lhs) == \(rhs) -> \(result)")
            }
            
            more: do {
                let result:  Bool = lhs >  rhs
                let success: Bool = result == (expectation == .more)
                expect(success, "\(lhs) >  \(rhs) -> \(result)")
            }
            
            nonless: do {
                let result:  Bool = lhs >= rhs
                let success: Bool = result == (expectation != .less)
                expect(success, "\(lhs) >= \(rhs) -> \(result)")
            }
            
            nonsame: do {
                let result:  Bool = lhs != rhs
                let success: Bool = result == (expectation != .same)
                expect(success, "\(lhs) != \(rhs) -> \(result)")
            }
            
            nonmore: do {
                let result:  Bool = lhs <= rhs
                let success: Bool = result == (expectation != .more)
                expect(success, "\(lhs) <= \(rhs) -> \(result)")
            }
        }
        
        unidirectional(lhs, rhs, expectation)
        unidirectional(rhs, lhs, expectation.negated())
    }
}
