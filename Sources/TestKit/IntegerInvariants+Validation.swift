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
// MARK: * Integer Invariants x Validation
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func exactlySameSizeSystemsIntegers() where T: SystemsInteger {
        test.exactly( S.min, F( T(raw: S.min), error: !T.isSigned))
        test.exactly( S.lsb, F( T(raw: S.lsb)))
        test.exactly( S.msb, F( T(raw: S.msb), error: !T.isSigned))
        test.exactly( S.max, F( T(raw: S.max)))
        
        test.exactly(~S.min, F(~T(raw: S.min)))
        test.exactly(~S.lsb, F(~T(raw: S.lsb), error: !T.isSigned))
        test.exactly(~S.msb, F(~T(raw: S.msb)))
        test.exactly(~S.max, F(~T(raw: S.max), error: !T.isSigned))
        
        test.exactly( M.min, F( T(raw: M.min)))
        test.exactly( M.lsb, F( T(raw: M.lsb)))
        test.exactly( M.msb, F( T(raw: M.msb), error:  T.isSigned))
        test.exactly( M.max, F( T(raw: M.max), error:  T.isSigned))
        
        test.exactly(~M.min, F(~T(raw: M.min), error:  T.isSigned))
        test.exactly(~M.lsb, F(~T(raw: M.lsb), error:  T.isSigned))
        test.exactly(~M.msb, F(~T(raw: M.msb)))
        test.exactly(~M.max, F(~T(raw: M.max)))
        
        if  T.isSigned {
            test.exactly(M.msb,     F(T.msb,     error: true))
            test.exactly(M.msb + 1, F(T.msb + 1, error: true))
        }
    }
    
    public func exactlyCoreSystemsIntegers() {
        func whereOtherIs<U>(_  type:  U.Type) where U: SystemsInteger {
            //=----------------------------------=
            // path: about T.max as U
            //=----------------------------------=
            if  T.size < U.size || (T.size == U.size && (T.isSigned, U.isSigned) != (false, true)) {
                let max: T = Self.maxEsque
                let maxAsOther: U = U(repeating: 1) << U(load: UX(size: T.self)! - UX(Bit(T.isSigned))) ^ U(repeating: 1)
                
                test.exactly(maxAsOther &- 2, F(max &- 2))
                test.exactly(maxAsOther &- 1, F(max &- 1))
                test.exactly(maxAsOther,      F(max     ))
                test.exactly(maxAsOther &+ 1, F(max &+ 1, error: T.size < U.size || (T.isSigned != U.isSigned)))
                test.exactly(maxAsOther &+ 2, F(max &+ 2, error: T.size < U.size || (T.isSigned != U.isSigned)))
            }   else {
                test.exactly(Self.maxEsque, Fallible(U(repeating: 1), error: true))
            }
        }
        
        func whereOtherIsSigned<U>(_  type:  U.Type) where U: SystemsInteger & SignedInteger {
            let size = T(load: UX(size: U.self))
            //=----------------------------------=
            // path: about U.zero
            //=----------------------------------=
            always: do {
                let load = T.zero
                test.exactly(U(repeating: 0) - 2, F(load &- 2, error: !T.isSigned))
                test.exactly(U(repeating: 0) - 1, F(load &- 1, error: !T.isSigned))
                test.exactly(U(repeating: 0),     F(load     ))
                test.exactly(U(repeating: 0) + 1, F(load &+ 1))
                test.exactly(U(repeating: 0) + 2, F(load &+ 2))
            }
            //=----------------------------------=
            // path: about U.min
            //=----------------------------------=
            always: do {
                let load = T(repeating: 1) << (size - 1)
                test.exactly(U.min,      F(load,      error: T.size < U.size || !T.isSigned))
                test.exactly(U.min &+ 1, F(load &+ 1, error: T.size < U.size || !T.isSigned))
                test.exactly(U.min &+ 2, F(load &+ 2, error: T.size < U.size || !T.isSigned))
            }
            //=----------------------------------=
            // path: about U.max
            //=----------------------------------=
            always: do {
                let load = T(repeating: 1) << (size - 1) ^ T(repeating: 1)
                test.exactly(U.max,      F(load,      error: T.size < U.size))
                test.exactly(U.max &- 1, F(load &- 1, error: T.size < U.size))
                test.exactly(U.max &- 2, F(load &- 2, error: T.size < U.size))
            }
            //=----------------------------------=
            // path: about T.min as U
            //=----------------------------------=
            if  T.isSigned, T.size <= U.size {
                let min: T = Self.minEsque
                let minAsOther: U = U(repeating: 1) << U(load: UX(size: T.self)! - 1)
                
                test.exactly(minAsOther &- 2, F(min &- 2, error: T.size < U.size))
                test.exactly(minAsOther &- 1, F(min &- 1, error: T.size < U.size))
                test.exactly(minAsOther,      F(min     ))
                test.exactly(minAsOther &+ 1, F(min &+ 1))
                test.exactly(minAsOther &+ 2, F(min &+ 2))
            }
        }
        
        func whereOtherIsUnsigned<U>(_ type: U.Type) where U: SystemsInteger & UnsignedInteger {
            let size = T(load: UX(size: U.self))
            //=----------------------------------=
            // path: about U.min
            //=----------------------------------=
            always: do {
                let load = T.zero
                test.exactly(U(repeating: 0),     F(load    ))
                test.exactly(U(repeating: 0) + 1, F(load + 1))
                test.exactly(U(repeating: 0) + 2, F(load + 2))
            }
            //=----------------------------------=
            // path: about U.max
            //=----------------------------------=
            always: do {
                let load = T(repeating: 1) << size ^ T(repeating: 1)
                test.exactly(U(repeating: 1) - 2, F(load - 2, error: T.size < U.size || (T.isSigned && T.size == U.size)))
                test.exactly(U(repeating: 1) - 1, F(load - 1, error: T.size < U.size || (T.isSigned && T.size == U.size)))
                test.exactly(U(repeating: 1),     F(load,     error: T.size < U.size || (T.isSigned && T.size == U.size)))
            }
            //=----------------------------------=
            // path: about U.msb
            //=----------------------------------=
            always: do {
                let load = T(1) << (size - 1)
                test.exactly(U.msb - 2, F(load &- 2, error: T.size < U.size))
                test.exactly(U.msb - 1, F(load &- 1, error: T.size < U.size))
                test.exactly(U.msb,     F(load,      error: T.size < U.size || (T.isSigned && T.size == U.size)))
                test.exactly(U.msb + 1, F(load &+ 1, error: T.size < U.size || (T.isSigned && T.size == U.size)))
                test.exactly(U.msb + 2, F(load &+ 2, error: T.size < U.size || (T.isSigned && T.size == U.size)))
            }
        }
        
        for type in coreSystemsIntegers {
            whereOtherIs(type)
        }
        
        for type in coreSystemsIntegersWhereIsSigned {
            whereOtherIsSigned(type)
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereOtherIsUnsigned(type)
        }
    }
}
