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
    
    /// An ascending or descending shift direction.
    public enum ShiftDirection: Equatable {
        case up
        case down
    }
    
    /// - Note: The `masked` shift case is from the `exact` shift case.
    public enum ShiftSemantics: Equatable {
        case smart
        case exact
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func shift<T>(
        _ instance: T,
        _ distance: T,
        _ expectation: T,
        _ direction: ShiftDirection,
        _ semantics: ShiftSemantics
    )   where T: SystemsInteger {
        //=--------------------------------------=
        self.shift(instance, distance, expectation, direction, semantics, BinaryIntegerID())
        //=--------------------------------------=
        switch (direction, semantics) {
        case (.up, .smart):
            break
            
        case (.down, .smart):
            break
            
        case (.up, .exact):
            for multiplier:  T in [~2, ~1, ~0, 0, 1, 2] {
                let distance = distance &+ T(T.size) &* multiplier
                same({         instance    &<<  distance           }(), expectation)
                same({ var x = instance; x &<<= distance; return x }(), expectation)
            }
            
        case (.down, .exact):
            for multiplier:  T in [~2, ~1, ~0, 0, 1, 2] {
                let distance = distance &+ T(T.size) &* multiplier
                same({         instance    &>>  distance           }(), expectation)
                same({ var x = instance; x &>>= distance; return x }(), expectation)
            }
        }
    }
    
    public func shift<T>(
        _ instance: T, 
        _ distance: T,
        _ expectation: T,
        _ direction: ShiftDirection,
        _ semantics: ShiftSemantics,
        _ id: BinaryIntegerID = .init()
    )   where T: BinaryInteger {
        
        switch (direction, semantics) {
        case (.up, .smart):
            always: do {
                same({         instance    <<  distance           }(), expectation,  "<< [L]")
                same({ var x = instance; x <<= distance; return x }(), expectation, "<<= [L]")
            }
            
            if  let distance = distance.negated().optional() {
                same({         instance    >>  distance           }(), expectation,  ">> [L]")
                same({ var x = instance; x >>= distance; return x }(), expectation, ">>= [L]")
            }
            
            if  Shift.predicate(distance) {
                shift(instance, distance, expectation, .up, .exact)
            }
            
        case (.down, .smart):
            always: do {
                same({         instance    >>  distance           }(), expectation,  ">> [R]")
                same({ var x = instance; x >>= distance; return x }(), expectation, ">>= [R]")
            }
            
            if  let distance = distance.negated().optional() {
                same({         instance    <<  distance           }(), expectation,  "<< [R]")
                same({ var x = instance; x <<= distance; return x }(), expectation, "<<= [R]")
            }
            
            if  Shift.predicate(distance) {
                shift(instance, distance, expectation, .down, .exact)
            }
            
        case (.up, .exact):
            if  let distance = some(Shift(exactly: distance)) {
                same(instance.upshift(distance), expectation, "up")
            }
            
        case (.down, .exact):
            if  let distance = some(Shift(exactly: distance)) {
                same(instance.downshift(distance), expectation, "down")
            }
        }
    }
}
