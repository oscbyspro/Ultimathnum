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
// MARK: * Count
//*============================================================================*

final class CountTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testZero() {
        func whereTheLayoutIs<Layout>(_ layout: Layout.Type) where Layout: SystemsInteger & SignedInteger {
            typealias T = Count<Layout>
            
            Test().same(T.zero,           T(raw:   0 as Layout))
            Test().same(T.zero.natural(), Fallible(0 as Layout))
        }
        
        for layout in coreSystemsIntegersWhereIsSigned {
            whereTheLayoutIs(layout)
        }
    }
    
    func testInfinity() {
        func whereTheLayoutIs<Layout>(_ layout: Layout.Type) where Layout: SystemsInteger & SignedInteger {
            typealias T = Count<Layout>
            
            Test().same(T.infinity,           T(raw:   -1 as Layout))
            Test().same(T.infinity.natural(), Fallible(-1 as Layout, error: true))
        }
        
        for layout in coreSystemsIntegersWhereIsSigned {
            whereTheLayoutIs(layout)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBitCast() {
        func whereTheLayoutIs<Layout>(_ layout: Layout.Type) where Layout: SystemsInteger & SignedInteger {
            typealias T = Count<Layout>
            
            for instance in Layout(I8.min) ... Layout(I8.max) {
                Test().same(Layout(raw: T(raw: instance)), instance)
            }
        }
        
        for layout in coreSystemsIntegersWhereIsSigned {
            whereTheLayoutIs(layout)
        }
    }
    
    func testInitLayout() {
        func whereTheLayoutIs<Layout>(_ layout: Layout.Type) where Layout: SystemsInteger & SignedInteger {
            typealias T = Count<Layout>
            
            for instance in Layout(I8.min) ... Layout(I8.max) {
                let expectation = !instance.isNegative ? T(raw: instance) : nil
                
                always: do {
                    Test().same(T(exactly:   instance), expectation)
                }
                
                if  let expectation {
                    Test().same(T(instance),            expectation)
                    Test().same(T(unchecked: instance), expectation)
                }
            }
        }
        
        for layout in coreSystemsIntegersWhereIsSigned {
            whereTheLayoutIs(layout)
        }
    }
}
