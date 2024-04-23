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
        _ value: () throws -> T,
        _ message:  @autoclosure () -> String = String()
    )   -> Optional<T> {
        
        switch Result(catching: value) {
        case let .success(success):
            return success
            
        case let .failure(failure):
            XCTFail("error: \(failure) - \(message())", file: file, line: line)
            return nil
        }
    }
    
    @discardableResult public func success<T: Equatable>(
        _ value: () throws -> T,
        _ expectation: T,
        _ message:  @autoclosure () -> String = String()
    )   -> Optional<T> {
        
        switch Result(catching: value) {
        case let .success(success):
            
            XCTAssertEqual(success, expectation, file: file, line: line)
            return success
            
        case let .failure(failure):
            XCTFail("error: \(failure) - \(message())", file: file, line: line)
            return nil
        }
    }
    
    public func failure<T>(
        _ value: () throws -> T,
        _ message:  @autoclosure () -> String = String()
    ) {
        XCTAssertThrowsError(try value(), message(), file: file, line: line)
    }
    
    public func failure<T, E: Error & Equatable>(
        _ value: () throws -> T,
        _ expectation: E,
        _ message:  @autoclosure () -> String = String()
    ) {
        
        branch: do {
            let value = try value()
            XCTFail("value: \(value) - \(message())", file: file, line: line)
        }   catch let error as E {
            XCTAssertEqual(error, expectation, file: file, line: line)
        }   catch let error {
            XCTFail("error: \(error) - \(message())", file: file, line: line)
        }        
    }
}
