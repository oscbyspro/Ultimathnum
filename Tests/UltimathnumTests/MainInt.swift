//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Ultimathnum
import TestKit
import XCTest

//*============================================================================*
// MARK: * Main Int
//*============================================================================*

extension UltimathnumTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMainIntToFromExactly() {
        func whereIs<T, U>(_ type: T.Type, _ other: U.Type) where T: SystemInteger, U: Integer {
            if  let i = try? U(exactly: T.min).incremented(by: U(exactly: T.min)).decremented(by: U(magnitude: 1)) {
                XCTAssertEqual(try? T(exactly: i), nil as T?)
            }
            
            if  let i = try? U(exactly: T.min).incremented(by: U(exactly: T.min)) {
                XCTAssertEqual(try? T(exactly: i), T.isSigned ? nil as T? : 0 as T?)
            }
            
            if  let i = try? U(exactly: T.min).incremented(by: U(exactly: T.min)).incremented(by: U(magnitude: 1)) {
                XCTAssertEqual(try? T(exactly: i), T.isSigned ? nil as T? : 1 as T?)
            }
            
            if  let i = try? U(exactly: T.min).decremented(by: U(magnitude: 1)) {
                XCTAssertEqual(try? T(exactly: i), nil as T?)
            }
            
            if  let i = try? U(exactly: T.min).decremented(by: U(magnitude: 1)) {
                XCTAssertEqual(try? T(exactly: i), nil as T?)
            }
            
            if  let i = try? U(exactly: T.min) {
                XCTAssertEqual(try? T(exactly: i), T.min)
            }
            
            if  let i = try? U(exactly: T.min).incremented(by: U(magnitude: 1)) {
                XCTAssertEqual(try? T(exactly: i), T.min + 1)
            }
            
            if  let i = try? U(exactly: T.max).decremented(by: U(magnitude: 1)) {
                XCTAssertEqual(try? T(exactly: i), T.max - 1)
            }
            
            if  let i = try? U(exactly: T.max) {
                XCTAssertEqual(try? T(exactly: i), T.max)
            }
            
            if  let i = try? U(exactly: T.max).incremented(by: U(magnitude: 1)) {
                XCTAssertEqual(try? T(exactly: i), nil as T?)
            }
            
            if  let i = try? U(exactly: T.max).incremented(by: U(exactly: T.max)).decremented(by: U(magnitude: 1)) {
                XCTAssertEqual(try? T(exactly: i), nil as T?)
            }
            
            if  let i = try? U(exactly: T.max).incremented(by: U(exactly: T.max)) {
                XCTAssertEqual(try? T(exactly: i), nil as T?)
            }
            
            if  let i = try? U(exactly: T.max).incremented(by: U(exactly: T.max)).incremented(by: U(magnitude: 1)) {
                XCTAssertEqual(try? T(exactly: i), nil as T?)
            }
        }
        
        for type in Self.mainInt {
            for other in Self.types {
                whereIs(type, other)
            }
        }
    }
}
