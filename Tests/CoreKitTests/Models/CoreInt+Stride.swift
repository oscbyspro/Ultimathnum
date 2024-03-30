//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Core Int x Stride
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testStride() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            var lhsLength = 000 as Int
            var rhsLength = 255 as Int
            
            let lowerBound: T = T.isSigned ? -128 : 000
            let upperBound: T = T.isSigned ?  127 : 255
            
            for value in lowerBound ... upperBound {
                Test().same(lowerBound.distance(to: value),  lhsLength)
                Test().same(upperBound.distance(to: value), -rhsLength)

                Test().same(value.distance(to: lowerBound), -lhsLength)
                Test().same(value.distance(to: upperBound),  rhsLength)
                
                Test().same(lowerBound.advanced(by:  lhsLength), value)
                Test().same(upperBound.advanced(by: -rhsLength), value)
                
                Test().same(value.advanced(by: -lhsLength), lowerBound)
                Test().same(value.advanced(by:  rhsLength), upperBound)
                
                lhsLength += 1
                rhsLength -= 1
            }
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testStrideAdvancedBy() {
        typealias F = Fallible
        
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().same(T.advanced(T.min, by: -1 as IX), F(T.max, error: true))
            Test().same(T.advanced(T.min, by:  0 as IX), F(T.min))
            Test().same(T.advanced(T.min, by:  1 as IX), F(T.min + 1))
            Test().same(T.advanced(T.max, by: -1 as IX), F(T.max - 1))
            Test().same(T.advanced(T.max, by:  0 as IX), F(T.max))
            Test().same(T.advanced(T.max, by:  1 as IX), F(T.min, error: true))
            
            if  UX(bitWidth: T.self) < IX.bitWidth {
                Test().same(T.advanced(0 as T, by: IX.min), F( 0 as T, error: true))
                Test().same(T.advanced(0 as T, by: IX.max), F(~0 as T, error: true))
            }
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testStrideDistanceTo() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible
            
            Test().same(T.distance(T.max, to: T.max.advanced(by: -129), as: I8.self), F(I8.max, error: true))
            Test().same(T.distance(T.max, to: T.max.advanced(by: -128), as: I8.self), F(I8.min))
            Test().same(T.distance(T.max, to: T.max.advanced(by: -127), as: I8.self), F(I8.min + 1))
            Test().same(T.distance(T.min, to: T.min.advanced(by:  126), as: I8.self), F(I8.max - 1))
            Test().same(T.distance(T.min, to: T.min.advanced(by:  127), as: I8.self), F(I8.max))
            Test().same(T.distance(T.min, to: T.min.advanced(by:  128), as: I8.self), F(I8.min, error: true))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}

//*============================================================================*
// MARK: * Core Int x Stride x Open Source Issues
//*============================================================================*

final class CoreIntTestsOnStrideOpenSourceIssues: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// https://github.com/apple/swift/pull/71369
    ///
    /// - Note: Checks two unnecessary traps in Swift 5.9.
    ///
    func testGitHubAppleSwiftPull71369() {
        Test().same(I8.min.advanced(by: Swift.Int(Int8.max)) + 1, 0 as I8)
        Test().same(UX.max.advanced(by: Swift.Int.min), UX.max /  2 as UX)
    }
    
    /// https://github.com/apple/swift/pull/71387
    ///
    /// - Note: Checks two unnecessary traps in Swift 5.9.
    ///
    func testGitHubAppleSwiftPull71387() {
        Test().same(UX.max.distance(to: UX.max/2), Int.min)
        Test().same(IX.max.distance(to: -1 as IX), Int.min)
    }
}
