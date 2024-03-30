//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Test x Result
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @discardableResult public func success<T>(
        _ instance: @autoclosure () throws -> T,
        _ message:  @autoclosure () -> String = ""
    )   -> Optional<T> {
        
        switch Result(catching: instance) {
        case let .success(success):
            
            return success
            
        case let .failure(failure):
            
            XCTFail("error: \(failure) - \(message())", file: file, line: line)
            return nil
            
        }
    }
    
    public func failure<T>(_ instance: @autoclosure () throws -> T, _ message: @autoclosure () -> String = "") {
        XCTAssertThrowsError(try instance(), message(), file: file, line: line)
    }
}
