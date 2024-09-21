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
    // MARK: Utilities x Binary Integer
    //=------------------------------------------------------------------------=
    
    /// - Note: it tests `bit` and `bit.toggled()`.
    ///
    /// - Note: It tests `instance` and `instance.toggled()`.
    ///
    public func count<T>(
        _ instance: T,
        _ bit: Bit,
        _ expectation: Count
    )   where T: BinaryInteger {
        
        let nonexpectation = Count(raw: IX(raw: instance.size()) - IX(raw: expectation))
        for var x: (instance: T, expectation: Count) in [(instance, expectation), (instance.toggled(), nonexpectation)] {
            self.count(x.instance, bit, x.expectation, id: BitCountableID())
            
            if !T.isArbitrary {
                x.instance.withUnsafeBinaryIntegerBody {
                    self.count($0, bit, x.expectation, id: BitCountableID())
                }
                
                x.instance.withUnsafeMutableBinaryIntegerBody {
                    self.count($0, bit, x.expectation, id: BitCountableID())
                }
                
            }   else {
                x.instance.withUnsafeBinaryIntegerElements {
                    self.count($0, bit, x.expectation, id: BitCountableID())
                }
                
                x.instance.withUnsafeMutableBinaryIntegerElements {
                    self.count($0, bit, x.expectation, id: BitCountableID())
                }
            }
        }
    }
    
    /// - Note: it tests `bit` and `bit.toggled()`.
    ///
    /// - Note: It tests `instance` and `instance.toggled()`.
    ///
    public func ascending<T>(
        _ instance: T,
        _ bit: Bit,
        _ expectation: Count
    )   where T: BinaryInteger {
        
        for var x: (instance: T, bit: Bit) in [(instance, bit), (instance.toggled(), bit.toggled())] {
            self.ascending(x.instance, x.bit, expectation, id: BitCountableID())
            
            if !T.isArbitrary {
                x.instance.withUnsafeBinaryIntegerBody {
                    self.ascending($0, x.bit, expectation, id: BitCountableID())
                }
                
                x.instance.withUnsafeMutableBinaryIntegerBody {
                    self.ascending($0, x.bit, expectation, id: BitCountableID())
                }
                
            }   else {
                x.instance.withUnsafeBinaryIntegerElements {
                    self.ascending($0, x.bit, expectation, id: BitCountableID())
                }
                
                x.instance.withUnsafeMutableBinaryIntegerElements {
                    self.ascending($0, x.bit, expectation, id: BitCountableID())
                }
            }
        }
    }
    
    /// - Note: it tests `bit` and `bit.toggled()`.
    ///
    /// - Note: It tests `instance` and `instance.toggled()`.
    ///
    public func descending<T>(
        _ instance: T,
        _ bit: Bit,
        _ expectation: Count
    )   where T: BinaryInteger {
        
        for var x: (instance: T, bit: Bit) in [(instance, bit), (instance.toggled(), bit.toggled())] {
            self.descending(x.instance, x.bit, expectation, id: BitCountableID())
            
            if !T.isArbitrary {
                x.instance.withUnsafeBinaryIntegerBody {
                    self.descending($0, x.bit, expectation, id: BitCountableID())
                }
                
                x.instance.withUnsafeMutableBinaryIntegerBody {
                    self.descending($0, x.bit, expectation, id: BitCountableID())
                }
                
            }   else {
                x.instance.withUnsafeBinaryIntegerElements {
                    self.descending($0, x.bit, expectation, id: BitCountableID())
                }
                
                x.instance.withUnsafeMutableBinaryIntegerElements {
                    self.descending($0, x.bit, expectation, id: BitCountableID())
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Bit Countable
    //=------------------------------------------------------------------------=
    
    /// - Note: It tests `bit` and `bit.toggled()`.
    public func count<T>(
        _ instance: T,
        _ bit: Bit,
        _ expectation: Count,
        id: BitCountableID = .init()
    )   where T: BitCountable {
        //=--------------------------------------=
        let nonexpectation = Count(raw: IX(raw: instance.size()) - IX(raw: expectation))
        //=--------------------------------------=
        // path: count plus noncount is size
        //=--------------------------------------=
        always: do {
            let x0 = IX(raw: instance.count( bit))
            let x1 = IX(raw: instance.count(~bit))
            same(Count.init(raw: x0 + x1), instance.size(), "count(x) + noncount(x) == size()")
        }
        //=--------------------------------------=
        // path: count
        //=--------------------------------------=
        same(instance.count( bit),    expectation, "count [0]")
        same(instance.count(~bit), nonexpectation, "count [1]")
    }
    
    /// - Note: It tests `bit` and `bit.toggled()`.
    public func ascending<T>(
        _ instance: T,
        _ bit: Bit,
        _ expectation: Count,
        id: BitCountableID = .init()
    )   where T: BitCountable {
        //=--------------------------------------=
        let nonexpectation = Count(raw: IX(raw: instance.size()) - IX(raw: expectation))
        //=--------------------------------------=
        // path: count plus noncount is size
        //=--------------------------------------=
        for bit in [Bit.zero, Bit.one] {
            let x0 = IX(raw: instance   .ascending(bit))
            let x1 = IX(raw: instance.nonascending(bit))
            same(Count.init(raw: x0 + x1), instance.size(), "count(x) + noncount(x) == size()")
        }
        //=--------------------------------------=
        // path: ascending
        //=--------------------------------------=
        always: do {
            same(instance.ascending( bit), expectation, "ascending [0]")
    }
        
        if !(expectation).isZero {
            same(instance.ascending(~bit), Count.zero, "ascending [1]")
        }
        //=--------------------------------------=
        // path: nonascending
        //=--------------------------------------=
        always: do {
            same(instance.nonascending( bit), nonexpectation, "nonascending [0]")
        }
        
        if !(expectation).isZero {
            same(instance.nonascending(~bit), instance.size(), "nonascending [1]")
        }
    }
    
    /// - Note: It tests `bit` and `bit.toggled()`.
    public func descending<T>(
        _ instance: T,
        _ bit: Bit,
        _ expectation: Count,
        id: BitCountableID = .init()
    )   where T: BitCountable {
        //=--------------------------------------=
        let nonexpectation = Count(raw: IX(raw: instance.size()) - IX(raw: expectation))
        //=--------------------------------------=
        // path: count plus noncount is size
        //=--------------------------------------=
        for bit in [Bit.zero, Bit.one] {
            let x0 = IX(raw: instance   .descending(bit))
            let x1 = IX(raw: instance.nondescending(bit))
            same(Count.init(raw: x0 + x1), instance.size(), "count(x) + noncount(x) == size()")
        }
        //=--------------------------------------=
        // path: descending
        //=--------------------------------------=
        always: do {
            same(instance.descending( bit), expectation, "descending [0]")
        }
        
        if !(expectation).isZero {
            same(instance.descending(~bit), Count.zero, "descending [1]")
        }
        //=--------------------------------------=
        // path: nondescending
        //=--------------------------------------=
        always: do {
            same(instance.nondescending( bit), nonexpectation, "nondescending [0]")
        }

        if !(expectation).isZero {
            same(instance.nondescending(~bit), instance.size(), "nondescending [2]")
        }
        //=--------------------------------------=
        // path: entropy
        //=--------------------------------------=
        always: do {
            let expectation = IX(raw: instance.nondescending(instance.appendix)).incremented().unwrap()
            same(instance.entropy(), Count(raw: expectation), "entropy")
        }
    }
}
