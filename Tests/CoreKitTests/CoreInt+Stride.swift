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
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    func testStrideAdvancedBy() {
        func whereIs<T, U>(_ type: T.Type, _ distance: U.Type) where T: SystemsInteger, U: SystemsInteger & SignedInteger {
            typealias F = Fallible<T>
            
            Test().same(T.min.advanced(by: -4 as U), F(T.min &- 4, error: true))
            Test().same(T.min.advanced(by: -3 as U), F(T.min &- 3, error: true))
            Test().same(T.min.advanced(by: -2 as U), F(T.min &- 2, error: true))
            Test().same(T.min.advanced(by: -1 as U), F(T.min &- 1, error: true))
            Test().same(T.min.advanced(by:  0 as U), F(T.min &+ 0))
            Test().same(T.min.advanced(by:  1 as U), F(T.min &+ 1))
            Test().same(T.min.advanced(by:  2 as U), F(T.min &+ 2))
            Test().same(T.min.advanced(by:  3 as U), F(T.min &+ 3))
            
            Test().same(T.max.advanced(by: -4 as U), F(T.max &- 4))
            Test().same(T.max.advanced(by: -3 as U), F(T.max &- 3))
            Test().same(T.max.advanced(by: -2 as U), F(T.max &- 2))
            Test().same(T.max.advanced(by: -1 as U), F(T.max &- 1))
            Test().same(T.max.advanced(by:  0 as U), F(T.max &+ 0))
            Test().same(T.max.advanced(by:  1 as U), F(T.max &+ 1, error: true))
            Test().same(T.max.advanced(by:  2 as U), F(T.max &+ 2, error: true))
            Test().same(T.max.advanced(by:  3 as U), F(T.max &+ 3, error: true))
            
            if  UX(size: T.self) < UX(size: U.self) {
                Test().same(T(~0).advanced(by: U.min), F(~0 as T, error: true))
                Test().same(T(~1).advanced(by: U.min), F(~1 as T, error: true))
                Test().same(T( 0).advanced(by: U.min), F( 0 as T, error: true))
                Test().same(T( 1).advanced(by: U.min), F( 1 as T, error: true))

                Test().same(T(~0).advanced(by: U.max), F(~1 as T, error: true))
                Test().same(T(~1).advanced(by: U.max), F(~2 as T, error: true))
                Test().same(T( 0).advanced(by: U.max), F(~0 as T, error: true))
                Test().same(T( 1).advanced(by: U.max), F( 0 as T, error: true))
            }
        }
        
        for type in coreSystemsIntegers {
            for distance in coreSystemsIntegersWhereIsSigned {
                whereIs(type, distance)
            }
        }
    }
    
    func testStrideDistanceTo() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible
            
            always: do {
                Test().same(T.min.distance(to: T.min.advanced(by:    126)), F(I8 .max - 1))
                Test().same(T.min.distance(to: T.min.advanced(by:    127)), F(I8 .max))
                Test().same(T.min.distance(to: T.min.advanced(by:    128)), F(I8 .min, error: true))
                
                Test().same(T.max.distance(to: T.max.advanced(by:   -129)), F(I8 .max, error: true))
                Test().same(T.max.distance(to: T.max.advanced(by:   -128)), F(I8 .min))
                Test().same(T.max.distance(to: T.max.advanced(by:   -127)), F(I8 .min + 1))
            };  if T.size >= 16 {
                Test().same(T.min.distance(to: T.min.advanced(by:  32766)), F(I16.max - 1))
                Test().same(T.min.distance(to: T.min.advanced(by:  32767)), F(I16.max))
                Test().same(T.min.distance(to: T.min.advanced(by:  32768)), F(I16.min, error: true))
                
                Test().same(T.max.distance(to: T.max.advanced(by: -32769)), F(I16.max, error: true))
                Test().same(T.max.distance(to: T.max.advanced(by: -32768)), F(I16.min))
                Test().same(T.max.distance(to: T.max.advanced(by: -32767)), F(I16.min + 1))
            }
        }
        
        for type in coreSystemsIntegers {
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
