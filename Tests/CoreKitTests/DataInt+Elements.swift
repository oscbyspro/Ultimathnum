//=----------------------------------------------------------------------------=
// This source file is part of the Iltimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Data Int x Elements
//*============================================================================*

extension DataIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testElement08() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias Case = Extension<T>
            typealias Item = Extension<T>.Item
            
            for bit: Bit in [0, 1] {
                for index: UX in [~2, ~1, ~0, 1, 2, 3] {
                    Case([], repeating: bit).element(at: index, is: T(repeating: bit))
                }
            }
            
            Case([1, 2, 3], repeating: nil).element(at: 000000, is:  0x01)
            Case([1, 2, 3], repeating: nil).element(at: 000001, is:  0x02)
            Case([1, 2, 3], repeating: nil).element(at: 000002, is:  0x03)
            Case([1, 2, 3], repeating:   0).element(at: 123456, is:  0x00)
            Case([1, 2, 3], repeating:   1).element(at: 123456, is: ~0x00)
            Case([1, 2, 3], repeating:   0).element(at: UX.max, is:  0x00)
            Case([1, 2, 3], repeating:   1).element(at: UX.max, is: ~0x00)
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension DataIntTests.Extension {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func element(at index: UX, is expectation: Element) {
        self.expect(expectation, read: {
            $0[index]
        },  write: {
            $0[index]
        })
        
        self.expect(expectation, read: {
            $0[index...][UX.zero]
        },  write: {
            $0[index...][UX.zero]
        })
        //=--------------------------------------=
        guard let index = IX.exactly(index).optional(), index < IX(self.item.body.count) else { return }
        //=--------------------------------------=
        DataIntTests.Body(self.item.body, test: self.test).expect(expectation, read: {
            $0[unchecked: index]
        },  write: {
            $0[unchecked: index]
        })
        
        DataIntTests.Body(self.item.body, test: self.test).expect(expectation, read: {
            $0[unchecked: index...][unchecked: ()]
        },  write: {
            $0[unchecked: index...][unchecked: ()]
        })
    }
}
