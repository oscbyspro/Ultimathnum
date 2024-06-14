//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Test x Count
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// - Note: Each call checks both `instance` and `instance.toggled()`.
    public func count<T>(
        _ instance: T,
        _ bit: Bit,
        _ expectation: T.Magnitude
    )   where T: BinaryInteger {
        //=--------------------------------------=
        guard let expectationInverse = some(T.size.minus(expectation).optional(), "inverse") else { return }
        //=--------------------------------------=
        let instance    = (normal: instance,    inverse: instance.toggled())
        let expectation = (normal: expectation, inverse: expectationInverse)
        //=--------------------------------------=
        // path: count
        //=--------------------------------------=
        same(instance.normal .count( bit), expectation.normal,  "count [0]")
        same(instance.normal .count(~bit), expectation.inverse, "count [1]")
        same(instance.inverse.count( bit), expectation.inverse, "count [2]")
        same(instance.inverse.count(~bit), expectation.normal,  "count [3]")
    }
    
    /// - Note: Each call checks both `instance` and `instance.toggled()`.
    public func ascending<T>(
        _ instance: T,
        _ bit: Bit,
        _ expectation: T.Magnitude
    )   where T: BinaryInteger {
        //=--------------------------------------=
        guard let expectationInverse = some(T.size.minus(expectation).optional(), "inverse") else { return }
        //=--------------------------------------=
        let instance    = (normal: instance,    inverse: instance.toggled())
        let expectation = (normal: expectation, inverse: expectationInverse)
        //=--------------------------------------=
        // path: ascending
        //=--------------------------------------=
        same(instance.normal .ascending( bit), expectation.normal, "ascending [0]")
        same(instance.inverse.ascending(~bit), expectation.normal, "ascending [1]")
        
        if !(expectation).normal.isZero {
            same(instance.normal .ascending(~bit), T.Magnitude(),  "ascending [2]")
            same(instance.inverse.ascending( bit), T.Magnitude(),  "ascending [3]")
        }
        //=--------------------------------------=
        // path: nonascending
        //=--------------------------------------=
        same(instance.normal .nonascending( bit), expectation.inverse,  "nonascending [0]")
        same(instance.inverse.nonascending(~bit), expectation.inverse,  "nonascending [1]")
        
        if !(expectation).normal.isZero {
            same(instance.normal .nonascending(~bit), T.Magnitude.size, "nonascending [2]")
            same(instance.inverse.nonascending( bit), T.Magnitude.size, "nonascending [3]")
        }
    }
    
    /// - Note: Each call checks both `instance` and `instance.toggled()`.
    public func descending<T>(
        _ instance: T,
        _ bit: Bit,
        _ expectation: T.Magnitude
    )   where T: BinaryInteger {
        //=--------------------------------------=
        guard let expectationInverse = some(T.size.minus(expectation).optional(), "inverse") else { return }
        //=--------------------------------------=
        let instance    = (normal: instance,    inverse: instance.toggled())
        let expectation = (normal: expectation, inverse: expectationInverse)
        //=--------------------------------------=
        // path: descending
        //=--------------------------------------=
        same(instance.normal .descending( bit), expectation.normal, "descending [0]")
        same(instance.inverse.descending(~bit), expectation.normal, "descending [1]")
        
        if !(expectation).normal.isZero {
            same(instance.normal .descending(~bit), T.Magnitude(),  "descending [2]")
            same(instance.inverse.descending( bit), T.Magnitude(),  "descending [3]")
        }
        //=--------------------------------------=
        // path: nondescending
        //=--------------------------------------=
        same(instance.normal .nondescending( bit), expectation.inverse,  "nondescending [0]")
        same(instance.inverse.nondescending(~bit), expectation.inverse,  "nondescending [1]")

        if !(expectation).normal.isZero {
            same(instance.normal .nondescending(~bit), T.Magnitude.size, "nondescending [2]")
            same(instance.inverse.nondescending( bit), T.Magnitude.size, "nondescending [3]")
        }
        //=--------------------------------------=
        // path: entropy
        //=--------------------------------------=
        for var x in [instance.normal, instance.inverse] {
            same(x.nondescending(x.appendix), T.Magnitude(x.withUnsafeBinaryIntegerElements({        $0.entropy() }) - 1), "elements.entropy() [0]")
            same(x.nondescending(x.appendix), T.Magnitude(x.withUnsafeMutableBinaryIntegerElements({ $0.entropy() }) - 1), "elements.entropy() [1]")
        }
    }
}
