//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Test x Optional
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func none<T>(_ instance: T?, _ message: @autoclosure () -> String = "") {
        XCTAssertNil(instance, message(), file: file, line: line)
    }
    
    @discardableResult public func some<T>(_ instance: T?, _ message: @autoclosure () -> String = "") -> T? {
        XCTAssertNotNil(instance, message(), file: file, line: line)
        return instance
    }
}
