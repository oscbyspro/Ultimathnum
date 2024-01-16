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
    
    public enum ShiftDirection: Equatable { case left,  right  }
    
    public enum ShiftSemantics: Equatable { case smart, masked }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func shift<T: SystemInteger>(
    _ instance: T, _ shift: T, _ result: T, _ direction: ShiftDirection, _ semantics: ShiftSemantics,
    file: StaticString = #file, line: UInt = #line) {
        switch (direction, semantics) {
        case (.left,  .smart ): Test .smartShiftLeft (instance, shift, result, file: file, line: line)
        case (.right, .smart ): Test .smartShiftRight(instance, shift, result, file: file, line: line)
        case (.left,  .masked): Test.maskedShiftLeft (instance, shift, result, file: file, line: line)
        case (.right, .masked): Test.maskedShiftRight(instance, shift, result, file: file, line: line)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
        
    private static func smartShiftLeft<T: SystemInteger>(
    _ instance: T, _ shift: T, _ result: T, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(instance << shift, result, file: file, line: line)
        //=--------------------------------------=
        if  let shift = try? shift.negated() {
            XCTAssertEqual(instance  >> shift, result, file: file, line: line)
        }
        
        if !shift.isLessThanZero, shift.magnitude < T.bitWidth {
            XCTAssertEqual(instance &<< shift, result, file: file, line: line)
        }
    }
    
    private static func smartShiftRight<T: SystemInteger>(
    _ instance: T, _ shift: T, _ result: T, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(instance >> shift, result, file: file, line: line)
        //=--------------------------------------=
        if  let shift = try? shift.negated() {
            XCTAssertEqual(instance  << shift, result, file: file, line: line)
        }
        
        if !shift.isLessThanZero, shift.magnitude < T.bitWidth {
            XCTAssertEqual(instance &>> shift, result, file: file, line: line)
        }
    }
    
    private static func maskedShiftLeft<T: SystemInteger>(
    _ instance: T, _ shift: T, _ result: T, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(instance &<< shift, result, file: file, line: line)
        //=--------------------------------------=
        if  let increment = try? T(magnitude: T.bitWidth) {
            if  let shift = try? shift.plus(increment) {
                XCTAssertEqual(instance &<< shift, result, file: file, line: line)
            }
            
            if  let shift = try? shift.plus(increment).plus(increment) {
                XCTAssertEqual(instance &<< shift, result, file: file, line: line)
            }
            
            if  let shift = try? shift.minus(increment) {
                XCTAssertEqual(instance &<< shift, result, file: file, line: line)
            }
            
            if  let shift = try? shift.minus(increment).minus(increment) {
                XCTAssertEqual(instance &<< shift, result, file: file, line: line)
            }
        }
    }
    
    private static func maskedShiftRight<T: SystemInteger>(
    _ instance: T, _ shift: T, _ result: T, file: StaticString, line: UInt) {
        //=--------------------------------------=
        XCTAssertEqual(instance &>> shift, result, file: file, line: line)
        //=--------------------------------------=
        if  let increment = try? T(magnitude: T.bitWidth) {
            if  let shift = try? shift.plus(increment) {
                XCTAssertEqual(instance &>> shift, result, file: file, line: line)
            }
            
            if  let shift = try? shift.plus(increment).plus(increment) {
                XCTAssertEqual(instance &>> shift, result, file: file, line: line)
            }
            
            if  let shift = try? shift.minus(increment) {
                XCTAssertEqual(instance &>> shift, result, file: file, line: line)
            }
            
            if  let shift = try? shift.minus(increment).minus(increment) {
                XCTAssertEqual(instance &>> shift, result, file: file, line: line)
            }
        }
    }
}
