//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Test x Bool
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func expect(_ instance: Bool, _ message: @autoclosure () -> String = "") {
        XCTAssert(instance, message(), file: file, line: line)
    }
    
    public func yay(_ instance: Bool, _ message: @autoclosure () -> String = "") {
        XCTAssertTrue (instance, message(), file: file, line: line)
    }
    
    public func nay(_ instance: Bool, _ message: @autoclosure () -> String = "") {
        XCTAssertFalse(instance, message(), file: file, line: line)
    }
}
