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
// MARK: * Shift
//*============================================================================*

@Suite struct ShiftTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Shift.instance", arguments: typesAsBinaryIntegerAsUnsigned)
    func instances(_ type: any UnsignedInteger.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: UnsignedInteger {
            #expect(Shift<T>.min == Shift<T>(Count(raw: 0 as IX)))
            #expect(Shift<T>.one == Shift<T>(Count(raw: 1 as IX)))
            #expect(Shift<T>.max == Shift<T>(Count(raw: IX(raw: T.size) - 1)))
        }
    }
    
    @Test("Shift.predicate(_:)", arguments: typesAsBinaryIntegerAsUnsigned)
    func predicate(_ type: any UnsignedInteger.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: UnsignedInteger {
            always: do {
                #expect( Shift<T>.predicate(Count(raw:  0 as IX)))
                #expect( Shift<T>.predicate(Count(raw:  1 as IX)))
                #expect( Shift<T>.predicate(Count(raw:  2 as IX)))
            }
            
            if !T.size.isInfinite {
                #expect(!Shift<T>.predicate(Count(raw: ~2 as IX)))
                #expect(!Shift<T>.predicate(Count(raw: ~1 as IX)))
                #expect(!Shift<T>.predicate(Count(raw: ~0 as IX)))
            }   else {
                #expect( Shift<T>.predicate(Count(raw: ~2 as IX)))
                #expect( Shift<T>.predicate(Count(raw: ~1 as IX)))
                #expect(!Shift<T>.predicate(Count(raw: ~0 as IX)))
            }
            
            if  let size: IX = T.size.natural().optional() {
                #expect( Shift<T>.predicate(Count(size - 1)))
                #expect(!Shift<T>.predicate(Count(size    )))
                #expect(!Shift<T>.predicate(Count(size + 1)))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Shift.init - [entropic]", arguments: typesAsBinaryInteger, fuzzers)
    func initByFuzzingEntropies(_ type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for _ in 0 ..< 128 {
                let random = Count(raw: IX.entropic(using: &randomness))
                Ɣexpect(random, as: Shift<T.Magnitude>.self, if: random < T.size)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Shift/isZero - load each I8", arguments: typesAsBinaryIntegerAsUnsigned)
    func isZero(_ type: any UnsignedInteger.Type) {
        whereIs(type)

        func whereIs<T>(_ type: T.Type) where T: UnsignedInteger {
            for relative: IX in I8.all.lazy.map(IX.init) {
                if  let shift = Shift<T>(exactly: Count(raw: relative)) {
                    #expect(shift.isZero == relative.isZero)
                }
            }
        }
    }
    
    @Test("Shift/isInfinite - load each I8", arguments: typesAsBinaryIntegerAsUnsigned)
    func isInfinite(_ type: any UnsignedInteger.Type) {
        whereIs(type)

        func whereIs<T>(_ type: T.Type) where T: UnsignedInteger {
            for relative: IX in I8.all.lazy.map(IX.init) {
                if  let shift = Shift<T>(exactly: Count(raw: relative)) {
                    #expect(shift.isInfinite == relative.isNegative)
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// - 2024-06-15: Checks that the inverse of zero is nil.
    @Test("Shift/inverse()", arguments: typesAsBinaryIntegerAsUnsigned)
    func inverse(_ type: any UnsignedInteger.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: UnsignedInteger {
            //=----------------------------------=
            let size = IX(raw: T.size)
            //=----------------------------------=
            #expect(Shift<T>(Count(0 as IX)).inverse() == nil)
            #expect(Shift<T>(Count(1 as IX)).inverse() == Shift(Count(raw: size - 1)))
            #expect(Shift<T>(Count(2 as IX)).inverse() == Shift(Count(raw: size - 2)))
            #expect(Shift<T>(Count(3 as IX)).inverse() == Shift(Count(raw: size - 3)))
            #expect(Shift<T>(Count(4 as IX)).inverse() == Shift(Count(raw: size - 4)))
            #expect(Shift<T>(Count(5 as IX)).inverse() == Shift(Count(raw: size - 5)))
            #expect(Shift<T>(Count(6 as IX)).inverse() == Shift(Count(raw: size - 6)))
            #expect(Shift<T>(Count(7 as IX)).inverse() == Shift(Count(raw: size - 7)))
            
            #expect(Shift<T>.predicate(T.size) == false)
            #expect(Shift<T>(Count(raw: size - 1)).inverse() == Shift(Count(1 as IX)))
            #expect(Shift<T>(Count(raw: size - 2)).inverse() == Shift(Count(2 as IX)))
            #expect(Shift<T>(Count(raw: size - 3)).inverse() == Shift(Count(3 as IX)))
            #expect(Shift<T>(Count(raw: size - 4)).inverse() == Shift(Count(4 as IX)))
            #expect(Shift<T>(Count(raw: size - 5)).inverse() == Shift(Count(5 as IX)))
            #expect(Shift<T>(Count(raw: size - 6)).inverse() == Shift(Count(6 as IX)))
            #expect(Shift<T>(Count(raw: size - 7)).inverse() == Shift(Count(7 as IX)))
            
            if  T.size.isInfinite {
                #expect(Shift<T>(Count(raw: IX.max    )).inverse() == Shift(Count(raw: IX.min    )))
                #expect(Shift<T>(Count(raw: IX.max - 1)).inverse() == Shift(Count(raw: IX.min + 1)))
                #expect(Shift<T>(Count(raw: IX.min    )).inverse() == Shift(Count(raw: IX.max    )))
                #expect(Shift<T>(Count(raw: IX.min + 1)).inverse() == Shift(Count(raw: IX.max - 1)))
            }
        }
    }

    @Test("Shift/natural()", arguments: typesAsBinaryIntegerAsUnsigned)
    func natural(_ type: any UnsignedInteger.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: UnsignedInteger {
            //=----------------------------------=
            let size = IX(raw: T.size)
            //=----------------------------------=
            #expect(Shift<T>(Count(0 as IX)).natural() == Fallible(0 as IX))
            #expect(Shift<T>(Count(1 as IX)).natural() == Fallible(1 as IX))
            #expect(Shift<T>(Count(2 as IX)).natural() == Fallible(2 as IX))
            #expect(Shift<T>(Count(3 as IX)).natural() == Fallible(3 as IX))
            #expect(Shift<T>(Count(4 as IX)).natural() == Fallible(4 as IX))
            #expect(Shift<T>(Count(5 as IX)).natural() == Fallible(5 as IX))
            #expect(Shift<T>(Count(6 as IX)).natural() == Fallible(6 as IX))
            #expect(Shift<T>(Count(7 as IX)).natural() == Fallible(7 as IX))
            
            #expect(Shift<T>.predicate(T.size) == false)
            #expect(Shift<T>(Count(raw: size - 1)).natural() == Fallible(size - 1, error: T.size.isInfinite))
            #expect(Shift<T>(Count(raw: size - 2)).natural() == Fallible(size - 2, error: T.size.isInfinite))
            #expect(Shift<T>(Count(raw: size - 3)).natural() == Fallible(size - 3, error: T.size.isInfinite))
            #expect(Shift<T>(Count(raw: size - 4)).natural() == Fallible(size - 4, error: T.size.isInfinite))
            #expect(Shift<T>(Count(raw: size - 5)).natural() == Fallible(size - 5, error: T.size.isInfinite))
            #expect(Shift<T>(Count(raw: size - 6)).natural() == Fallible(size - 6, error: T.size.isInfinite))
            #expect(Shift<T>(Count(raw: size - 7)).natural() == Fallible(size - 7, error: T.size.isInfinite))
            
            if  T.size.isInfinite {
                #expect(Shift<T>(Count(raw: IX.max    )).natural() == Fallible(IX.max    ))
                #expect(Shift<T>(Count(raw: IX.max - 1)).natural() == Fallible(IX.max - 1))
                #expect(Shift<T>(Count(raw: IX.min    )).natural() == Fallible(IX.min,     error: true))
                #expect(Shift<T>(Count(raw: IX.min + 1)).natural() == Fallible(IX.min + 1, error: true))
            }
        }
    }
}
