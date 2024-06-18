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
        test.exactly( S.min, F( T(raw: S.min), error: T.isSigned == false))
        test.exactly( S.lsb, F( T(raw: S.lsb)))
        test.exactly( S.msb, F( T(raw: S.msb), error: T.isSigned == false))
        test.exactly( S.max, F( T(raw: S.max)))
        
        test.exactly(~S.min, F(~T(raw: S.min)))
        test.exactly(~S.lsb, F(~T(raw: S.lsb), error: T.isSigned == false))
        test.exactly(~S.msb, F(~T(raw: S.msb)))
        test.exactly(~S.max, F(~T(raw: S.max), error: T.isSigned == false))
        
        test.exactly( M.min, F( T(raw: M.min)))
        test.exactly( M.lsb, F( T(raw: M.lsb)))
        test.exactly( M.msb, F( T(raw: M.msb), error: T.isSigned == true ))
        test.exactly( M.max, F( T(raw: M.max), error: T.isSigned == true ))
        
        test.exactly(~M.min, F(~T(raw: M.min), error: T.isSigned == true))
        test.exactly(~M.lsb, F(~T(raw: M.lsb), error: T.isSigned == true))
        test.exactly(~M.msb, F(~T(raw: M.msb)))
        test.exactly(~M.max, F(~T(raw: M.max)))
        
        if  T.isSigned {
            test.exactly(M.msb,     F(T.msb,     error: true))
            test.exactly(M.msb + 1, F(T.msb + 1, error: true))
        }
    }
    
    public func exactlyCoreSystemsIntegers() {
        func whereOtherIs<Other>(_ other: Other.Type) where Other: SystemsInteger {
            typealias I = Other.Signitude
            typealias U = Other.Magnitude
            
            test.exactly( I.min, F( T(load:  I.min), error: T.size < I.size || (T.isSigned == false)))
            test.exactly( I.lsb, F( T(load:  I.lsb)))
            test.exactly( I.msb, F( T(load:  I.msb), error: T.size < I.size || (T.isSigned == false)))
            test.exactly( I.max, F( T(load:  I.max), error: T.size < I.size))
            
            test.exactly(~I.min, F(~T(load:  I.min), error: T.size < I.size))
            test.exactly(~I.lsb, F(~T(load:  I.lsb), error: T.isSigned == false))
            test.exactly(~I.msb, F(~T(load:  I.msb), error: T.size < I.size))
            test.exactly(~I.max, F(~T(load:  I.max), error: T.size < I.size || (T.isSigned == false)))
            
            test.exactly( U.min, F( T(load:  U.min)))
            test.exactly( U.lsb, F( T(load:  U.lsb)))
            test.exactly( U.msb, F( T(load:  U.msb), error: T.size < U.size || (T.isSigned && T.size == U.size)))
            test.exactly( U.max, F( T(load:  U.max), error: T.size < U.size || (T.isSigned && T.size == U.size)))
            
            test.exactly(~U.min, F( T(load: ~U.min), error: T.size < U.size || (T.isSigned && T.size == U.size)))
            test.exactly(~U.lsb, F( T(load: ~U.lsb), error: T.size < U.size || (T.isSigned && T.size == U.size)))
            test.exactly(~U.msb, F( T(load: ~U.msb), error: T.size < U.size))
            test.exactly(~U.max, F( T(load: ~U.max)))
        }
        
        for other in coreSystemsIntegers {
            whereOtherIs(other)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func clampingCoreSystemsIntegers() where T: EdgyInteger {
        func whereOtherIs<Other>(_ other: Other.Type) where Other: SystemsInteger {
            typealias I = Other.Signitude
            typealias U = Other.Magnitude
            
            branch: if !T.isSigned {
                test.same(T(clamping:  1 as Other), 1 as T, " 1 -> unsigned")
                test.same(T(clamping:  0 as Other), T.zero, " 0 -> unsigned")
                
                guard Other.isSigned else { break branch }
                
                test.same(T(clamping: -1 as Other), T.zero, "-1 -> unsigned")
                test.same(T.exactly(  -1 as Other), T.max.veto(true))
            }
            
            if  T.size < Other.size {
                test.same(T(clamping: Other(T.max) - 1), T.max - 1, "max - 1")
                test.same(T(clamping: Other(T.max)),     T.max,     "max")
                test.same(T(clamping: Other(T.max) + 1), T.max,     "max + 1")
                test.same(T.exactly(  Other(T.max) + 1), T.min.veto(true))
            }
            
            if  T.isSigned, Other.isSigned, T.size < Other.size {
                test.same(T.exactly(  Other(T.min) - 1), T.max.veto(true))
                test.same(T(clamping: Other(T.min) - 1), T.min,     "min - 1")
                test.same(T(clamping: Other(T.min)),     T.min,     "min")
                test.same(T(clamping: Other(T.min) + 1), T.min + 1, "min + 1")
            }
        }
        
        for other in coreSystemsIntegers {
            whereOtherIs(other)
        }
    }
}
