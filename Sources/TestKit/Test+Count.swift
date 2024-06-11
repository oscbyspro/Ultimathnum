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
    
    /// - Note: Each call tests `instance` and `instance.toggled()`.
    public func count<T>(
        _ instance: T,
        _ selection: Bit,
        _ expectation: T.Magnitude
    )   where T: BinaryInteger {
        //=--------------------------------------=
        guard let expectationInverse = some(T.size.minus(expectation).optional(), "inverse") else { return }
        //=--------------------------------------=
        let bit: Bit    = selection
        let instance    = (normal: instance,    inverse: instance.toggled())
        let expectation = (normal: expectation, inverse: expectationInverse)
        //=--------------------------------------=
        same(instance.normal .count( bit), expectation.normal,  "count [0]")
        same(instance.normal .count(~bit), expectation.inverse, "count [1]")
        same(instance.inverse.count( bit), expectation.inverse, "count [2]")
        same(instance.inverse.count(~bit), expectation.normal,  "count [3]")
    }
    
    /// - Note: Each call tests `instance` and `instance.toggled()`.
    public func count<T>(
        _ instance: T,
        _ selection: Bit.Ascending,
        _ expectation: T.Magnitude
    )   where T: BinaryInteger {
        //=--------------------------------------=
        guard let expectationInverse = some(T.size.minus(expectation).optional(), "inverse") else { return }
        //=--------------------------------------=
        let bit: Bit    = selection.bit
        let instance    = (normal: instance,    inverse: instance.toggled())
        let expectation = (normal: expectation, inverse: expectationInverse)
        //=--------------------------------------=
        same(instance.normal .count(.ascending( bit)), expectation.normal, "ascending [0]")
        same(instance.inverse.count(.ascending(~bit)), expectation.normal, "ascending [1]")
        
        if !(expectation).normal.isZero {
            same(instance.normal .count(.ascending(~bit)), T.Magnitude(),  "ascending [2]")
            same(instance.inverse.count(.ascending( bit)), T.Magnitude(),  "ascending [3]")
        }
        //=--------------------------------------=
        same(instance.normal .count(.nonascending( bit)), expectation.inverse,  "nonascending [0]")
        same(instance.inverse.count(.nonascending(~bit)), expectation.inverse,  "nonascending [1]")
        
        if !(expectation).normal.isZero {
            same(instance.normal .count(.nonascending(~bit)), T.Magnitude.size, "nonascending [2]")
            same(instance.inverse.count(.nonascending( bit)), T.Magnitude.size, "nonascending [3]")
        }
    }
    
    /// - Note: Each call tests `instance` and `instance.toggled()`.
    public func count<T>(
        _ instance: T,
        _ selection: Bit.Descending,
        _ expectation: T.Magnitude
    )   where T: BinaryInteger {
        //=--------------------------------------=
        guard let expectationInverse = some(T.size.minus(expectation).optional(), "inverse") else { return }
        //=--------------------------------------=
        let bit: Bit    = selection.bit
        let instance    = (normal: instance,    inverse: instance.toggled())
        let expectation = (normal: expectation, inverse: expectationInverse)
        //=--------------------------------------=
        same(instance.normal .count(.descending( bit)), expectation.normal, "descending [0]")
        same(instance.inverse.count(.descending(~bit)), expectation.normal, "descending [1]")
        
        if !(expectation).normal.isZero {
            same(instance.normal .count(.descending(~bit)), T.Magnitude(),  "descending [2]")
            same(instance.inverse.count(.descending( bit)), T.Magnitude(),  "descending [3]")
        }
    
        same(instance.normal .count(.nondescending( bit)), expectation.inverse,  "nondescending [0]")
        same(instance.inverse.count(.nondescending(~bit)), expectation.inverse,  "nondescending [1]")

        if !(expectation).normal.isZero {
            same(instance.normal .count(.nondescending(~bit)), T.Magnitude.size, "nondescending [2]")
            same(instance.inverse.count(.nondescending( bit)), T.Magnitude.size, "nondescending [3]")
        }
        //=--------------------------------------=
        branch: if bit == instance.normal.appendix {
            same(instance.normal .count(   .appendix), expectation.normal,     "appendix [0]")
            same(instance.normal .count(.nonappendix), expectation.inverse, "nonappendix [0]")
        }
    }
}
