//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit2

//*============================================================================*
// MARK: * Data Integer x Metadata
//*============================================================================*

extension DataIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt.capacity", arguments: coreIntegersWhereIsUnsigned)
    func capacity(_ type: any SystemsIntegerWhereIsUnsigned.Type) {
        whereIs(type)
        
        func whereIs<T>(_ element: T.Type) where T: SystemsIntegerWhereIsUnsigned {
            let chunk = IX(size: T.self)
            
            #expect(       DataInt<T>     .capacity.times(chunk).plus(chunk).error)
            #expect(       DataInt<T>.Body.capacity.times(chunk).plus(chunk).error)
            #expect(MutableDataInt<T>     .capacity.times(chunk).plus(chunk).error)
            #expect(MutableDataInt<T>.Body.capacity.times(chunk).plus(chunk).error)
                        
            Ɣexpect(       DataInt<T>     .capacity.times(chunk).unwrap(), equals: IX.max, is: Signum.negative)
            Ɣexpect(       DataInt<T>.Body.capacity.times(chunk).unwrap(), equals: IX.max, is: Signum.negative)
            Ɣexpect(MutableDataInt<T>     .capacity.times(chunk).unwrap(), equals: IX.max, is: Signum.negative)
            Ɣexpect(MutableDataInt<T>.Body.capacity.times(chunk).unwrap(), equals: IX.max, is: Signum.negative)
        }
    }
}
