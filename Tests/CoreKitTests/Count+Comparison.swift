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
// MARK: * Count x Comparison
//*============================================================================*

extension CountTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    func testIsZeroWhenLayoutIsZero() {
        func whereTheLayoutIs<Layout>(_ layout: Layout.Type) where Layout: SystemsInteger & SignedInteger {
            typealias T = Count<Layout>
                        
            for instance in Layout(I8.min) ... Layout(I8.max) {
                Test().same(T(raw: instance).isZero, instance.isZero)
            }
        }
        
        for layout in coreSystemsIntegersWhereIsSigned {
            whereTheLayoutIs(layout)
        }
    }
    
    func testIsInfiniteWhenLayoutIsNegative() {
        func whereTheLayoutIs<Layout>(_ layout: Layout.Type) where Layout: SystemsInteger & SignedInteger {
            typealias T = Count<Layout>
                        
            for instance in Layout(I8.min) ... Layout(I8.max) {
                Test().same(T(raw: instance).isInfinite, instance.isNegative)
            }
        }
        
        for layout in coreSystemsIntegersWhereIsSigned {
            whereTheLayoutIs(layout)
        }
    }
    
    func testComparisonIsLikeUnsignedInteger() {
        func whereTheLayoutIs<Layout>(_ layout: Layout.Type) where Layout: SystemsInteger & SignedInteger {
            typealias T = Count<Layout>
            
            let i8s = Layout(I8.min) ... Layout(I8.max)
            
            for lhs in i8s {
                for rhs in i8s {
                    let expectation = Layout.Magnitude(load: lhs).compared(to: Layout.Magnitude(load: rhs))
                    Test().comparison(T(raw: lhs), T(raw: rhs), expectation, id: ComparableID())
                }
            }
        }
        
        whereTheLayoutIs(I8.self)
        whereTheLayoutIs(IX.self)
    }
}
