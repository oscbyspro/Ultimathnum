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
            
            C([          ]).count(0 as Bit, is: 0 * IX(size: T.self) - 0 as IX)
            C([11        ]).count(0 as Bit, is: 1 * IX(size: T.self) - 3 as IX)
            C([11, 22    ]).count(0 as Bit, is: 2 * IX(size: T.self) - 6 as IX)
            C([11, 22, 33]).count(0 as Bit, is: 3 * IX(size: T.self) - 8 as IX)
            
            C([          ]).count(1 as Bit, is: 0 * IX(size: T.self) + 0 as IX)
            C([11        ]).count(1 as Bit, is: 0 * IX(size: T.self) + 3 as IX)
            C([11, 22    ]).count(1 as Bit, is: 0 * IX(size: T.self) + 6 as IX)
            C([11, 22, 33]).count(1 as Bit, is: 0 * IX(size: T.self) + 8 as IX)
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testCountAscending() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            
            C([          ]).count(.ascending(0), is: 0 as IX)
            C([11        ]).count(.ascending(0), is: 0 as IX)
            C([11, 22    ]).count(.ascending(0), is: 0 as IX)
            C([11, 22, 33]).count(.ascending(0), is: 0 as IX)
            
            C([          ]).count(.ascending(1), is: 0 as IX)
            C([11        ]).count(.ascending(1), is: 2 as IX)
            C([11, 22    ]).count(.ascending(1), is: 2 as IX)
            C([11, 22, 33]).count(.ascending(1), is: 2 as IX)
            
            for bit: Bit in [0, 1] {
                let a = T(repeating: bit)
                let b = T(repeating: bit) ^ T(11).toggled()
                
                C([b      ]).count(.ascending( bit), is: 0 * IX(size: T.self) + 2 as IX)
                C([a, b   ]).count(.ascending( bit), is: 1 * IX(size: T.self) + 2 as IX)
                C([a, a, b]).count(.ascending( bit), is: 2 * IX(size: T.self) + 2 as IX)
                C([a, a, a]).count(.ascending( bit), is: 3 * IX(size: T.self) + 0 as IX)
                
                C([b      ]).count(.ascending(~bit), is: 0 * IX(size: T.self) + 0 as IX)
                C([a, b   ]).count(.ascending(~bit), is: 0 * IX(size: T.self) + 0 as IX)
                C([a, a, b]).count(.ascending(~bit), is: 0 * IX(size: T.self) + 0 as IX)
                C([a, a, a]).count(.ascending(~bit), is: 0 * IX(size: T.self) + 0 as IX)
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testCountDescending() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            
            C([          ]).count(.descending(0), is: 0 * IX(size: T.self) - 0 as IX)
            C([11        ]).count(.descending(0), is: 1 * IX(size: T.self) - 4 as IX)
            C([11, 22    ]).count(.descending(0), is: 1 * IX(size: T.self) - 5 as IX)
            C([11, 22, 33]).count(.descending(0), is: 1 * IX(size: T.self) - 6 as IX)
            
            C([          ]).count(.descending(1), is: 0 * IX(size: T.self) - 0 as IX)
            C([11        ]).count(.descending(1), is: 0 * IX(size: T.self) - 0 as IX)
            C([11, 22    ]).count(.descending(1), is: 0 * IX(size: T.self) - 0 as IX)
            C([11, 22, 33]).count(.descending(1), is: 0 * IX(size: T.self) - 0 as IX)
            
            for bit: Bit in [0, 1] {
                let a = T(repeating: bit)
                let b = T(repeating: bit) ^ T(13).toggled() << T(raw: T.size - 4)
                
                C([b      ]).count(.descending( bit), is: 0 * IX(size: T.self) + 2 as IX)
                C([b, a   ]).count(.descending( bit), is: 1 * IX(size: T.self) + 2 as IX)
                C([b, a, a]).count(.descending( bit), is: 2 * IX(size: T.self) + 2 as IX)
                C([a, a, a]).count(.descending( bit), is: 3 * IX(size: T.self) + 0 as IX)
                
                C([b      ]).count(.descending(~bit), is: 0 * IX(size: T.self) - 0 as IX)
                C([b, a   ]).count(.descending(~bit), is: 0 * IX(size: T.self) - 0 as IX)
                C([b, a, a]).count(.descending(~bit), is: 0 * IX(size: T.self) - 0 as IX)
                C([a, a, a]).count(.descending(~bit), is: 0 * IX(size: T.self) + 0 as IX)
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
    
    @inlinable public func size(is expectation: IX) {
        self.expect(expectation, read:{ $0.size() }, write:{ $0.size() })
    }    
    
    @inlinable public func count(_ selection: Bit, is expectation: IX) {
        let inverse = selection.toggled()
        let size = IX(self.body.count) * IX(size: Element.self)
        
        self.expect(       expectation, read:{ $0.count(selection) }, write:{ $0.count(selection) })
        self.expect(size - expectation, read:{ $0.count((inverse)) }, write:{ $0.count((inverse)) })
    }
    
    @inlinable public func count(_ selection: Bit.Ascending, is expectation: IX) {
        let inverse = Bit.Nonascending(selection.bit)
        let size = IX(self.body.count) * IX(size: Element.self)
        
        self.expect(       expectation, read:{ $0.count(selection) }, write:{ $0.count(selection) })
        self.expect(size - expectation, read:{ $0.count((inverse)) }, write:{ $0.count((inverse)) })
    }
    
    @inlinable public func count(_ selection: Bit.Descending, is expectation: IX) {
        let inverse = Bit.Nondescending(selection.bit)
        let size = IX(self.body.count) * IX(size: Element.self)
        
        self.expect(       expectation, read:{ $0.count(selection) }, write:{ $0.count(selection) })
        self.expect(size - expectation, read:{ $0.count((inverse)) }, write:{ $0.count((inverse)) })
        
        if  selection.bit == 0 {
            self.expect(           expectation, read:{ $0.count(   .appendix) }, write:{ $0.count(   .appendix) })
            self.expect(    size - expectation, read:{ $0.count(.nonappendix) }, write:{ $0.count(.nonappendix) })
            self.expect(1 + size - expectation, read:{ $0.count(    .entropy) }, write:{ $0.count(    .entropy) })
        }
        
        always: do {
            let other = DataIntTests.Extension((self.body, selection.bit), test: self.test)
            other.expect(    size - expectation, read:{ $0.count(.nonappendix) }, write:{ $0.count(.nonappendix) })
            other.expect(1 + size - expectation, read:{ $0.count(    .entropy) }, write:{ $0.count(    .entropy) })
        }
    }
}
