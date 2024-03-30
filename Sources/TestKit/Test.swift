//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Test
//*============================================================================*

public struct Test {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let file: StaticString
    public let line: UInt
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    public init(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func fail(_ message: String) {
        XCTFail(message, file: file, line: line)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Boolean
//=----------------------------------------------------------------------------=

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func check(_ instance: Bool, _ message: @autoclosure () -> String = "") {
        XCTAssert(instance, message(), file: file, line: line)
    }
    
    public func yay(_ instance: Bool, _ message: @autoclosure () -> String = "") {
        XCTAssertTrue (instance, message(), file: file, line: line)
    }
    
    public func nay(_ instance: Bool, _ message: @autoclosure () -> String = "") {
        XCTAssertFalse(instance, message(), file: file, line: line)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Comparison
//=----------------------------------------------------------------------------=

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
// MARK: + Result
//=----------------------------------------------------------------------------=

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @discardableResult public func success<T>(
        _ expression: @autoclosure () throws -> T,
        _ message: @autoclosure () -> String = ""
    )   -> T? {
        switch Result(catching: expression) {
        case let .success(success):
            
            return success
            
        case let .failure(failure):
            
            XCTFail("error: \(failure) - \(message())", file: file, line: line)
            return nil
            
        }
    }
    
    public func failure<T>(
        _ expression: @autoclosure () throws -> T,
        _ message: @autoclosure () -> String = ""
    )   where T: Equatable {
        XCTAssertThrowsError(try expression(), message(), file: file, line: line)
    }
}
