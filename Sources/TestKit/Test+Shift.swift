//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
    
    public enum ShiftDirection { case left,  right  }
    
    public enum ShiftSemantics { case smart, masked }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func shift<T: SystemInteger>(
    _ operand: T, _ shift: T, _ result: T, _ direction: ShiftDirection, _ semantics: ShiftSemantics,
    file: StaticString = #file, line: UInt = #line) {
        switch (direction, semantics) {
        case (.left,  .smart ): Test .smartShiftLeft (operand, shift, result, file: file, line: line)
        case (.right, .smart ): Test .smartShiftRight(operand, shift, result, file: file, line: line)
        case (.left,  .masked): Test.maskedShiftLeft (operand, shift, result, file: file, line: line)
        case (.right, .masked): Test.maskedShiftRight(operand, shift, result, file: file, line: line)
        }
    }
    
    // TODO: add shift invariants when integer conversion is possible
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
        
    private static func smartShiftLeft<T: SystemInteger>(
    _ operand: T, _ shift: T, _ result: T, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(operand  << shift, result, file: file, line: line)
        //=--------------------------------------=
        if  let shift = shift.negated().optional() {
            XCTAssertEqual(operand  >> shift, result, file: file, line: line)
        }
        
        if !shift.isLessThanZero, shift.magnitude < T.bitWidth {
            XCTAssertEqual(operand &<< shift, result, file: file, line: line)
        }
    }
    
    private static func smartShiftRight<T: SystemInteger>(
    _ operand: T, _ shift: T, _ result: T, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(operand  >> shift, result, file: file, line: line)
        //=--------------------------------------=
        if  let shift = shift.negated().optional() {
            XCTAssertEqual(operand  << shift, result, file: file, line: line)
        }
        
        if !shift.isLessThanZero, shift.magnitude < T.bitWidth {
            XCTAssertEqual(operand &>> shift, result, file: file, line: line)
        }
    }
    
    private static func maskedShiftLeft<T: SystemInteger>(
    _ operand: T, _ shift: T, _ result: T, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(operand &<< shift, result, file: file, line: line)
        //=--------------------------------------=
        if  let increment = try? T(magnitude: T.bitWidth) {
            if  let shift = shift.incremented(by: increment).optional() {
                XCTAssertEqual(operand &<< shift, result, file: file, line: line)
            }
            
            if  let shift = shift.incremented(by: increment).optional()?.incremented(by: increment).optional() {
                XCTAssertEqual(operand &<< shift, result, file: file, line: line)
            }
            
            if  let shift = shift.decremented(by: increment).optional() {
                XCTAssertEqual(operand &<< shift, result, file: file, line: line)
            }
            
            if  let shift = shift.decremented(by: increment).optional()?.decremented(by: increment).optional() {
                XCTAssertEqual(operand &<< shift, result, file: file, line: line)
            }
        }
    }
    
    private static func maskedShiftRight<T: SystemInteger>(
    _ operand: T, _ shift: T, _ result: T, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(operand &>> shift, result, file: file, line: line)
        //=--------------------------------------=
        if  let increment = try? T(magnitude: T.bitWidth) {
            if  let shift = shift.incremented(by: increment).optional() {
                XCTAssertEqual(operand &>> shift, result, file: file, line: line)
            }
            
            if  let shift = shift.incremented(by: increment).optional()?.incremented(by: increment).optional() {
                XCTAssertEqual(operand &>> shift, result, file: file, line: line)
            }
            
            if  let shift = shift.decremented(by: increment).optional() {
                XCTAssertEqual(operand &>> shift, result, file: file, line: line)
            }
            
            if  let shift = shift.decremented(by: increment).optional()?.decremented(by: increment).optional() {
                XCTAssertEqual(operand &>> shift, result, file: file, line: line)
            }
        }
    }
}
