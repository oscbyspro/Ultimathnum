//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Fallible x Addition
//*============================================================================*

extension FallibleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBinaryIntegerNegation() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var success = U32.min
            let values8 = (I8.min ... I8.max).lazy.map(T.init(load:))
            
            for instance in values8 {
                let expectation: Fallible<T> =  instance.negated()
                success &+= U32(Bit(instance.veto(false).negated() == expectation))
                success &+= U32(Bit(instance.veto(true ).negated() == expectation.veto()))
            }
            
            Test().same(success, 2 &* 256)
        }
        
        whereIs(I8.self)
        whereIs(U8.self)
    }
    
    func testBinaryIntegerAddition11() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var success = U32.min
            let values8 = (I8.min ... I8.max).lazy.map(T.init(load:))
            
            for lhs in values8 {
                for rhs in values8 {
                    let expectation: Fallible<T> =  lhs.plus(rhs)
                    success &+= U32(Bit(lhs.veto(false).plus(rhs)             == expectation))
                    success &+= U32(Bit(lhs.veto(false).plus(rhs.veto(false)) == expectation))
                    success &+= U32(Bit(lhs.veto(false).plus(rhs.veto(true )) == expectation.veto()))
                    success &+= U32(Bit(lhs.veto(true ).plus(rhs)             == expectation.veto()))
                    success &+= U32(Bit(lhs.veto(true ).plus(rhs.veto(false)) == expectation.veto()))
                    success &+= U32(Bit(lhs.veto(true ).plus(rhs.veto(true )) == expectation.veto()))
                }
            }
            
            Test().same(success, 6 &* 256 &* 256)
        }
        
        whereIs(I8.self)
        whereIs(U8.self)
    }
    
    func testBinaryIntegerSubtraction11() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var success = U32.min
            let values8 = (I8.min ... I8.max).lazy.map(T.init(load:))
            
            for lhs in values8 {
                for rhs in values8 {
                    let expectation: Fallible<T> =  lhs.minus(rhs)
                    success &+= U32(Bit(lhs.veto(false).minus(rhs)             == expectation))
                    success &+= U32(Bit(lhs.veto(false).minus(rhs.veto(false)) == expectation))
                    success &+= U32(Bit(lhs.veto(false).minus(rhs.veto(true )) == expectation.veto()))
                    success &+= U32(Bit(lhs.veto(true ).minus(rhs)             == expectation.veto()))
                    success &+= U32(Bit(lhs.veto(true ).minus(rhs.veto(false)) == expectation.veto()))
                    success &+= U32(Bit(lhs.veto(true ).minus(rhs.veto(true )) == expectation.veto()))
                }
            }
            
            Test().same(success, 6 &* 256 &* 256)
        }
        
        whereIs(I8.self)
        whereIs(U8.self)
    }
    
    func testBinaryIntegerAddition1B() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var success = U32.min
            let values8 = (I8.min ... I8.max).lazy.map(T.init(load:))
            
            for lhs in values8 {
                always: do {
                    let expectation: Fallible<T> =  lhs.incremented()
                    success &+= U32(Bit(lhs.veto(false).incremented() == expectation))
                    success &+= U32(Bit(lhs.veto(true ).incremented() == expectation.veto()))
                }
            }
            
            for lhs in values8 {
                for rhs in [false, true] {
                    let expectation: Fallible<T> =  lhs.plus(rhs)
                    success &+= U32(Bit(lhs.veto(false).plus(rhs) == expectation))
                    success &+= U32(Bit(lhs.veto(true ).plus(rhs) == expectation.veto()))
                }
            }
            
            Test().same(success, 6 &* 256)
        }
        
        whereIs(I8.self)
        whereIs(U8.self)
    }
    
    func testBinaryIntegerSubtraction1B() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var success = U32.min
            let values8 = (I8.min ... I8.max).lazy.map(T.init(load:))
            
            
            for lhs in values8 {
                always: do {
                    let expectation: Fallible<T> =  lhs.decremented()
                    success &+= U32(Bit(lhs.veto(false).decremented() == expectation))
                    success &+= U32(Bit(lhs.veto(true ).decremented() == expectation.veto()))
                }
            }
            
            for lhs in values8 {
                for rhs in [false, true] {
                    let expectation: Fallible<T> =  lhs.minus(rhs)
                    success &+= U32(Bit(lhs.veto(false).minus(rhs) == expectation))
                    success &+= U32(Bit(lhs.veto(true ).minus(rhs) == expectation.veto()))
                }
            }
            
            Test().same(success, 6 &* 256)
        }
        
        whereIs(I8.self)
        whereIs(U8.self)
    }
}
