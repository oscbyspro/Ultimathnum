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
    )   where T: SystemsInteger {
        //=--------------------------------------=
        self.shift(instance, distance, expectation, direction, semantics, BinaryIntegerID())
        //=--------------------------------------=
        switch (direction, semantics) {
        case (.left,  .smart):
            break
            
        case (.right, .smart):
            break
            
        case (.left,  .masked):
            func with(_ distance: T) {
                same({         instance    &<<  distance           }(), expectation)
                same({ var x = instance; x &<<= distance; return x }(), expectation)
            }

            with(distance)
            with(distance &+ T(T.size))
            with(distance &+ T(T.size) &+ T(T.size))
            with(distance &- T(T.size))
            with(distance &- T(T.size) &- T(T.size))
            
        case (.right, .masked):
            func with(_ distance: T) {
                same({         instance    &>>  distance           }(), expectation)
                same({ var x = instance; x &>>= distance; return x }(), expectation)
            }

            with(distance)
            with(distance &+ T(T.size))
            with(distance &+ T(T.size) &+ T(T.size))
            with(distance &- T(T.size))
            with(distance &- T(T.size) &- T(T.size))
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
        case (.left, .smart):
            
            always: do {
                same({         instance    <<  distance           }(), expectation, "<<")
                same({ var x = instance; x <<= distance; return x }(), expectation, "<<=")
            }
            
            if  let distance = distance.negated().optional() {
                same({         instance    >>  distance           }(), expectation, ">>")
                same({ var x = instance; x >>= distance; return x }(), expectation, ">>=")
            }
            
            if  Shift.predicate(distance) {
                shift(instance, distance, expectation, .left, .masked)
            }
            
        case (.right, .smart):
            
            always: do {
                same({         instance    >>  distance           }(), expectation, ">>")
                same({ var x = instance; x >>= distance; return x }(), expectation, ">>=")
            }
            
            if  let distance = distance.negated().optional() {
                same({         instance    <<  distance           }(), expectation, "<<")
                same({ var x = instance; x <<= distance; return x }(), expectation, "<<=")
            }
            
            if  Shift.predicate(distance) {
                shift(instance, distance, expectation, .right, .masked)
            }
            
        case (.left, .masked):
            guard let distance = some(Shift(distance)) else { return }
            same({         instance    &<<  distance           }(), expectation, "&<<")
            same({ var x = instance; x &<<= distance; return x }(), expectation, "&<<=")
            
        case (.right, .masked):
            guard let distance = some(Shift(distance)) else { return }
            same({         instance    &>>  distance           }(), expectation, "&>>")
            same({ var x = instance; x &>>= distance; return x }(), expectation, "&>>=")
        }
    }
}
