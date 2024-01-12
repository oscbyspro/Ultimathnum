//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import ModelsKit
import TestKit

//*============================================================================*
// MARK: * Fibonacci
//*============================================================================*

final class FibonacciTests: XCTestCase {
    
    typealias Components<T> = (index: T, element: T, next: T)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func check<T>(_ sequence: Fibonacci<T>?, _ expectation: Components<T>?, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sequence?.index,   expectation?.index,   file: file, line: line)
        XCTAssertEqual(sequence?.element, expectation?.element, file: file, line: line)
        XCTAssertEqual(sequence?.next,    expectation?.next,    file: file, line: line)
    }
    
    func checkLowerBound<T>(_ sequence: Fibonacci<T>.Type, file: StaticString = #file, line: UInt = #line) {
        typealias F = Fibonacci<T>
        
        if  T.isSigned {
            XCTAssertThrowsError(try F(-1))
        }
                
        if  let one = try? T(literally: 1), var sequence = Test.some(try? F()) {
            XCTAssertNoThrow/**/(try F( ))
            XCTAssertNoThrow/**/(try F(0))
            
            let components  = Components(0, 0, one)
            check(sequence, components, file: file, line: line)
            XCTAssertThrowsError(try sequence.decrement())
            check(sequence, components, file: file, line: line)
            XCTAssertNoThrow/**/(try sequence.double())
            check(sequence, components, file: file, line: line)
        }   else {
            XCTAssertThrowsError(try F( ))
            XCTAssertThrowsError(try F(0))
        }
    }
    
    func checkUpperBound<T>(_ sequence: Fibonacci<T>, _ expectation: Components<T>, file: StaticString = #file, line: UInt = #line) {
        var ((sequence)) = sequence
        check(sequence, expectation, file: file, line: line)
        XCTAssertThrowsError(try sequence.increment())
        check(sequence, expectation, file: file, line: line)
        XCTAssertThrowsError(try sequence.double())
        check(sequence, expectation, file: file, line: line)
    }
}
