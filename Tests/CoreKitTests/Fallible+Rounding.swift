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
// MARK: * Fallible x Rounding
//*============================================================================*

extension FallibleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBinaryIntegerDivisionCeil() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var success = U32.min
            let values8 = (I8.min ... I8.max).lazy.map(T.init(load:))
            
            for quotient in values8 {
                for remainder in values8 {
                    let division = Division(quotient: quotient, remainder: remainder)
                    
                    let expectation: Fallible<T> =  division.ceil()
                    success &+= U32(Bit(division.veto(false).ceil() == expectation))
                    success &+= U32(Bit(division.veto(true ).ceil() == expectation.veto()))
                }
            }
            
            Test().same(success, 2 &* 256 &* 256)
        }
        
        whereIs(I8.self)
        whereIs(U8.self)
    }
    
    func testBinaryIntegerDivisionFloor() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var success = U32.min
            let values8 = (I8.min ... I8.max).lazy.map(T.init(load:))
            
            for quotient in values8 {
                for remainder in values8 {
                    let division = Division(quotient: quotient, remainder: remainder)
                    
                    let expectation: Fallible<T> =  division.floor()
                    success &+= U32(Bit(division.veto(false).floor() == expectation))
                    success &+= U32(Bit(division.veto(true ).floor() == expectation.veto()))
                }
            }
            
            Test().same(success, 2 &* 256 &* 256)
        }
        
        whereIs(I8.self)
        whereIs(U8.self)
    }
}
