//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import XCTest

//*============================================================================*
// MARK: * Test x Shift
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Ascending
    //=------------------------------------------------------------------------=
    
    public func upshift<T>(
        _ instance: T,
        _ distance: T,
        _ expectation: T
    )   where T: SystemsInteger {
        
        always: do {
            upshift(instance, distance, expectation, id: BinaryIntegerID())
        }
        
        if  distance >= .zero, distance < T.size {
            for multiplier: T in [~2, ~1, ~0, 0, 1, 2] {
                let distance = distance &+ T(T.size) &* multiplier
                same({         instance    &<<  distance           }(), expectation,  "&<<")
                same({ var x = instance; x &<<= distance; return x }(), expectation, "&<<=")
            }
        }
    }
    
    public func upshift<T>(
        _ instance: T,
        _ distance: T,
        _ expectation: T,
        id: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        
        always: do {
            upshiftOneWaySmart(instance, distance, expectation)
        }
        
        if  let negated = distance.negated().optional() {
            downshiftOneWaySmart(instance, negated, expectation)
        }
        
        if  let size = T.exactly(T.size).optional() {
            if  distance.isNegative {
                if let full = distance.minus(size).optional() {
                    self  .upshiftOneWaySmart(instance, full, T(repeating: instance.appendix))
                    self.downshiftOneWaySmart(instance, full, T(repeating: Bit.zero))
                }
                
            }   else {
                if let full = distance.plus (size).optional() {
                    self  .upshiftOneWaySmart(instance, full, T(repeating: Bit.zero))
                    self.downshiftOneWaySmart(instance, full, T(repeating: instance.appendix))
                }
            }
        }
    }
    
    public func upshiftOneWaySmart<T>(
        _ instance: T,
        _ distance: T,
        _ expectation: T
    )   where T: BinaryInteger {
        
        if  let distance = Shift<T.Magnitude>(exactly: T.Magnitude(raw: distance)) {
            same(instance.up(distance), expectation, "up")
        }
        
        always: do {
            same({         instance    <<  distance           }(), expectation,  "<<")
            same({ var x = instance; x <<= distance; return x }(), expectation, "<<=")
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Descending
    //=------------------------------------------------------------------------=
    
    public func downshift<T>(
        _ instance: T,
        _ distance: T,
        _ expectation: T
    )   where T: SystemsInteger {
        
        always: do {
            downshift(instance, distance, expectation, id: BinaryIntegerID())
        }
        
        if  distance >= .zero, distance < T.size {
            for multiplier: T in [~2, ~1, ~0, 0, 1, 2] {
                let distance = distance &+ T(T.size) &* multiplier
                same({         instance    &>>  distance           }(), expectation,  "&>>")
                same({ var x = instance; x &>>= distance; return x }(), expectation, "&>>=")
            }
        }
    }
    
    public func downshift<T>(
        _ instance: T,
        _ distance: T,
        _ expectation: T,
        id: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        
        always: do {
            downshiftOneWaySmart(instance, distance, expectation)
        }
        
        if  let negated = distance.negated().optional() {
            upshiftOneWaySmart(instance, negated, expectation)
        }
        
        if  let size = T.exactly(T.size).optional() {
            if  distance.isNegative {
                if let full = distance.minus(size).optional() {
                    self  .upshiftOneWaySmart(instance, full, T(repeating: instance.appendix))
                    self.downshiftOneWaySmart(instance, full, T(repeating: Bit.zero))
                }
                
            }   else {
                if let full = distance.plus (size).optional() {
                    self  .upshiftOneWaySmart(instance, full, T(repeating: Bit.zero))
                    self.downshiftOneWaySmart(instance, full, T(repeating: instance.appendix))
                }
            }
        }
    }
    
    public func downshiftOneWaySmart<T>(
        _ instance: T,
        _ distance: T,
        _ expectation: T
    )   where T: BinaryInteger {
        
        if  let distance = Shift<T.Magnitude>(exactly: T.Magnitude(raw: distance)) {
            same(instance.down(distance), expectation, "down")
        }
        
        always: do {
            same({         instance    >>  distance           }(), expectation,  ">>")
            same({ var x = instance; x >>= distance; return x }(), expectation, ">>=")
        }
    }
}
