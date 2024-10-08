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
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Values
//*============================================================================*

final class BinaryIntegerTestsOnValues: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMinMax() {
        func whereIs<T>(_ type: T.Type) where T: EdgyInteger {
            //=----------------------------------=
            let min = T.isSigned ? 1 << T(UX(size: T.self)! - 1) : T.zero
            let max = min.toggled()
            //=----------------------------------=
            Test().comparison(min, max, Signum.negative)
            //=----------------------------------=
            Test().same(T.min, min, "min")
            Test().same(T.max, max, "max")
        }
        
        for case let type as any EdgyInteger.Type in binaryIntegers {
            whereIs((type))
        }
    }
    
    func testLsbMsb() {
        func whereIsBinaryInteger<T>(_ type: T.Type) where T: BinaryInteger {
            //=----------------------------------=
            let relative = IX(raw: T.size)
            //=----------------------------------=
            Test() .ascending(T.lsb, Bit.zero, Count(0))
            Test() .ascending(T.lsb, Bit.one,  Count(1))
            Test().descending(T.lsb, Bit.zero, Count(raw: relative - 1))
            Test().descending(T.lsb, Bit.one,  Count(0))
        }
        
        func whereIsSystemsInteger<T>(_ type: T.Type) where T: SystemsInteger {
            //=----------------------------------=
            let relative = IX(raw: T.size)
            //=----------------------------------=
            Test().comparison(T.lsb, T.msb, Signum(Sign(!T.isSigned)))
            //=----------------------------------=
            Test() .ascending(T.msb, Bit.zero, Count(raw: relative - 1))
            Test() .ascending(T.msb, Bit.one,  Count(0))
            Test().descending(T.msb, Bit.zero, Count(0))
            Test().descending(T.msb, Bit.one,  Count(1))
        }
        
        for type in binaryIntegers {
            whereIsBinaryInteger(type)
        }
        
        for type in systemsIntegers {
            whereIsSystemsInteger(type)
        }
    }
}
