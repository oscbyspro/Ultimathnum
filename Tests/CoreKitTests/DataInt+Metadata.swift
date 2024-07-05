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
// MARK: * Data Int x Metadata
//*============================================================================*

extension DataIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCapacity() {
        func whereTheElementIs<E>(_ element: E.Type) where E: SystemsInteger & UnsignedInteger {
            let chunk = IX(size: E.self)
            
            Test().yay(       DataInt<E>     .capacity.times(chunk).plus(chunk).error)
            Test().yay(       DataInt<E>.Body.capacity.times(chunk).plus(chunk).error)
            Test().yay(MutableDataInt<E>     .capacity.times(chunk).plus(chunk).error)
            Test().yay(MutableDataInt<E>.Body.capacity.times(chunk).plus(chunk).error)
            
            Test().comparison(       DataInt<E>     .capacity.times(chunk).unwrap(), IX.max, -1 as Signum)
            Test().comparison(       DataInt<E>.Body.capacity.times(chunk).unwrap(), IX.max, -1 as Signum)
            Test().comparison(MutableDataInt<E>     .capacity.times(chunk).unwrap(), IX.max, -1 as Signum)
            Test().comparison(MutableDataInt<E>.Body.capacity.times(chunk).unwrap(), IX.max, -1 as Signum)
        }
        
        for element in coreSystemsIntegersWhereIsUnsigned {
            whereTheElementIs(element)
        }
    }
}
