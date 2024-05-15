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
// MARK: * Data Int x Upsize
//*============================================================================*

extension DataIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUpsizeElement08() {
        typealias Case = Extension<U8>
        typealias Item = Extension<U8>.Item
        
        Case([1, 2, 3], repeating: nil).load(as: U8 .self, from: 000000, is: 0x01)
        Case([1, 2, 3], repeating: nil).load(as: U8 .self, from: 000001, is: 0x02)
        Case([1, 2, 3], repeating: nil).load(as: U8 .self, from: 000002, is: 0x03)
        Case([1, 2, 3], repeating:   0).load(as: U8 .self, from: 123456, is: 0x00)
        Case([1, 2, 3], repeating:   1).load(as: U8 .self, from: 123456, is: 0xff)
        Case([1, 2, 3], repeating:   0).load(as: U8 .self, from: UX.max, is: 0x00)
        Case([1, 2, 3], repeating:   1).load(as: U8 .self, from: UX.max, is: 0xff)
    }
    
    func testUpsizeElement16() {
        typealias Case = Extension<U8>
        typealias Item = Extension<U8>.Item

        Case([1, 2, 3], repeating: nil).load(as: U16.self, from: 000000, is: 0x0201)
        Case([1, 2, 3], repeating: nil).load(as: U16.self, from: 000001, is: 0x0302)
        Case([1, 2, 3], repeating:   0).load(as: U16.self, from: 000002, is: 0x0003)
        Case([1, 2, 3], repeating:   1).load(as: U16.self, from: 000002, is: 0xff03)
        Case([1, 2, 3], repeating:   0).load(as: U16.self, from: 000003, is: 0x0000)
        Case([1, 2, 3], repeating:   1).load(as: U16.self, from: 000003, is: 0xffff)
        
        Case([1, 2, 3], repeating:   0).load(as: U16.self, from: 123456, is: 0x0000)
        Case([1, 2, 3], repeating:   1).load(as: U16.self, from: 123456, is: 0xffff)
        Case([1, 2, 3], repeating:   0).load(as: U16.self, from: UX.max, is: 0x0000)
        Case([1, 2, 3], repeating:   1).load(as: U16.self, from: UX.max, is: 0xffff)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUpsizeBody08() {
        typealias Case = Extension<U8>
        typealias Item = Extension<U8>.Item
        
        Case([       ], repeating: nil).body(as: U8 .self, is:[       ] as [U8])
        Case([1      ], repeating: nil).body(as: U8 .self, is:[1      ] as [U8])
        Case([1, 2   ], repeating: nil).body(as: U8 .self, is:[1, 2   ] as [U8])
        Case([1, 2, 3], repeating: nil).body(as: U8 .self, is:[1, 2, 3] as [U8])
    }
    
    func testUpsizeBody16() {
        typealias Case = Extension<U8>
        typealias Item = Extension<U8>.Item
        
        Case([       ], repeating: nil).body(as: U16.self, is:[              ] as [U16])
        Case([1      ], repeating:   0).body(as: U16.self, is:[0x0001        ] as [U16])
        Case([1      ], repeating:   1).body(as: U16.self, is:[0xff01        ] as [U16])
        Case([1, 2   ], repeating: nil).body(as: U16.self, is:[0x0201        ] as [U16])
        Case([1, 2, 3], repeating:   0).body(as: U16.self, is:[0x0201, 0x0003] as [U16])
        Case([1, 2, 3], repeating:   1).body(as: U16.self, is:[0x0201, 0xff03] as [U16])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUpsizeNormalization08() {
        typealias Case = Extension<U8>
        typealias Item = Extension<U8>.Item
        
        for bit: Bit in [0, 1] {
            let a = U8(repeating: bit), b = U8(repeating: bit.toggled())
            
            Case([a, a, a], repeating: bit).normalized(as: U8 .self, is:[       ] as [U8])
            Case([1, a, a], repeating: bit).normalized(as: U8 .self, is:[1      ] as [U8])
            Case([1, 2, a], repeating: bit).normalized(as: U8 .self, is:[1, 2   ] as [U8])
            Case([1, 2, 3], repeating: bit).normalized(as: U8 .self, is:[1, 2, 3] as [U8])
            
            Case([b, b, b], repeating: bit).normalized(as: U8 .self, is:[b, b, b] as [U8])
            Case([1, b, b], repeating: bit).normalized(as: U8 .self, is:[1, b, b] as [U8])
            Case([1, 2, b], repeating: bit).normalized(as: U8 .self, is:[1, 2, b] as [U8])
            Case([1, 2, 3], repeating: bit).normalized(as: U8 .self, is:[1, 2, 3] as [U8])
        }
    }
    
    func testUpsizeNormalization16() {
        typealias Case = Extension<U8>
        typealias Item = Extension<U8>.Item
        
        for bit: Bit in [0, 1] {
            let a = U8 (repeating:  bit), b = U8 (repeating: bit.toggled())
            let x = U16(repeating:  bit), y = U16(repeating: bit.toggled())
            
            Case([a, a, a], repeating: bit).normalized(as: U16.self, is:[                                    ] as [U16])
            Case([1, a, a], repeating: bit).normalized(as: U16.self, is:[(x << 8)|(0x0001)                   ] as [U16])
            Case([1, 2, a], repeating: bit).normalized(as: U16.self, is:[(0x0201)|(0x0000)                   ] as [U16])
            Case([1, 2, 3], repeating: bit).normalized(as: U16.self, is:[(0x0201)|(0x0000), (x << 8)|(0x0003)] as [U16])
            
            Case([b, b, b], repeating: bit).normalized(as: U16.self, is:[(y << 0)|(0x0000), (x << 8)|(y >> 8)] as [U16])
            Case([1, b, b], repeating: bit).normalized(as: U16.self, is:[(y << 8)|(0x0001), (x << 8)|(y >> 8)] as [U16])
            Case([1, 2, b], repeating: bit).normalized(as: U16.self, is:[(0x0201)|(0x0000), (x << 8)|(y >> 8)] as [U16])
            Case([1, 2, 3], repeating: bit).normalized(as: U16.self, is:[(0x0201)|(0x0000), (x << 8)|(0x0003)] as [U16])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUpsizePrefix08() {
        typealias Case = Extension<U8>
        typealias Item = Extension<U8>.Item
        
        Case([1, 2, 3], repeating: nil).prefix(0, as: U8 .self, is:[                      ] as [U8])
        Case([1, 2, 3], repeating: nil).prefix(1, as: U8 .self, is:[0x01                  ] as [U8])
        Case([1, 2, 3], repeating: nil).prefix(2, as: U8 .self, is:[0x01, 0x02            ] as [U8])
        Case([1, 2, 3], repeating: nil).prefix(3, as: U8 .self, is:[0x01, 0x02, 0x03      ] as [U8])
        Case([1, 2, 3], repeating:   0).prefix(4, as: U8 .self, is:[0x01, 0x02, 0x03, 0x00] as [U8])
        Case([1, 2, 3], repeating:   1).prefix(4, as: U8 .self, is:[0x01, 0x02, 0x03, 0xff] as [U8])
    }
    
    func testUpsizePrefix16() {
        typealias Case = Extension<U8>
        typealias Item = Extension<U8>.Item
        
        Case([1, 2, 3], repeating: nil).prefix(0, as: U16.self, is:[                              ] as [U16])
        Case([1, 2, 3], repeating: nil).prefix(1, as: U16.self, is:[0x0201                        ] as [U16])
        Case([1, 2, 3], repeating:   0).prefix(2, as: U16.self, is:[0x0201, 0x0003                ] as [U16])
        Case([1, 2, 3], repeating:   1).prefix(2, as: U16.self, is:[0x0201, 0xff03                ] as [U16])
        Case([1, 2, 3], repeating:   0).prefix(3, as: U16.self, is:[0x0201, 0x0003, 0x0000        ] as [U16])
        Case([1, 2, 3], repeating:   1).prefix(3, as: U16.self, is:[0x0201, 0xff03, 0xffff        ] as [U16])
        Case([1, 2, 3], repeating:   0).prefix(4, as: U16.self, is:[0x0201, 0x0003, 0x0000, 0x0000] as [U16])
        Case([1, 2, 3], repeating:   1).prefix(4, as: U16.self, is:[0x0201, 0xff03, 0xffff, 0xffff] as [U16])
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension DataIntTests.Extension where Element == U8 {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func load<T>(as type: T.Type, from index: UX, is expectation: T) where T: SystemsInteger & UnsignedInteger {
        self.expect(expectation, read: {
            $0[index...].load(as: T.self)
        },  write: {
            $0[index...].load(as: T.self)
        })
    }
    
    func body<T>(as type: T.Type, is expectation: [T]) where T: SystemsInteger & UnsignedInteger {
        self.expect(expectation, read: {
            let count = $0.body.count(as: T.self)
            var elements = [T]()
            
            while !$0.body.isEmpty {
                elements.append($0.load(as: T.self))
                $0 = $0.drop(as: T.self)
            }
            
            test.same(count, IX(elements.count), "count [0]")
            return elements
        },  write: {
            let count = $0.body.count(as: T.self)
            var elements = [T]()
            
            while !$0.body.isEmpty {
                elements.append($0.load(as: T.self))
                $0 = $0.drop(as: T.self)
            }
            
            test.same(count, IX(elements.count), "count [1]")
            return elements
        })
    }
    
    func prefix<T>(_ count: UX, as type: T.Type, is expectation: [T]) where T: SystemsInteger & UnsignedInteger {
        self.expect(expectation, read: {
            var elements = [T]()
            
            for _ in 0 ..< count {
                elements.append($0.load(as: T.self))
                $0 = $0.drop(as: T.self)
            }
            
            return elements
        },  write: {
            var elements = [T]()
            
            for _ in 0 ..< count {
                elements.append($0.load(as: T.self))
                $0 = $0.drop(as: T.self)
            }
            
            return elements
        })
    }
    
    func normalized<T>(as type: T.Type, is expectation: [T]) where T: SystemsInteger & UnsignedInteger {
        self.expect(expectation, read: {
            var elements = [T]()
            $0 = $0.normalized()
            
            while !$0.body.isEmpty {
                elements.append($0.load(as: T.self))
                $0 = $0.drop(as: T.self)
            }
            
            return elements
        },  write: {
            var elements = [T]()
            $0 = $0.normalized()
            
            while !$0.body.isEmpty {
                elements.append($0.load(as: T.self))
                $0 = $0.drop(as: T.self)
            }
            
            return elements
        })
    }
}
