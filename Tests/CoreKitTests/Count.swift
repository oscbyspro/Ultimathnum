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
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let patterns: [IX] = {
        var elements = Array<IX>()
        elements.append(contentsOf: IX.min...IX.min+127)
        elements.append(contentsOf: -128...127)
        elements.append(contentsOf: IX.max-127...IX.max)
        return elements
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBitCast() {
        for x in Self.patterns {
            Test().same(IX(raw: Count(raw: x)), x)
        }
    }
    
    func testInitLayout() {
        for x in Self.patterns {
            if  x.isNegative {
                Test().none(Count(exactly:   x))
            }   else {
                Test().same(Count(x),            Count(raw: x))
                Test().same(Count(exactly:   x), Count(raw: x))
                Test().same(Count(unchecked: x), Count(raw: x))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInstances() {
        Test().same(Count.zero,     Count(raw:  0 as IX))
        Test().same(Count.infinity, Count(raw: -1 as IX))
    }
    
    func testNatural() {
        for x in Self.patterns {
            Test().same(Count(raw: x).natural(), x.veto(x.isNegative))
        }
    }
}
