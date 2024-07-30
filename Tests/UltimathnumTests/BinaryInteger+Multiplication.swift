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
// MARK: * Binary Integer x Multiplication
//*============================================================================*

final class BinaryIntegerTestsOnMultiplication: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplicationOfMsbEsque() {
        func whereIsBinaryInteger<T>(_ type: T.Type) where T: BinaryInteger {
            //=----------------------------------=
            let shl = Esque<T>.shl
            let msb = Esque<T>.msb
            let bot = Esque<T>.bot
            let xor = T(repeating: Bit(T.isSigned))
            let add = T(Bit(T.isSigned))
            //=----------------------------------=
            Test().multiplication(msb, msb, Fallible(((msb    ) << shl) ^ xor &+ add, error: !T.isArbitrary))
            Test().multiplication(msb, bot, Fallible(((bot    ) << shl) ^ xor &+ add, error: !T.isArbitrary))
            Test().multiplication(bot, msb, Fallible(((bot    ) << shl) ^ xor &+ add, error: !T.isArbitrary))
            Test().multiplication(bot, bot, Fallible(((bot ^ 1) << shl) | 0000000001, error: !T.isArbitrary))
            //=--------------------------------------=
            Test().multiplication(bot,  ~4, Fallible(0 &- (bot << 2) &- bot, error:  T.isEdgy))
            Test().multiplication(bot,  ~3, Fallible(0 &- (bot << 2),        error:  T.isEdgy))
            Test().multiplication(bot,  ~2, Fallible(0 &- (bot << 1) &- bot, error:  T.isEdgy))
            Test().multiplication(bot,  ~1, Fallible(0 &- (bot << 1),        error:  T.isEdgy))
            Test().multiplication(bot,  ~0, Fallible(0 &- (bot),             error: !T.isSigned))
            Test().multiplication(bot,   0, Fallible(     (000)))
            Test().multiplication(bot,   1, Fallible(     (bot)))
            Test().multiplication(bot,   2, Fallible(     (bot << 1),        error: !T.isArbitrary && T.isSigned))
            Test().multiplication(bot,   3, Fallible(     (bot << 1) &+ bot, error: !T.isArbitrary))
            Test().multiplication(bot,   4, Fallible(     (bot << 2),        error: !T.isArbitrary))
            
            Test().multiplication(msb,  ~4, Fallible(0 &- (msb << 2) &- msb, error:  T.isEdgy))
            Test().multiplication(msb,  ~3, Fallible(0 &- (msb << 2),        error:  T.isEdgy))
            Test().multiplication(msb,  ~2, Fallible(0 &- (msb << 1) &- msb, error:  T.isEdgy))
            Test().multiplication(msb,  ~1, Fallible(0 &- (msb << 1),        error:  T.isEdgy))
            Test().multiplication(msb,  ~0, Fallible(0 &- (msb),             error:  T.isEdgy))
            Test().multiplication(msb,   0, Fallible(     (000)))
            Test().multiplication(msb,   1, Fallible(     (msb)))
            Test().multiplication(msb,   2, Fallible(     (msb << 1),        error: !T.isArbitrary))
            Test().multiplication(msb,   3, Fallible(     (msb << 1) &+ msb, error: !T.isArbitrary))
            Test().multiplication(msb,   4, Fallible(     (msb << 2),        error: !T.isArbitrary))
        }
        
        func whereIsSystemsInteger<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias D = Doublet<T>
            typealias F = Fallible<D>
            //=----------------------------------=
            let msb = T.msb
            let bot = T.msb.toggled()
            //=----------------------------------=
            always: do {
                Test().multiplication(msb, msb, F(D(low:  0000 as M, high:  T(raw:  M.msb >> 1)), error: true))
                Test().multiplication(msb, bot, F(D(low:  M.msb,     high:  T(raw:    msb >> 1) - T(Bit(!T.isSigned))), error: true))
                Test().multiplication(bot, msb, F(D(low:  M.msb,     high:  T(raw:    msb >> 1) - T(Bit(!T.isSigned))), error: true))
                Test().multiplication(bot, bot, F(D(low:  0001 as M, high:  T(raw: ~M.msb >> 1)), error: true))
            };  if T.isSigned {
                Test().multiplication(bot,  ~4, F(D(low:  M.msb + 5, high: ~02 as T), error: true))
                Test().multiplication(bot,  ~3, F(D(low:  0004 as M, high: ~01 as T), error: true))
                Test().multiplication(bot,  ~2, F(D(low:  M.msb + 3, high: ~01 as T), error: true))
                Test().multiplication(bot,  ~1, F(D(low:  0002 as M, high: ~00 as T), error: true))
                Test().multiplication(bot,  ~0, F(D(low:  M.msb + 1, high: ~00 as T)))
                Test().multiplication(bot,   0, F(D(low:  0000 as M, high:  00 as T)))
                Test().multiplication(bot,   1, F(D(low: ~M.msb - 0, high:  00 as T)))
                Test().multiplication(bot,   2, F(D(low: ~0001 as M, high:  00 as T), error: true))
                Test().multiplication(bot,   3, F(D(low: ~M.msb - 2, high:  01 as T), error: true))
                Test().multiplication(bot,   4, F(D(low: ~0003 as M, high:  01 as T), error: true))
                
                Test().multiplication(msb,  ~4, F(D(low:  M.msb,     high:  02 as T), error: true))
                Test().multiplication(msb,  ~3, F(D(low:  0000 as M, high:  02 as T), error: true))
                Test().multiplication(msb,  ~2, F(D(low:  M.msb,     high:  01 as T), error: true))
                Test().multiplication(msb,  ~1, F(D(low:  0000 as M, high:  01 as T), error: true))
                Test().multiplication(msb,  ~0, F(D(low:  M.msb,     high:  00 as T), error: true))
                Test().multiplication(msb,   0, F(D(low:  0000 as M, high:  00 as T)))
                Test().multiplication(msb,   1, F(D(low:  M.msb,     high: ~00 as T)))
                Test().multiplication(msb,   2, F(D(low:  0000 as M, high: ~00 as T), error: true))
                Test().multiplication(msb,   3, F(D(low:  M.msb,     high: ~01 as T), error: true))
                Test().multiplication(msb,   4, F(D(low:  0000 as M, high: ~01 as T), error: true))
            }   else {
                Test().multiplication(bot,  ~4, F(D(low:  M.msb + 5, high:  bot - 3), error: true))
                Test().multiplication(bot,  ~3, F(D(low:  0004 as M, high:  bot - 2), error: true))
                Test().multiplication(bot,  ~2, F(D(low:  M.msb + 3, high:  bot - 2), error: true))
                Test().multiplication(bot,  ~1, F(D(low:  0002 as M, high:  bot - 1), error: true))
                Test().multiplication(bot,  ~0, F(D(low:  M.msb + 1, high:  bot - 1), error: true))
                Test().multiplication(bot,   0, F(D(low:  0000 as M, high:  00 as T)))
                Test().multiplication(bot,   1, F(D(low: ~M.msb - 0, high:  00 as T)))
                Test().multiplication(bot,   2, F(D(low: ~0001 as M, high:  00 as T)))
                Test().multiplication(bot,   3, F(D(low: ~M.msb - 2, high:  01 as T), error: true))
                Test().multiplication(bot,   4, F(D(low: ~0003 as M, high:  01 as T), error: true))

                Test().multiplication(msb,  ~4, F(D(low:  M.msb,     high:  bot - 2), error: true))
                Test().multiplication(msb,  ~3, F(D(low:  0000 as M, high:  bot - 1), error: true))
                Test().multiplication(msb,  ~2, F(D(low:  M.msb,     high:  bot - 1), error: true))
                Test().multiplication(msb,  ~1, F(D(low:  0000 as M, high:  bot - 0), error: true))
                Test().multiplication(msb,  ~0, F(D(low:  M.msb,     high:  bot - 0), error: true))
                Test().multiplication(msb,   0, F(D(low:  0000 as M, high:  00 as T)))
                Test().multiplication(msb,   1, F(D(low:  M.msb,     high:  00 as T)))
                Test().multiplication(msb,   2, F(D(low:  0000 as M, high:  01 as T), error: true))
                Test().multiplication(msb,   3, F(D(low:  M.msb,     high:  01 as T), error: true))
                Test().multiplication(msb,   4, F(D(low:  0000 as M, high:  02 as T), error: true))
            }
        }
        
        for type in binaryIntegers {
            whereIsBinaryInteger(type)
        }
        
        for type in systemsIntegers {
            whereIsSystemsInteger(type)
        }
    }
    
    func testMultiplicationOfRepeatingBit() {
        func whereIsBinaryInteger<T>(_ type: T.Type) where T: BinaryInteger {
            typealias F = Fallible<T>
            //=----------------------------------=
            let x0 = T(repeating: 0)
            let x1 = T(repeating: 1)
            //=----------------------------------=
            for multiplier in [4, 3, 2, 1, 0, ~0, ~1, ~2, ~3, ~4] as [T] {
                Test().multiplication(x0, multiplier, Fallible(x0))
            }
            
            if  T.isSigned {
                Test().multiplication(x1, ~4 as T, F( 5 as T))
                Test().multiplication(x1, ~3 as T, F( 4 as T))
                Test().multiplication(x1, ~2 as T, F( 3 as T))
                Test().multiplication(x1, ~1 as T, F( 2 as T))
                Test().multiplication(x1, ~0 as T, F( 1 as T))
                Test().multiplication(x1,  0 as T, F( 0 as T))
                Test().multiplication(x1,  1 as T, F(~0 as T))
                Test().multiplication(x1,  2 as T, F(~1 as T))
                Test().multiplication(x1,  3 as T, F(~2 as T))
                Test().multiplication(x1,  4 as T, F(~3 as T))
            }   else {
                Test().multiplication(x1, ~4 as T, F( 5 as T, error: true))
                Test().multiplication(x1, ~3 as T, F( 4 as T, error: true))
                Test().multiplication(x1, ~2 as T, F( 3 as T, error: true))
                Test().multiplication(x1, ~1 as T, F( 2 as T, error: true))
                Test().multiplication(x1, ~0 as T, F( 1 as T, error: true))
                Test().multiplication(x1,  0 as T, F( 0 as T))
                Test().multiplication(x1,  1 as T, F(~0 as T))
                Test().multiplication(x1,  2 as T, F(~1 as T, error: true))
                Test().multiplication(x1,  3 as T, F(~2 as T, error: true))
                Test().multiplication(x1,  4 as T, F(~3 as T, error: true))
            }
        }
        
        func whereIsSystemsInteger<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias D = Doublet <T>
            typealias F = Fallible<D>
            //=----------------------------------=
            let x0 = T(repeating: 0)
            let x1 = T(repeating: 1)
            //=----------------------------------=
            for multiplier in [4, 3, 2, 1, 0, ~0, ~1, ~2, ~3, ~4] as [T] {
                Test().multiplication(x0, multiplier, F(D(low: T.Magnitude(raw: x0), high: x0)))
            }
            
            if  T.isSigned {
                Test().multiplication(x1, ~4 as T, F(D(low:  5 as M, high:  0 as T)))
                Test().multiplication(x1, ~3 as T, F(D(low:  4 as M, high:  0 as T)))
                Test().multiplication(x1, ~2 as T, F(D(low:  3 as M, high:  0 as T)))
                Test().multiplication(x1, ~1 as T, F(D(low:  2 as M, high:  0 as T)))
                Test().multiplication(x1, ~0 as T, F(D(low:  1 as M, high:  0 as T)))
                Test().multiplication(x1,  0 as T, F(D(low:  0 as M, high:  0 as T)))
                Test().multiplication(x1,  1 as T, F(D(low: ~0 as M, high: ~0 as T)))
                Test().multiplication(x1,  2 as T, F(D(low: ~1 as M, high: ~0 as T)))
                Test().multiplication(x1,  3 as T, F(D(low: ~2 as M, high: ~0 as T)))
                Test().multiplication(x1,  4 as T, F(D(low: ~3 as M, high: ~0 as T)))
            }   else {
                Test().multiplication(x1, ~4 as T, F(D(low:  5 as M, high: ~5 as T), error: true))
                Test().multiplication(x1, ~3 as T, F(D(low:  4 as M, high: ~4 as T), error: true))
                Test().multiplication(x1, ~2 as T, F(D(low:  3 as M, high: ~3 as T), error: true))
                Test().multiplication(x1, ~1 as T, F(D(low:  2 as M, high: ~2 as T), error: true))
                Test().multiplication(x1, ~0 as T, F(D(low:  1 as M, high: ~1 as T), error: true))
                Test().multiplication(x1,  0 as T, F(D(low:  0 as M, high:  0 as T)))
                Test().multiplication(x1,  1 as T, F(D(low: ~0 as M, high:  0 as T)))
                Test().multiplication(x1,  2 as T, F(D(low: ~1 as M, high:  1 as T), error: true))
                Test().multiplication(x1,  3 as T, F(D(low: ~2 as M, high:  2 as T), error: true))
                Test().multiplication(x1,  4 as T, F(D(low: ~3 as M, high:  3 as T), error: true))
            }
        }
        
        for type in binaryIntegers {
            whereIsBinaryInteger(type)
        }
        
        for type in systemsIntegers {
            whereIsSystemsInteger(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplication112OfLowEntropies() {
        func whereIsSigned<T>(_ type: T.Type) where T: SignedInteger {
            Test().multiplication(~2 as T, ~2 as T, Fallible(Doublet(low:  9, high:  0)))
            Test().multiplication(~2 as T, ~1 as T, Fallible(Doublet(low:  6, high:  0)))
            Test().multiplication(~2 as T, ~0 as T, Fallible(Doublet(low:  3, high:  0)))
            Test().multiplication(~2 as T,  0 as T, Fallible(Doublet(low:  0, high:  0)))
            Test().multiplication(~2 as T,  1 as T, Fallible(Doublet(low: ~2, high: ~0)))
            Test().multiplication(~2 as T,  2 as T, Fallible(Doublet(low: ~5, high: ~0)))
            
            Test().multiplication(~1 as T, ~2 as T, Fallible(Doublet(low:  6, high:  0)))
            Test().multiplication(~1 as T, ~1 as T, Fallible(Doublet(low:  4, high:  0)))
            Test().multiplication(~1 as T, ~0 as T, Fallible(Doublet(low:  2, high:  0)))
            Test().multiplication(~1 as T,  0 as T, Fallible(Doublet(low:  0, high:  0)))
            Test().multiplication(~1 as T,  1 as T, Fallible(Doublet(low: ~1, high: ~0)))
            Test().multiplication(~1 as T,  2 as T, Fallible(Doublet(low: ~3, high: ~0)))
            
            Test().multiplication(~0 as T, ~2 as T, Fallible(Doublet(low:  3, high:  0)))
            Test().multiplication(~0 as T, ~1 as T, Fallible(Doublet(low:  2, high:  0)))
            Test().multiplication(~0 as T, ~0 as T, Fallible(Doublet(low:  1, high:  0)))
            Test().multiplication(~0 as T,  0 as T, Fallible(Doublet(low:  0, high:  0)))
            Test().multiplication(~0 as T,  1 as T, Fallible(Doublet(low: ~0, high: ~0)))
            Test().multiplication(~0 as T,  2 as T, Fallible(Doublet(low: ~1, high: ~0)))
            
            Test().multiplication( 0 as T, ~2 as T, Fallible(Doublet(low:  0, high:  0)))
            Test().multiplication( 0 as T, ~1 as T, Fallible(Doublet(low:  0, high:  0)))
            Test().multiplication( 0 as T, ~0 as T, Fallible(Doublet(low:  0, high:  0)))
            Test().multiplication( 0 as T,  0 as T, Fallible(Doublet(low:  0, high:  0)))
            Test().multiplication( 0 as T,  1 as T, Fallible(Doublet(low:  0, high:  0)))
            Test().multiplication( 0 as T,  2 as T, Fallible(Doublet(low:  0, high:  0)))
            
            Test().multiplication( 1 as T, ~2 as T, Fallible(Doublet(low: ~2, high: ~0)))
            Test().multiplication( 1 as T, ~1 as T, Fallible(Doublet(low: ~1, high: ~0)))
            Test().multiplication( 1 as T, ~0 as T, Fallible(Doublet(low: ~0, high: ~0)))
            Test().multiplication( 1 as T,  0 as T, Fallible(Doublet(low:  0, high:  0)))
            Test().multiplication( 1 as T,  1 as T, Fallible(Doublet(low:  1, high:  0)))
            Test().multiplication( 1 as T,  2 as T, Fallible(Doublet(low:  2, high:  0)))
            
            Test().multiplication( 2 as T, ~2 as T, Fallible(Doublet(low: ~5, high: ~0)))
            Test().multiplication( 2 as T, ~1 as T, Fallible(Doublet(low: ~3, high: ~0)))
            Test().multiplication( 2 as T, ~0 as T, Fallible(Doublet(low: ~1, high: ~0)))
            Test().multiplication( 2 as T,  0 as T, Fallible(Doublet(low:  0, high:  0)))
            Test().multiplication( 2 as T,  1 as T, Fallible(Doublet(low:  2, high:  0)))
            Test().multiplication( 2 as T,  2 as T, Fallible(Doublet(low:  4, high:  0)))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: UnsignedInteger {
            Test().multiplication(~5 as T, ~5 as T, Fallible(Doublet(low:  36, high: ~11), error: true))
            Test().multiplication(~5 as T, ~4 as T, Fallible(Doublet(low:  30, high: ~10), error: true))
            Test().multiplication(~5 as T, ~3 as T, Fallible(Doublet(low:  24, high:  ~9), error: true))
            Test().multiplication(~5 as T, ~2 as T, Fallible(Doublet(low:  18, high:  ~8), error: true))
            Test().multiplication(~5 as T, ~1 as T, Fallible(Doublet(low:  12, high:  ~7), error: true))
            Test().multiplication(~5 as T, ~0 as T, Fallible(Doublet(low:   6, high:  ~6), error: true))
            Test().multiplication(~5 as T,  0 as T, Fallible(Doublet(low:   0, high:   0)))
            Test().multiplication(~5 as T,  1 as T, Fallible(Doublet(low:  ~5, high:   0)))
            Test().multiplication(~5 as T,  2 as T, Fallible(Doublet(low: ~11, high:   1), error: true))
            Test().multiplication(~5 as T,  3 as T, Fallible(Doublet(low: ~17, high:   2), error: true))
            Test().multiplication(~5 as T,  4 as T, Fallible(Doublet(low: ~23, high:   3), error: true))
            Test().multiplication(~5 as T,  5 as T, Fallible(Doublet(low: ~29, high:   4), error: true))
            
            Test().multiplication( 0 as T, ~5 as T, Fallible(Doublet(low:   0, high:   0)))
            Test().multiplication( 0 as T, ~3 as T, Fallible(Doublet(low:   0, high:   0)))
            Test().multiplication( 0 as T, ~2 as T, Fallible(Doublet(low:   0, high:   0)))
            Test().multiplication( 0 as T, ~1 as T, Fallible(Doublet(low:   0, high:   0)))
            Test().multiplication( 0 as T, ~0 as T, Fallible(Doublet(low:   0, high:   0)))
            Test().multiplication( 0 as T,  0 as T, Fallible(Doublet(low:   0, high:   0)))
            Test().multiplication( 0 as T,  1 as T, Fallible(Doublet(low:   0, high:   0)))
            Test().multiplication( 0 as T,  2 as T, Fallible(Doublet(low:   0, high:   0)))
            Test().multiplication( 0 as T,  4 as T, Fallible(Doublet(low:   0, high:   0)))
            Test().multiplication( 0 as T,  5 as T, Fallible(Doublet(low:   0, high:   0)))
            
            Test().multiplication( 5 as T, ~5 as T, Fallible(Doublet(low: ~29, high:   4), error: true))
            Test().multiplication( 5 as T, ~4 as T, Fallible(Doublet(low: ~24, high:   4), error: true))
            Test().multiplication( 5 as T, ~3 as T, Fallible(Doublet(low: ~19, high:   4), error: true))
            Test().multiplication( 5 as T, ~2 as T, Fallible(Doublet(low: ~14, high:   4), error: true))
            Test().multiplication( 5 as T, ~1 as T, Fallible(Doublet(low:  ~9, high:   4), error: true))
            Test().multiplication( 5 as T, ~0 as T, Fallible(Doublet(low:  ~4, high:   4), error: true))
            Test().multiplication( 5 as T,  0 as T, Fallible(Doublet(low:   0, high:   0)))
            Test().multiplication( 5 as T,  1 as T, Fallible(Doublet(low:   5, high:   0)))
            Test().multiplication( 5 as T,  2 as T, Fallible(Doublet(low:  10, high:   0)))
            Test().multiplication( 5 as T,  3 as T, Fallible(Doublet(low:  15, high:   0)))
            Test().multiplication( 5 as T,  4 as T, Fallible(Doublet(low:  20, high:   0)))
            Test().multiplication( 5 as T,  5 as T, Fallible(Doublet(low:  25, high:   0)))
        }
        
        for type in binaryIntegersWhereIsSigned {
            whereIsSigned(type)
        }

        for type in binaryIntegersWhereIsUnsigned {
            whereIsUnsigned(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplication112As08Is111As16() throws {
        func whereIs<A, B>(x08: A.Type, x16: B.Type) where A: SystemsInteger, B: SystemsInteger {
            precondition(A.size == Count(08))
            precondition(B.size == Count(16))
            precondition(A.isSigned == B.isSigned)
            
            var success = U32.zero
            
            for lhs in A.min ... A.max {
                for rhs in A.min ... A.max {
                    let result = lhs.multiplication((rhs))
                    let expectation = B(lhs).times(B(rhs))
            
                    guard !expectation.error else { break }
                    guard result.low  == A.Magnitude(load:    expectation.value) else { break }
                    guard result.high == A(load: expectation.value.down(A.size)) else { break }
                    
                    success += 1
                }
            }
            
            Test().same(success, 256 * 256)
        }
        
        #if DEBUG
        throw XCTSkip("req. release mode")
        #else
        whereIs(x08: I8.self, x16: I16.self)
        whereIs(x08: I8.self, x16: DoubleInt<I8>.self)
        whereIs(x08: U8.self, x16: U16.self)
        whereIs(x08: U8.self, x16: DoubleInt<U8>.self)
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Random
    //=------------------------------------------------------------------------=
    
    func testMultiplicationByFuzzing() {
        func whereIs<T>(_ type: T.Type, size: IX, rounds: IX, randomness: consuming FuzzerInt) where T: BinaryInteger {
            func random() -> T {
                let index = IX.random(in: 00000 ..< size, using: &randomness)!
                let pattern = T.Signitude.random(through: Shift(Count(index)), using: &randomness)
                return T(raw: pattern) // do not forget about infinite values!
            }
            
            for _  in 0 ..< rounds {
                let a = random()
                let b = random()
                let c = random()
                let d = random()
                let e = (a &+ b) &* (c &+ d)
                let f = (a &* c) &+ (a &* d) &+ (b &* c) &+ (b &* d)
                Test().same(e,f)
            }
        }
        
        for type in binaryIntegers {
            #if DEBUG
            whereIs(type, size: IX(size: type) ?? 0256, rounds: 16, randomness: fuzzer)
            #else
            whereIs(type, size: IX(size: type) ?? 4096, rounds: 16, randomness: fuzzer)
            #endif
        }
    }
    
    func testMultiplicationSquareProductByFuzzing() {
        func whereIs<T>(_ type: T.Type, size: IX, rounds: IX, randomness: consuming FuzzerInt) where T: BinaryInteger {
            func random() -> T {
                let index = IX.random(in: 00000 ..< size, using: &randomness)!
                let pattern = T.Signitude.random(through: Shift(Count(index)), using: &randomness)
                return T(raw: pattern) // do not forget about infinite values!
            }
            
            for _  in 0 ..< rounds {
                let a = random()
                let b = random()
                let c = a.plus(b).squared().value
                let d = a.squared().plus(a.times(b).times(2)).plus(b.squared()).value
                Test().same(c,d)
            }
        }
        
        for type in binaryIntegers {
            #if DEBUG
            whereIs(type, size: IX(size: type) ?? 0256, rounds: 16, randomness: fuzzer)
            #else
            whereIs(type, size: IX(size: type) ?? 4096, rounds: 16, randomness: fuzzer)
            #endif
        }
    }
}
