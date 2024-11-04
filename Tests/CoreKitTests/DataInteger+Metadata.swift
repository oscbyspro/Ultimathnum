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

@Suite struct DataIntegerTestsOnMetadata {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt.capacity", .tags(.generic), arguments: typesAsCoreIntegerAsUnsigned)
    func capacity(_ type: any CoreIntegerAsUnsigned.Type) throws {
        try  whereIs(type)

        func whereIs<T>(_ element: T.Type) throws where T: CoreIntegerAsUnsigned {
            try check(       DataInt<T>     .capacity)
            try check(       DataInt<T>.Body.capacity)
            try check(MutableDataInt<T>     .capacity)
            try check(MutableDataInt<T>.Body.capacity)
            
            func check(_ capacity: IX) throws {
                let part = IX(size: T.self)
                let size = try #require(capacity.times(part).optional())
                #expect(size > (IX.max - part) && size < IX.max)
            }
        }
    }
}
