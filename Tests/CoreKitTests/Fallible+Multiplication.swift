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
// MARK: * Fallible x Multiplication
//*============================================================================*

extension FallibleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBinaryIntegerSquareProduct() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var success = U32.min
            let values8 = (I8.min ... I8.max).lazy.map(T.init(load:))
            
            for instance in values8 {
                let expectation: Fallible<T> =  instance.squared()
                success &+= U32(Bit(instance.veto(false).squared() == expectation))
                success &+= U32(Bit(instance.veto(true ).squared() == expectation.veto()))
            }
            
            Test().same(success, 2 &* 256)
        }
        
        whereIs(I8.self)
        whereIs(U8.self)
    }
    
    func testBinaryIntegerMultiplication11() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var success = U32.min
            let values8 = (I8.min ... I8.max).lazy.map(T.init(load:))
            
            for lhs in values8 {
                for rhs in values8 {
                    let expectation: Fallible<T> =  lhs.times(rhs)
                    success &+= U32(Bit(lhs.veto(false).times(rhs)             == expectation))
                    success &+= U32(Bit(lhs.veto(false).times(rhs.veto(false)) == expectation))
                    success &+= U32(Bit(lhs.veto(false).times(rhs.veto(true )) == expectation.veto()))
                    success &+= U32(Bit(lhs.veto(true ).times(rhs)             == expectation.veto()))
                    success &+= U32(Bit(lhs.veto(true ).times(rhs.veto(false)) == expectation.veto()))
                    success &+= U32(Bit(lhs.veto(true ).times(rhs.veto(true )) == expectation.veto()))
                }
            }
            
            Test().same(success, 6 &* 256 &* 256)
        }
        
        whereIs(I8.self)
        whereIs(U8.self)
    }
}
