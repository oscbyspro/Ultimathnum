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
// MARK: * Test x Shift
//*============================================================================*

extension Test {
    
    public enum ShiftDirection: Equatable { case left,  right  }
    
    public enum ShiftSemantics: Equatable { case smart, masked }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func shift<T>(
        _ instance: T, 
        _ shift: T,
        _ expectation: T,
        _ direction: ShiftDirection,
        _ semantics: ShiftSemantics,
        file: StaticString = #file, 
        line: UInt = #line
    )   where T: BinaryInteger {
        switch (direction, semantics) {
        case (.left, .smart):
            
            brr: do {
                XCTAssertEqual({         instance    <<  shift           }(), expectation, file: file, line: line)
                XCTAssertEqual({ var x = instance; x <<= shift; return x }(), expectation, file: file, line: line)
            }
            
            if  let shift = shift.negated().optional() {
                XCTAssertEqual({         instance    >>  shift           }(), expectation, file: file, line: line)
                XCTAssertEqual({ var x = instance; x >>= shift; return x }(), expectation, file: file, line: line)
            }
            
            if !shift.isLessThanZero, shift.magnitude < T.bitWidth {
                Test.shift(instance, shift, expectation, .left, .masked, file: file, line: line)
            }
            
        case (.right, .smart):
            
            brr: do {
                XCTAssertEqual({         instance    >>  shift           }(), expectation, file: file, line: line)
                XCTAssertEqual({ var x = instance; x >>= shift; return x }(), expectation, file: file, line: line)
            }
            
            if  let shift = shift.negated().optional() {
                XCTAssertEqual({         instance    <<  shift           }(), expectation, file: file, line: line)
                XCTAssertEqual({ var x = instance; x <<= shift; return x }(), expectation, file: file, line: line)
            }
            
            if !shift.isLessThanZero, shift.magnitude < T.bitWidth {
                Test.shift(instance, shift, expectation, .right, .masked, file: file, line: line)
            }
            
        case (.left, .masked):
            
            func check(_ shift: T) {
                XCTAssertEqual({         instance    &<<  shift           }(), expectation, file: file, line: line)
                XCTAssertEqual({ var x = instance; x &<<= shift; return x }(), expectation, file: file, line: line)
            }
            
            check(shift)
            
            if  let increment = try? T.exactly(magnitude: T.bitWidth).get() {
                if  let shift = try? shift.plus(increment).get() {
                    check(shift)
                }
                
                if  let shift = try? shift.plus(increment).plus(increment).get() {
                    check(shift)
                }
                
                if  let shift = try? shift.minus(increment).get() {
                    check(shift)
                }
                
                if  let shift = try? shift.minus(increment).minus(increment).get() {
                    check(shift)
                }
            }
            
        case (.right, .masked):
            
            func check(_ shift: T) {
                XCTAssertEqual({         instance    &>>  shift           }(), expectation, file: file, line: line)
                XCTAssertEqual({ var x = instance; x &>>= shift; return x }(), expectation, file: file, line: line)
            }

            check(shift)
            
            if  let increment = try? T.exactly(magnitude: T.bitWidth).get() {
                if  let shift = try? shift.plus(increment).get() {
                    check(shift)
                }
                
                if  let shift = try? shift.plus(increment).plus(increment).get() {
                    check(shift)
                }
                
                if  let shift = try? shift.minus(increment).get() {
                    check(shift)
                }
                
                if  let shift = try? shift.minus(increment).minus(increment).get() {
                    check(shift)
                }
            }
            
        }
    }
}
