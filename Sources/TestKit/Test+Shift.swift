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
    
    public func upshift<T, U>(
        _ instance: T,
        _ distance: U,
        _ expectation: T
    )   where T: SystemsInteger, U: BinaryInteger {
        //=----------------------------------=
        let size = IX(size: T.self)
        //=----------------------------------=
        always: do {
            upshift(instance, distance, expectation, id: BinaryIntegerID())
        }
        
        if  distance >= U.zero, distance < size {
            always: do {
                same({         instance    &<<  distance           }(), expectation,  "&<<")
                same({ var x = instance; x &<<= distance; return x }(), expectation, "&<<=")
            }
            
            if  let small = IX.exactly(distance).optional() {
                same({         instance    &<<  small           }(), expectation,  "&<< [IX]")
                same({ var x = instance; x &<<= small; return x }(), expectation, "&<<= [IX]")
                
                same({         instance    &<<  Swift.Int(small)           }(), expectation,  "&<< [Swift.Int]")
                same({ var x = instance; x &<<= Swift.Int(small); return x }(), expectation, "&<<= [Swift.Int]")
            }
            
            if  let size = U.exactly(IX(size: T.self)).optional() {
                for multiplier: U in [~2, ~1, ~0, 1, 2, 3] {
                    let distance = distance &+ size &* multiplier
                    
                    same({         instance    &<<  distance           }(), expectation,  "&<< [\(multiplier)]")
                    same({ var x = instance; x &<<= distance; return x }(), expectation, "&<<= [\(multiplier)]")
                }
            }
        }
    }
    
    public func upshift<T, U>(
        _ instance: T,
        _ distance: U,
        _ expectation: T,
        id: BinaryIntegerID = .init()
    )   where T: BinaryInteger, U: BinaryInteger {
            
        always: do {
            same({         instance    <<  distance           }(), expectation,  "<<")
            same({ var x = instance; x <<= distance; return x }(), expectation, "<<=")
        }
        
        if  let negated = distance.negated().optional() {
            same({         instance    >>  negated            }(), expectation,  ">> [-]")
            same({ var x = instance; x >>= negated;  return x }(), expectation, ">>= [-]")
        }
        
        if  let small = IX.exactly(distance).optional() {
            same({         instance    <<  Swift.Int(small)           }(), expectation,  "<< [Swift.Int]")
            same({ var x = instance; x <<= Swift.Int(small); return x }(), expectation, "<<= [Swift.Int]")
            
            if  let count = Count.exactly(small)?.optional() {
                same(instance.up(count), expectation, "BinaryInteger/up(Count)")
                
                if  let shift = Shift<T.Magnitude>(exactly: count) {
                    same(instance.up(shift), expectation, "BinaryInteger/up(Shift)")
                }
                
            }   else if let count = Count.exactly(small.complement())?.optional() {
                same(instance.down(count), expectation, "BinaryInteger/down(Count)")
                
                if  let shift = Shift<T.Magnitude>(exactly: count) {
                    same(instance.down(shift), expectation, "BinaryInteger/down(Shift)")
                }
            }
            
        }   else if distance.isNegative {
            same(instance.down(Count.infinity), expectation, "BinaryInteger/down(Count.infinity)")
                
        }   else {
            same(instance.up(Count.infinity), expectation, "BinaryInteger/up(Count.infinity)")
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Descending
    //=------------------------------------------------------------------------=
    
    public func downshift<T, U>(
        _ instance: T,
        _ distance: U,
        _ expectation: T
    )   where T: SystemsInteger, U: BinaryInteger {
        //=----------------------------------=
        let size = IX(size: T.self)
        //=----------------------------------=
        always: do {
            downshift(instance, distance, expectation, id: BinaryIntegerID())
        }
        
        if  distance >= U.zero, distance < size {
            always: do {
                same({         instance    &>>  distance           }(), expectation,  "&>>")
                same({ var x = instance; x &>>= distance; return x }(), expectation, "&>>=")
            }
            
            if  let small = IX.exactly(distance).optional() {
                same({         instance    &>>  small           }(), expectation,  "&>> [IX]")
                same({ var x = instance; x &>>= small; return x }(), expectation, "&>>= [IX]")
                
                same({         instance    &>>  Swift.Int(small)           }(), expectation,  "&>> [Swift.Int]")
                same({ var x = instance; x &>>= Swift.Int(small); return x }(), expectation, "&>>= [Swift.Int]")
            }
            
            if  let size = U.exactly(IX(size: T.self)).optional() {
                for multiplier: U in [~2, ~1, ~0, 1, 2, 3] {
                    let distance = distance &+ size &* multiplier
                    
                    same({         instance    &>>  distance           }(), expectation,  "&>> [\(multiplier)]")
                    same({ var x = instance; x &>>= distance; return x }(), expectation, "&>>= [\(multiplier)]")
                }
            }
        }
    }
    
    public func downshift<T, U>(
        _ instance: T,
        _ distance: U,
        _ expectation: T,
        id: BinaryIntegerID = .init()
    )   where T: BinaryInteger, U: BinaryInteger {
            
        always: do {
            same({         instance    >>  distance           }(), expectation,  ">>")
            same({ var x = instance; x >>= distance; return x }(), expectation, ">>=")
        }
        
        if  let negated = distance.negated().optional() {
            same({         instance    <<  negated            }(), expectation,  "<< [-]")
            same({ var x = instance; x <<= negated;  return x }(), expectation, "<<= [-]")
        }
        
        if  let small = IX.exactly(distance).optional() {
            same({         instance    >>  Swift.Int(small)           }(), expectation,  ">> [Swift.Int]")
            same({ var x = instance; x >>= Swift.Int(small); return x }(), expectation, ">>= [Swift.Int]")
            
            if  let count = Count.exactly(small)?.optional() {
                same(instance.down(count), expectation, "BinaryInteger/down(Count)")
                
                if  let shift = Shift<T.Magnitude>(exactly: count) {
                    same(instance.down(shift), expectation, "BinaryInteger/down(Shift)")
                }
                
            }   else if let count = Count.exactly(small.complement())?.optional() {
                same(instance.up(count), expectation, "BinaryInteger/up(Count)")
                
                if  let shift = Shift<T.Magnitude>(exactly: count) {
                    same(instance.up(shift), expectation, "BinaryInteger/up(Shift)")
                }
            }
            
        }   else if distance.isNegative {
            same(instance.up(Count.infinity), expectation, "BinaryInteger/up(Count.infinity)")
                
        }   else {
            same(instance.down(Count.infinity), expectation, "BinaryInteger/down(Count.infinity)")
        }
    }
}
