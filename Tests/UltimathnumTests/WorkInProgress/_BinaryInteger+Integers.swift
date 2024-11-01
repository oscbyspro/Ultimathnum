//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Validation
//*============================================================================*

final class BinaryIntegerTestsOnValidation: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testExactlySameSizeIntegers() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            typealias S = T.Signitude
            typealias M = T.Magnitude
            
            Test().exactly( Esque<S>.min, Fallible( T(raw: Esque<S>.min), error: !T.isSigned))
            Test().exactly( Esque<S>.lsb, Fallible( T(raw: Esque<S>.lsb)))
            Test().exactly( Esque<S>.msb, Fallible( T(raw: Esque<S>.msb), error: !T.isSigned))
            Test().exactly( Esque<S>.max, Fallible( T(raw: Esque<S>.max)))
            
            Test().exactly(~Esque<S>.min, Fallible(~T(raw: Esque<S>.min)))
            Test().exactly(~Esque<S>.lsb, Fallible(~T(raw: Esque<S>.lsb), error: !T.isSigned))
            Test().exactly(~Esque<S>.msb, Fallible(~T(raw: Esque<S>.msb)))
            Test().exactly(~Esque<S>.max, Fallible(~T(raw: Esque<S>.max), error: !T.isSigned))
            
            Test().exactly( Esque<M>.min, Fallible( T(raw: Esque<M>.min)))
            Test().exactly( Esque<M>.lsb, Fallible( T(raw: Esque<M>.lsb)))
            Test().exactly( Esque<M>.msb, Fallible( T(raw: Esque<M>.msb), error:  T.isSigned && !T.isArbitrary))
            Test().exactly( Esque<M>.max, Fallible( T(raw: Esque<M>.max), error:  T.isSigned))
            
            Test().exactly(~Esque<M>.min, Fallible(~T(raw: Esque<M>.min), error:  T.isSigned))
            Test().exactly(~Esque<M>.lsb, Fallible(~T(raw: Esque<M>.lsb), error:  T.isSigned))
            Test().exactly(~Esque<M>.msb, Fallible(~T(raw: Esque<M>.msb), error: !T.isEdgy))
            Test().exactly(~Esque<M>.max, Fallible(~T(raw: Esque<M>.max)))
            
            if  T.isSigned, !T.isArbitrary {
                Test().exactly(Esque<M>.msb,     Fallible(Esque<T>.msb,     error: true))
                Test().exactly(Esque<M>.msb + 1, Fallible(Esque<T>.msb + 1, error: true))
            }
        }
        
        for type in typesAsBinaryInteger {
            whereIs(type)
        }
    }
    
    func testExactlySystemsInteger() {
        func whereTheSourceIs<T, U>(source: T.Type, destination: U.Type) where T: SystemsInteger, U: BinaryInteger {
            //=----------------------------------=
            // path: about T.max as U
            //=----------------------------------=
            if  U.size < T.size || (U.size == T.size && (U.isSigned, T.isSigned) != (false, true)) {
                let max: U = Esque<U>.max
                let maxAsOther: T = T(repeating: Bit.one) << T(load: UX(size: U.self)! - UX(Bit(U.isSigned))) ^ T(repeating: Bit.one)
                
                Test().exactly(maxAsOther &- 2, Fallible(max &- 2))
                Test().exactly(maxAsOther &- 1, Fallible(max &- 1))
                Test().exactly(maxAsOther,      Fallible(max     ))
                Test().exactly(maxAsOther &+ 1, Fallible(max &+ 1, error: U.size < T.size || (U.isSigned != T.isSigned)))
                Test().exactly(maxAsOther &+ 2, Fallible(max &+ 2, error: U.size < T.size || (U.isSigned != T.isSigned)))
            }   else {
                Test().exactly(Esque<U>.max, Fallible(T(repeating: Bit.one), error: true))
            }
        }
        
        func whereTheSourceIsIsSigned<T, U>(source: T.Type, destination: U.Type) where T: SystemsInteger & SignedInteger, U: BinaryInteger {
            let size = UX(size: T.self)
            //=----------------------------------=
            // path: about U.zero
            //=----------------------------------=
            always: do {
                let load = U.zero
                Test().exactly(T(repeating: Bit.zero) - 2, Fallible(load &- 2, error: !U.isSigned))
                Test().exactly(T(repeating: Bit.zero) - 1, Fallible(load &- 1, error: !U.isSigned))
                Test().exactly(T(repeating: Bit.zero),     Fallible(load     ))
                Test().exactly(T(repeating: Bit.zero) + 1, Fallible(load &+ 1))
                Test().exactly(T(repeating: Bit.zero) + 2, Fallible(load &+ 2))
            }
            //=----------------------------------=
            // path: about U.min
            //=----------------------------------=
            always: do {
                let load = U(repeating: Bit.one) << (size - 1)
                Test().exactly(T.min,      Fallible(load,      error: U.size < T.size || !U.isSigned))
                Test().exactly(T.min &+ 1, Fallible(load &+ 1, error: U.size < T.size || !U.isSigned))
                Test().exactly(T.min &+ 2, Fallible(load &+ 2, error: U.size < T.size || !U.isSigned))
            }
            //=----------------------------------=
            // path: about U.max
            //=----------------------------------=
            always: do {
                let load = U(repeating: Bit.one) << (size - 1) ^ U(repeating: Bit.one)
                Test().exactly(T.max,      Fallible(load,      error: U.size < T.size))
                Test().exactly(T.max &- 1, Fallible(load &- 1, error: U.size < T.size))
                Test().exactly(T.max &- 2, Fallible(load &- 2, error: U.size < T.size))
            }
            //=----------------------------------=
            // path: about T.min as U
            //=----------------------------------=
            if  U.isSigned, U.size <= T.size {
                let min: U = Esque<U>.min
                let minAsOther: T = T(repeating: Bit.one) << T(load: UX(size: U.self)! - 1)
                
                Test().exactly(minAsOther &- 2, Fallible(min &- 2, error: U.size < T.size))
                Test().exactly(minAsOther &- 1, Fallible(min &- 1, error: U.size < T.size))
                Test().exactly(minAsOther,      Fallible(min     ))
                Test().exactly(minAsOther &+ 1, Fallible(min &+ 1))
                Test().exactly(minAsOther &+ 2, Fallible(min &+ 2))
            }
        }
        
        func whereTheSourceIsUnsigned<T, U>(source: T.Type, destination: U.Type) where T: SystemsInteger & UnsignedInteger, U: BinaryInteger {
            let size = UX(size: T.self)
            //=----------------------------------=
            // path: about U.min
            //=----------------------------------=
            always: do {
                let load = U.zero
                Test().exactly(T(repeating: Bit.zero),     Fallible(load    ))
                Test().exactly(T(repeating: Bit.zero) + 1, Fallible(load + 1))
                Test().exactly(T(repeating: Bit.zero) + 2, Fallible(load + 2))
            }
            //=----------------------------------=
            // path: about U.max
            //=----------------------------------=
            always: do {
                let load = U(repeating: Bit.one) << size ^ U(repeating: Bit.one)
                Test().exactly(T(repeating: Bit.one) - 2, Fallible(load - 2, error: U.size < T.size || (U.isSigned && U.size == T.size)))
                Test().exactly(T(repeating: Bit.one) - 1, Fallible(load - 1, error: U.size < T.size || (U.isSigned && U.size == T.size)))
                Test().exactly(T(repeating: Bit.one),     Fallible(load,     error: U.size < T.size || (U.isSigned && U.size == T.size)))
            }
            //=----------------------------------=
            // path: about U.msb
            //=----------------------------------=
            always: do {
                let load = U(1) << (size - 1)
                Test().exactly(T.msb - 2, Fallible(load &- 2, error: U.size < T.size))
                Test().exactly(T.msb - 1, Fallible(load &- 1, error: U.size < T.size))
                Test().exactly(T.msb,     Fallible(load,      error: U.size < T.size || (U.isSigned && U.size == T.size)))
                Test().exactly(T.msb + 1, Fallible(load &+ 1, error: U.size < T.size || (U.isSigned && U.size == T.size)))
                Test().exactly(T.msb + 2, Fallible(load &+ 2, error: U.size < T.size || (U.isSigned && U.size == T.size)))
            }
        }
        
        for destination in typesAsBinaryInteger {
            for source in typesAsSystemsInteger {
                whereTheSourceIs(source: source, destination: destination)
            }
            
            for source in typesAsSystemsIntegerAsSigned {
                whereTheSourceIsIsSigned(source: source, destination: destination)
            }
            
            for source in typesAsSystemsIntegerAsUnsigned {
                whereTheSourceIsUnsigned(source: source, destination: destination)
            }
        }
    }
}
