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
// MARK: * Data Int x Count
//*============================================================================*

extension DataIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSize() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            
            C([          ]).size(is: IX(size: T.self) * 0)
            C([11        ]).size(is: IX(size: T.self) * 1)
            C([11, 22    ]).size(is: IX(size: T.self) * 2)
            C([11, 22, 33]).size(is: IX(size: T.self) * 3)
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testCount() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            
            C([          ]).count(Bit.zero, is: 0 * IX(size: T.self) - 0 as IX)
            C([11        ]).count(Bit.zero, is: 1 * IX(size: T.self) - 3 as IX)
            C([11, 22    ]).count(Bit.zero, is: 2 * IX(size: T.self) - 6 as IX)
            C([11, 22, 33]).count(Bit.zero, is: 3 * IX(size: T.self) - 8 as IX)
            
            C([          ]).count(Bit.one,  is: 0 * IX(size: T.self) + 0 as IX)
            C([11        ]).count(Bit.one,  is: 0 * IX(size: T.self) + 3 as IX)
            C([11, 22    ]).count(Bit.one,  is: 0 * IX(size: T.self) + 6 as IX)
            C([11, 22, 33]).count(Bit.one,  is: 0 * IX(size: T.self) + 8 as IX)
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testCountAscending() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            
            C([          ]).ascending(Bit.zero, is: 0 as IX)
            C([11        ]).ascending(Bit.zero, is: 0 as IX)
            C([11, 22    ]).ascending(Bit.zero, is: 0 as IX)
            C([11, 22, 33]).ascending(Bit.zero, is: 0 as IX)
            
            C([          ]).ascending(Bit.one,  is: 0 as IX)
            C([11        ]).ascending(Bit.one,  is: 2 as IX)
            C([11, 22    ]).ascending(Bit.one,  is: 2 as IX)
            C([11, 22, 33]).ascending(Bit.one,  is: 2 as IX)
            
            for bit in [Bit.zero, Bit.one] {
                let a = T(repeating: bit)
                let b = T(repeating: bit) ^ T(11).toggled()
                
                C([b      ]).ascending( bit, is: 0 * IX(size: T.self) + 2 as IX)
                C([a, b   ]).ascending( bit, is: 1 * IX(size: T.self) + 2 as IX)
                C([a, a, b]).ascending( bit, is: 2 * IX(size: T.self) + 2 as IX)
                C([a, a, a]).ascending( bit, is: 3 * IX(size: T.self) + 0 as IX)
                
                C([b      ]).ascending(~bit, is: 0 * IX(size: T.self) + 0 as IX)
                C([a, b   ]).ascending(~bit, is: 0 * IX(size: T.self) + 0 as IX)
                C([a, a, b]).ascending(~bit, is: 0 * IX(size: T.self) + 0 as IX)
                C([a, a, a]).ascending(~bit, is: 0 * IX(size: T.self) + 0 as IX)
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testCountDescending() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            
            C([          ]).descending(Bit.zero, is: 0 * IX(size: T.self) - 0 as IX)
            C([11        ]).descending(Bit.zero, is: 1 * IX(size: T.self) - 4 as IX)
            C([11, 22    ]).descending(Bit.zero, is: 1 * IX(size: T.self) - 5 as IX)
            C([11, 22, 33]).descending(Bit.zero, is: 1 * IX(size: T.self) - 6 as IX)
            
            C([          ]).descending(Bit.one,  is: 0 * IX(size: T.self) - 0 as IX)
            C([11        ]).descending(Bit.one,  is: 0 * IX(size: T.self) - 0 as IX)
            C([11, 22    ]).descending(Bit.one,  is: 0 * IX(size: T.self) - 0 as IX)
            C([11, 22, 33]).descending(Bit.one,  is: 0 * IX(size: T.self) - 0 as IX)
            
            for bit in [Bit.zero, Bit.one] {
                let a = T(repeating: bit)
                let b = T(repeating: bit) ^ T(13).toggled() << IX(size: T.self).minus(4).unwrap()
                
                C([b      ]).descending( bit, is: 0 * IX(size: T.self) + 2 as IX)
                C([b, a   ]).descending( bit, is: 1 * IX(size: T.self) + 2 as IX)
                C([b, a, a]).descending( bit, is: 2 * IX(size: T.self) + 2 as IX)
                C([a, a, a]).descending( bit, is: 3 * IX(size: T.self) + 0 as IX)
                
                C([b      ]).descending(~bit, is: 0 * IX(size: T.self) - 0 as IX)
                C([b, a   ]).descending(~bit, is: 0 * IX(size: T.self) - 0 as IX)
                C([b, a, a]).descending(~bit, is: 0 * IX(size: T.self) - 0 as IX)
                C([a, a, a]).descending(~bit, is: 0 * IX(size: T.self) + 0 as IX)
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension DataIntTests.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func size(is expectation: IX) {
        self.expect(Count(expectation), read:{ $0.size() }, write:{ $0.size() })
    }
    
    func count(_ bit: Bit, is expectation: IX) {
        let size = IX(self.body.count) * IX(size: Element.self)
        //=--------------------------------------=
        self.size(is: size)
        //=--------------------------------------=
        self.expect(Count(       expectation), read:{ $0.count( bit) }, write:{ $0.count( bit) })
        self.expect(Count(size - expectation), read:{ $0.count(~bit) }, write:{ $0.count(~bit) })
    }
    
    func ascending(_ bit: Bit, is expectation: IX) {
        let size = IX(self.body.count) * IX(size: Element.self)
        //=--------------------------------------=
        self.size(is: size)
        //=--------------------------------------=
        self.expect(Count(       expectation), read:{ $0   .ascending(bit) }, write:{ $0   .ascending(bit) })
        self.expect(Count(size - expectation), read:{ $0.nonascending(bit) }, write:{ $0.nonascending(bit) })
    }
    
    func descending(_ bit: Bit, is expectation: IX) {
        let size = IX(self.body.count) * IX(size: Element.self)
        //=--------------------------------------=
        self.size(is: size)
        //=--------------------------------------=
        self.expect(Count(       expectation), read:{ $0   .descending(bit) }, write:{ $0   .descending(bit) })
        self.expect(Count(size - expectation), read:{ $0.nondescending(bit) }, write:{ $0.nondescending(bit) })
        
        if  bit == Bit.zero {
            self .expect(Count(1 + size - expectation), read:{ $0.entropy() }, write:{ $0.entropy() })
        }
        
        always: do {
            let other = DataIntTests.Extension((self.body, bit), test: self.test)
            other.expect(Count(1 + size - expectation), read:{ $0.entropy() }, write:{ $0.entropy() })
        }
    }
}
