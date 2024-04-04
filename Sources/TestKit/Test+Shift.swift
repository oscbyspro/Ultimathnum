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
    
    public enum ShiftDirection: Equatable { case left,  right  }
    
    public enum ShiftSemantics: Equatable { case smart, masked }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func shift<T>(
        _ instance: T, 
        _ distance: T,
        _ expectation: T,
        _ direction: ShiftDirection,
        _ semantics: ShiftSemantics
    )   where T: BinaryInteger {
        switch (direction, semantics) {
        case (.left, .smart):
            
            brr: do {
                same({         instance    <<  distance           }(), expectation)
                same({ var x = instance; x <<= distance; return x }(), expectation)
            }
            
            if  let distance = distance.negated().optional() {
                same({         instance    >>  distance           }(), expectation)
                same({ var x = instance; x >>= distance; return x }(), expectation)
            }
            
            if !distance.isLessThanZero, distance.magnitude() < T.bitWidth {
                shift(instance, distance, expectation, .left,  .masked)
            }
            
        case (.right, .smart):
            
            brr: do {
                same({         instance    >>  distance           }(), expectation)
                same({ var x = instance; x >>= distance; return x }(), expectation)
            }
            
            if  let distance = distance.negated().optional() {
                same({         instance    <<  distance           }(), expectation)
                same({ var x = instance; x <<= distance; return x }(), expectation)
            }
            
            if !distance.isLessThanZero, distance.magnitude() < T.bitWidth {
                shift(instance, distance, expectation, .right, .masked)
            }
            
        case (.left, .masked):
            
            func with(_ distance: T) {
                same({         instance    &<<  distance           }(), expectation)
                same({ var x = instance; x &<<= distance; return x }(), expectation)
            }
            
            with(distance)
            
            if  let increment = try? T.exactly(magnitude: T.bitWidth).get() {
                if  let distance = try? distance.plus(increment).get() {
                    with(distance)
                }
                
                if  let distance = try? distance.plus(increment).plus(increment).get() {
                    with(distance)
                }
                
                if  let distance = try? distance.minus(increment).get() {
                    with(distance)
                }
                
                if  let distance = try? distance.minus(increment).minus(increment).get() {
                    with(distance)
                }
            }
            
        case (.right, .masked):
            
            func with(_ distance: T) {
                same({         instance    &>>  distance           }(), expectation)
                same({ var x = instance; x &>>= distance; return x }(), expectation)
            }

            with(distance)
            
            if  let increment = try? T.exactly(magnitude: T.bitWidth).get() {
                if  let distance = try? distance.plus(increment).get() {
                    with(distance)
                }
                
                if  let distance = try? distance.plus(increment).plus(increment).get() {
                    with(distance)
                }
                
                if  let distance = try? distance.minus(increment).get() {
                    with(distance)
                }
                
                if  let distance = try? distance.minus(increment).minus(increment).get() {
                    with(distance)
                }
            }
            
        }
    }
}
